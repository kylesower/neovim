// Much of the code in this handler is adapted from the handlers that
// Ghostty uses.
// https://github.com/ghostty-org/ghostty/blob/9a21e563114b8b1eb1501d03a087af8d23e508d3/src/terminal/stream_readonly.zig
// https://github.com/ghostty-org/ghostty/blob/9a21e563114b8b1eb1501d03a087af8d23e508d3/src/termio/stream_handler.zig
//
// MIT License
//
// Copyright (c) 2024 Mitchell Hashimoto, Ghostty contributors
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
const std = @import("std");
const testing = std.testing;
// TODO: maybe use the assert that Ghostty uses, which is slightly different
// from stdlib to ensure it gets optimized out in ReleaseFast builds.
const assert = std.debug.assert;
const ghostty_vt = @import("ghostty-vt");
const vterm = @import("../root.zig").vterm;
const log = @import("../root.zig").log.scoped(.vterm_handler);
const c = @import("../root.zig").c;
const DcsHandler = ghostty_vt.dcs.Handler;
const ApcHandler = ghostty_vt.apc.Handler;
const VTermPos = vterm.VTermPos;
const VTermProp = vterm.VTermProp;
// const VTermValue = vterm.VTermValue;
const Action = ghostty_vt.StreamAction;
const Screen = ghostty_vt.Screen;
// const modes = @import("modes.zig");
const modes = ghostty_vt.modes;
// const osc_color = @import("osc/color.zig");
const osc_color = ghostty_vt.osc.color;
// const kitty_color = @import("kitty/color.zig");
const kitty_color = ghostty_vt.kitty.color;
// const Terminal = @import("Terminal.zig");
const Terminal = ghostty_vt.Terminal;
const Allocator = std.mem.Allocator;

/// This is a Stream implementation that processes actions against
/// a Terminal and updates the Terminal state. It is called "readonly" because
/// it only processes actions that modify terminal state, while ignoring
/// any actions that require a response (like queries).
///
/// If you're implementing a terminal emulator that only needs to render
/// output and doesn't need to respond (since it maybe isn't running the
/// actual program), this is the stream type to use. For example, this is
/// ideal for replay tooling, CI logs, PaaS builder output, etc.
pub const Stream = ghostty_vt.Stream(Handler);

/// See Stream, which is just the stream wrapper around this.
///
/// This isn't attached directly to Terminal because there is additional
/// state and options we plan to add in the future, such as APC/DCS which
/// don't make sense to me to add to the Terminal directly. Instead, you
/// can call `vtHandler` on Terminal to initialize this handler.
pub const Handler = struct {
    alloc: Allocator,
    /// The terminal state to modify.
    terminal: *Terminal,
    callbacks: VTermZCallbacks = .{},
    cbdata: ?*anyopaque = null,
    // Used to send data back to controlling terminal
    msg_writer: ?vterm.VTermMsgWriter = null,
    // Terminal handle
    // outdata: *anyopaque,
    dcs: DcsHandler,
    apc: ApcHandler,

    pub fn init(terminal: *Terminal, allocator: Allocator) Handler {
        return .{
            .terminal = terminal,
            .alloc = allocator,
            .dcs = .{},
            .apc = .{},
        };
    }

    pub fn term_send(self: *Handler, msg: []const u8) void {
        if (self.msg_writer) |w| w.send(msg);
    }

    pub fn deinit(self: *Handler) void {
        self.apc.deinit();
        self.dcs.deinit();
        // if (comptime tmux_enabled) tmux: {
        //     const viewer = self.tmux_viewer orelse break :tmux;
        //     viewer.deinit();
        //     self.alloc.destroy(viewer);
        //     self.tmux_viewer = null;
        // }
    }

    pub fn vt(
        self: *Handler,
        comptime action: Action.Tag,
        value: Action.Value(action),
    ) !void {
        const cursor_init = self.terminal.screens.active.cursor;
        const cursor_y_init_abs = self.terminal.screens.active.pages.total_rows - self.terminal.rows + cursor_init.y;
        switch (action) {
            .print => try self.terminal.print(value.cp),
            .print_repeat => try self.terminal.printRepeat(value),
            .backspace => self.terminal.backspace(),
            .carriage_return => self.terminal.carriageReturn(),
            .linefeed => try self.terminal.linefeed(),
            .index => try self.terminal.index(),
            .next_line => {
                try self.terminal.index();
                self.terminal.carriageReturn();
            },
            .reverse_index => self.terminal.reverseIndex(),
            .cursor_up => self.terminal.cursorUp(value.value),

            .cursor_down => self.terminal.cursorDown(value.value),
            .cursor_left => self.terminal.cursorLeft(value.value),
            .cursor_right => self.terminal.cursorRight(value.value),
            .cursor_pos => self.terminal.setCursorPos(value.row, value.col),
            .cursor_col => self.terminal.setCursorPos(self.terminal.screens.active.cursor.y + 1, value.value),
            .cursor_row => self.terminal.setCursorPos(value.value, self.terminal.screens.active.cursor.x + 1),
            .cursor_col_relative => self.terminal.setCursorPos(
                self.terminal.screens.active.cursor.y + 1,
                self.terminal.screens.active.cursor.x + 1 +| value.value,
            ),
            .cursor_row_relative => self.terminal.setCursorPos(
                self.terminal.screens.active.cursor.y + 1 +| value.value,
                self.terminal.screens.active.cursor.x + 1,
            ),
            .cursor_style => {
                const blink = switch (value) {
                    .default, .steady_block, .steady_bar, .steady_underline => false,
                    .blinking_block, .blinking_bar, .blinking_underline => true,
                };
                const style: Screen.CursorStyle = switch (value) {
                    .default, .blinking_block, .steady_block => .block,
                    .blinking_bar, .steady_bar => .bar,
                    .blinking_underline, .steady_underline => .underline,
                };
                self.terminal.modes.set(.cursor_blinking, blink);
                self.terminal.screens.active.cursor.cursor_style = style;
                if (self.callbacks.cursor_style) |cursor_style| {
                    _ = cursor_style(
                        .{
                            .blink = blink,
                            .visible = self.terminal.modes.get(.cursor_visible),
                            .shape = switch (style) {
                                .block => c.VTERMZ_CURSOR_BLOCK,
                                .bar => c.VTERMZ_CURSOR_BAR,
                                .underline => c.VTERMZ_CURSOR_UNDERLINE,
                                else => c.VTERMZ_CURSOR_BLOCK,
                            },
                        },
                        self.cbdata,
                    );
                }
            },
            .erase_display_below => self.terminal.eraseDisplay(.below, value),
            .erase_display_above => self.terminal.eraseDisplay(.above, value),
            .erase_display_complete => self.terminal.eraseDisplay(.complete, value),
            .erase_display_scrollback => self.terminal.eraseDisplay(.scrollback, value),
            .erase_display_scroll_complete => self.terminal.eraseDisplay(.scroll_complete, value),
            .erase_line_right => self.terminal.eraseLine(.right, value),
            .erase_line_left => self.terminal.eraseLine(.left, value),
            .erase_line_complete => self.terminal.eraseLine(.complete, value),
            .erase_line_right_unless_pending_wrap => self.terminal.eraseLine(.right_unless_pending_wrap, value),
            .delete_chars => self.terminal.deleteChars(value),
            .erase_chars => self.terminal.eraseChars(value),
            .insert_lines => self.terminal.insertLines(value),
            .insert_blanks => self.terminal.insertBlanks(value),
            .delete_lines => self.terminal.deleteLines(value),
            .scroll_up => try self.terminal.scrollUp(value),
            .scroll_down => self.terminal.scrollDown(value),
            .horizontal_tab => try self.horizontalTab(value),
            .horizontal_tab_back => try self.horizontalTabBack(value),
            .tab_clear_current => self.terminal.tabClear(.current),
            .tab_clear_all => self.terminal.tabClear(.all),
            .tab_set => self.terminal.tabSet(),
            .tab_reset => self.terminal.tabReset(),
            .set_mode => try self.setMode(value.mode, true),
            .reset_mode => try self.setMode(value.mode, false),
            .save_mode => self.terminal.modes.save(value.mode),
            .restore_mode => {
                const v = self.terminal.modes.restore(value.mode);
                try self.setMode(value.mode, v);
            },
            .top_and_bottom_margin => self.terminal.setTopAndBottomMargin(value.top_left, value.bottom_right),
            .left_and_right_margin => self.terminal.setLeftAndRightMargin(value.top_left, value.bottom_right),
            .left_and_right_margin_ambiguous => {
                if (self.terminal.modes.get(.enable_left_and_right_margin)) {
                    self.terminal.setLeftAndRightMargin(0, 0);
                } else {
                    self.terminal.saveCursor();
                }
            },
            .save_cursor => self.terminal.saveCursor(),
            .restore_cursor => {
                try self.terminal.restoreCursor();
            },
            .invoke_charset => self.terminal.invokeCharset(value.bank, value.charset, value.locking),
            .configure_charset => self.terminal.configureCharset(value.slot, value.charset),
            .set_attribute => switch (value) {
                .unknown => {},
                else => self.terminal.setAttribute(value) catch {},
            },
            .protected_mode_off => self.terminal.setProtectedMode(.off),
            .protected_mode_iso => self.terminal.setProtectedMode(.iso),
            .protected_mode_dec => self.terminal.setProtectedMode(.dec),
            .mouse_shift_capture => self.terminal.flags.mouse_shift_capture = if (value) .true else .false,
            .kitty_keyboard_push => self.terminal.screens.active.kitty_keyboard.push(value.flags),
            .kitty_keyboard_pop => self.terminal.screens.active.kitty_keyboard.pop(@intCast(value)),
            .kitty_keyboard_set => self.terminal.screens.active.kitty_keyboard.set(.set, value.flags),
            .kitty_keyboard_set_or => self.terminal.screens.active.kitty_keyboard.set(.@"or", value.flags),
            .kitty_keyboard_set_not => self.terminal.screens.active.kitty_keyboard.set(.not, value.flags),
            .modify_key_format => {
                self.terminal.flags.modify_other_keys_2 = false;
                switch (value) {
                    .other_keys_numeric => self.terminal.flags.modify_other_keys_2 = true,
                    else => {},
                }
            },
            .active_status_display => self.terminal.status_display = value,
            .decaln => try self.terminal.decaln(),
            .full_reset => self.terminal.fullReset(),
            .start_hyperlink => try self.terminal.screens.active.startHyperlink(value.uri, value.id),
            .end_hyperlink => self.terminal.screens.active.endHyperlink(),
            .prompt_start => {
                self.terminal.screens.active.cursor.page_row.semantic_prompt = .prompt;
                self.terminal.flags.shell_redraws_prompt = value.redraw;
            },
            .prompt_continuation => self.terminal.screens.active.cursor.page_row.semantic_prompt = .prompt_continuation,
            .prompt_end => self.terminal.markSemanticPrompt(.input),
            .end_of_input => self.terminal.markSemanticPrompt(.command),
            .end_of_command => self.terminal.screens.active.cursor.page_row.semantic_prompt = .input,
            .mouse_shape => self.terminal.mouse_shape = value,
            .color_operation => try self.colorOperation(value.op, &value.requests, value.terminator),
            .kitty_color_report => try self.kittyColorOperation(value),

            .dcs_hook => try self.dcsHook(value),
            .dcs_put => try self.dcsPut(value),
            .dcs_unhook => try self.dcsUnhook(),

            .apc_start => self.apc.start(),
            .apc_put => self.apc.feed(self.alloc, value),
            .apc_end => try self.apcEnd(),

            // Have no terminal-modifying effect
            .bell => _ = if (self.callbacks.bell) |bell| bell(self.cbdata),
            .device_attributes => {},
            .device_status => try self.deviceStatusReport(value.request),
            .request_mode => try self.requestMode(value.mode),
            .request_mode_unknown => try self.requestModeUnknown(value.mode, value.ansi),
            .enquiry,
            .size_report,
            .xtversion,
            .kitty_keyboard_query,
            .window_title,
            .report_pwd,
            .show_desktop_notification,
            .progress_report,
            .clipboard_contents,
            .title_push,
            .title_pop,
            => {},
        }

        const cursor_x = self.terminal.screens.active.cursor.x;
        const cursor_y = self.terminal.screens.active.cursor.y;
        const cursor_y_abs = self.terminal.screens.active.pages.total_rows - self.terminal.rows + cursor_y;
        if (cursor_x != cursor_init.x or cursor_y != cursor_init.y or cursor_y_abs != cursor_y_init_abs) {
            if (self.callbacks.movecursor) |movecursor| {
                _ = movecursor(
                    cursor_y,
                    cursor_x,
                    @intCast(cursor_y_abs),
                    self.cbdata,
                );
            }
        }
    }

    inline fn horizontalTab(self: *Handler, count: u16) !void {
        for (0..count) |_| {
            const x = self.terminal.screens.active.cursor.x;
            try self.terminal.horizontalTab();
            if (x == self.terminal.screens.active.cursor.x) break;
        }
    }

    inline fn horizontalTabBack(self: *Handler, count: u16) !void {
        for (0..count) |_| {
            const x = self.terminal.screens.active.cursor.x;
            try self.terminal.horizontalTabBack();
            if (x == self.terminal.screens.active.cursor.x) break;
        }
    }

    fn setMode(self: *Handler, mode: modes.Mode, enabled: bool) !void {
        // Set the mode on the terminal
        self.terminal.modes.set(mode, enabled);

        // Some modes require additional processing
        switch (mode) {
            .autorepeat,
            .reverse_colors,
            => {},

            .origin => {
                self.terminal.setCursorPos(1, 1);
            },

            .enable_left_and_right_margin => if (!enabled) {
                self.terminal.scrolling_region.left = 0;
                self.terminal.scrolling_region.right = self.terminal.cols - 1;
            },

            .alt_screen_legacy => try self.terminal.switchScreenMode(.@"47", enabled),
            .alt_screen => try self.terminal.switchScreenMode(.@"1047", enabled),
            .alt_screen_save_cursor_clear_enter => try self.terminal.switchScreenMode(.@"1049", enabled),

            .cursor_visible => {
                if (self.callbacks.cursor_style) |cursor_style| {
                    _ = cursor_style(
                        .{
                            .blink = self.terminal.modes.get(.cursor_blinking),
                            .visible = enabled,
                            .shape = switch (self.terminal.screens.active.cursor.cursor_style) {
                                .block => c.VTERMZ_CURSOR_BLOCK,
                                .bar => c.VTERMZ_CURSOR_BAR,
                                .underline => c.VTERMZ_CURSOR_UNDERLINE,
                                else => c.VTERMZ_CURSOR_BLOCK,
                            },
                        },
                        self.cbdata,
                    );
                }
            },

            .save_cursor => if (enabled) {
                self.terminal.saveCursor();
            } else {
                try self.terminal.restoreCursor();
            },

            .enable_mode_3 => {},

            .@"132_column" => try self.terminal.deccolm(
                self.terminal.screens.active.alloc,
                if (enabled) .@"132_cols" else .@"80_cols",
            ),

            .synchronized_output,
            .linefeed,
            .in_band_size_reports,
            .focus_event,
            => {},

            .mouse_event_x10 => {
                if (enabled) {
                    self.terminal.flags.mouse_event = .x10;
                } else {
                    self.terminal.flags.mouse_event = .none;
                }
            },
            .mouse_event_normal => {
                if (enabled) {
                    self.terminal.flags.mouse_event = .normal;
                } else {
                    self.terminal.flags.mouse_event = .none;
                }
            },
            .mouse_event_button => {
                if (enabled) {
                    self.terminal.flags.mouse_event = .button;
                } else {
                    self.terminal.flags.mouse_event = .none;
                }
            },
            .mouse_event_any => {
                if (enabled) {
                    self.terminal.flags.mouse_event = .any;
                } else {
                    self.terminal.flags.mouse_event = .none;
                }
            },

            .mouse_format_utf8 => self.terminal.flags.mouse_format = if (enabled) .utf8 else .x10,
            .mouse_format_sgr => self.terminal.flags.mouse_format = if (enabled) .sgr else .x10,
            .mouse_format_urxvt => self.terminal.flags.mouse_format = if (enabled) .urxvt else .x10,
            .mouse_format_sgr_pixels => self.terminal.flags.mouse_format = if (enabled) .sgr_pixels else .x10,

            else => {},
        }
    }

    // I think libvterm doesn't actually support this.
    fn requestMode(self: *Handler, mode: ghostty_vt.modes.Mode) !void {
        const tag: ghostty_vt.modes.ModeTag = @bitCast(@intFromEnum(mode));
        const code: u8 = if (self.terminal.modes.get(mode)) 1 else 2;

        var buf: [64]u8 = undefined;
        const resp = try std.fmt.bufPrint(
            &buf,
            "\x1B[{s}{};{}$y",
            .{
                if (tag.ansi) "" else "?",
                tag.value,
                code,
            },
        );
        self.term_send(resp);
    }

    fn requestModeUnknown(self: *Handler, mode_raw: u16, ansi: bool) !void {
        var buf: [64]u8 = undefined;
        const resp = try std.fmt.bufPrint(
            &buf,
            "\x1B[{s}{};0$y",
            .{
                if (ansi) "" else "?",
                mode_raw,
            },
        );
        self.term_send(resp);
    }

    fn colorOperation(
        self: *Handler,
        op: osc_color.Operation,
        requests: *const osc_color.List,
        terminator: ghostty_vt.osc.Terminator,
    ) !void {
        if (requests.count() == 0) return;
        const command: c_int = switch (op) {
            .osc_4 => 4,
            .osc_5 => 5,
            .osc_10 => 10,
            .osc_11 => 11,
            .osc_12 => 12,
            .osc_13 => 13,
            .osc_14 => 14,
            .osc_15 => 15,
            .osc_16 => 16,
            .osc_17 => 17,
            .osc_18 => 18,
            .osc_19 => 19,
            .osc_104 => 104,
            .osc_105 => 105,
            .osc_110 => 110,
            .osc_111 => 111,
            .osc_112 => 112,
            .osc_113 => 113,
            .osc_114 => 114,
            .osc_115 => 115,
            .osc_116 => 116,
            .osc_117 => 117,
            .osc_118 => 118,
            .osc_119 => 119,
        };

        const cterminator = switch (terminator) {
            .st => vterm.VTermZTerminator.VTERMZ_TERMINATOR_ST,
            .bel => vterm.VTermZTerminator.VTERMZ_TERMINATOR_BEL,
        };

        var buf: [64]u8 = undefined;
        var bufw = std.Io.Writer.fixed(&buf);

        var osc: VTermZOscColor = .{
            .command = command,
            .buf = &buf,
            .len = 0,
            .terminator = cterminator,
        };

        var it = requests.constIterator(0);
        while (it.next()) |req| {
            switch (req.*) {
                .set => |set| {
                    switch (set.target) {
                        .palette => |i| {
                            self.terminal.flags.dirty.palette = true;
                            self.terminal.colors.palette.set(i, set.color);
                            bufw.print(
                                "{};rgb:{x:0>2}/{x:0>2}/{x:0>2}",
                                .{ i, set.color.r, set.color.g, set.color.b },
                            ) catch {};
                        },
                        .dynamic => |dynamic| switch (dynamic) {
                            .foreground => {
                                self.terminal.colors.foreground.set(set.color);
                                bufw.print(
                                    "rgb:{x:0>2}/{x:0>2}/{x:0>2}",
                                    .{ set.color.r, set.color.g, set.color.b },
                                ) catch {};
                            },
                            .background => {
                                self.terminal.colors.background.set(set.color);
                                bufw.print(
                                    "rgb:{x:0>2}/{x:0>2}/{x:0>2}",
                                    .{ set.color.r, set.color.g, set.color.b },
                                ) catch {};
                            },
                            .cursor => {
                                self.terminal.colors.cursor.set(set.color);
                                bufw.print(
                                    "rgb:{x:0>2}/{x:0>2}/{x:0>2}",
                                    .{ set.color.r, set.color.g, set.color.b },
                                ) catch {};
                            },
                            .pointer_foreground,
                            .pointer_background,
                            .tektronix_foreground,
                            .tektronix_background,
                            .highlight_background,
                            .tektronix_cursor,
                            .highlight_foreground,
                            => {},
                        },
                        .special => {},
                    }
                },

                // TODO: bufw print these.
                .reset => |target| switch (target) {
                    .palette => |i| {
                        self.terminal.flags.dirty.palette = true;
                        self.terminal.colors.palette.reset(i);
                    },
                    .dynamic => |dynamic| switch (dynamic) {
                        .foreground => self.terminal.colors.foreground.reset(),
                        .background => self.terminal.colors.background.reset(),
                        .cursor => self.terminal.colors.cursor.reset(),
                        .pointer_foreground,
                        .pointer_background,
                        .tektronix_foreground,
                        .tektronix_background,
                        .highlight_background,
                        .tektronix_cursor,
                        .highlight_foreground,
                        => {},
                    },
                    .special => {},
                },

                .reset_palette => {
                    const mask = &self.terminal.colors.palette.mask;
                    var mask_it = mask.iterator(.{});
                    while (mask_it.next()) |i| {
                        self.terminal.flags.dirty.palette = true;
                        self.terminal.colors.palette.reset(@intCast(i));
                    }
                    mask.* = .initEmpty();
                },

                .query => |value| {
                    switch (value) {
                        .palette => |idx| bufw.print(
                            "{};?",
                            .{idx},
                        ) catch {},
                        .special => |sp| bufw.print(
                            "{};?",
                            .{sp.osc4()},
                        ) catch {},
                        .dynamic => bufw.print("?", .{}) catch {},
                    }
                },
                .reset_special,
                => {},
            }

            const written = bufw.buffered();
            if (written.len == 0) continue;
            if (self.callbacks.osc_color) |on_osc_color| {
                osc.buf = written.ptr;
                osc.len = written.len;
                _ = on_osc_color(osc, self.cbdata);
            }

            _ = bufw.consumeAll();
        }
    }

    fn kittyColorOperation(
        self: *Handler,
        request: kitty_color.OSC,
    ) !void {
        // TODO: create callback for this
        for (request.list.items) |item| {
            switch (item) {
                .set => |v| switch (v.key) {
                    .palette => |palette| {
                        self.terminal.flags.dirty.palette = true;
                        self.terminal.colors.palette.set(palette, v.color);
                    },
                    .special => |special| switch (special) {
                        .foreground => self.terminal.colors.foreground.set(v.color),
                        .background => self.terminal.colors.background.set(v.color),
                        .cursor => self.terminal.colors.cursor.set(v.color),
                        else => {},
                    },
                },
                .reset => |key| switch (key) {
                    .palette => |palette| {
                        self.terminal.flags.dirty.palette = true;
                        self.terminal.colors.palette.reset(palette);
                    },
                    .special => |special| switch (special) {
                        .foreground => self.terminal.colors.foreground.reset(),
                        .background => self.terminal.colors.background.reset(),
                        .cursor => self.terminal.colors.cursor.reset(),
                        else => {},
                    },
                },
                .query => {},
            }
        }
    }

    pub fn deviceAttributes(
        self: *Handler,
        req: ghostty_vt.DeviceAttributeReq,
    ) !void {
        // For the below, we quack as a VT220. We don't quack as
        // a 420 because we don't support DCS sequences.
        switch (req) {
            // 62 = Level 2 conformance
            // 22 = Color text
            // 52 = Clipboard access
            // TODO: configurable clipboard access?
            // .write_stable = if (self.clipboard_write != .deny)
            //     "\x1B[?62;22;52c"
            // else
            //     "\x1B[?62;22c",
            .primary => self.term_send("\x1B[?62;22;52c"),
            .secondary => self.term_send("\x1B[>1;10;0c"),
            else => log.warn_scoped(@src(), .vterm_handler, "unimplemented device attributes req: {}", .{req}),
        }
    }

    pub fn deviceStatusReport(
        self: *Handler,
        req: ghostty_vt.device_status.Request,
    ) !void {
        var buf: [64]u8 = undefined;
        var bufw = std.Io.Writer.fixed(&buf);

        switch (req) {
            .operating_status => self.term_send("\x1B[0n"),

            .cursor_position => {
                const pos: struct {
                    x: usize,
                    y: usize,
                } = if (self.terminal.modes.get(.origin)) .{
                    .x = self.terminal.screens.active.cursor.x -| self.terminal.scrolling_region.left,
                    .y = self.terminal.screens.active.cursor.y -| self.terminal.scrolling_region.top,
                } else .{
                    .x = self.terminal.screens.active.cursor.x,
                    .y = self.terminal.screens.active.cursor.y,
                };

                bufw.print("\x1B[{};{}R", .{ pos.y + 1, pos.x + 1 }) catch return;
                self.term_send(bufw.buffered());
                _ = bufw.consumeAll();
            },

            // TODO: write msg
            .color_scheme => {}, // self.surfaceMessageWriter(.{ .report_color_scheme = true }),
        }
    }

    pub inline fn dcsHook(self: *Handler, dcs: ghostty_vt.DCS) !void {
        var cmd = self.dcs.hook(self.alloc, dcs) orelse return;
        defer cmd.deinit();
        try self.dcsCommand(&cmd);
    }

    pub inline fn dcsPut(self: *Handler, byte: u8) !void {
        var cmd = self.dcs.put(byte) orelse return;
        defer cmd.deinit();
        try self.dcsCommand(&cmd);
    }

    pub inline fn dcsUnhook(self: *Handler) !void {
        var cmd = self.dcs.unhook() orelse return;
        defer cmd.deinit();
        try self.dcsCommand(&cmd);
    }

    fn dcsCommand(self: *Handler, cmd: *ghostty_vt.dcs.Command) !void {
        switch (cmd.*) {
            .tmux => {},
            // .tmux => |tmux| tmux: {
            //     // If tmux control mode is disabled at the build level,
            //     // then this whole block shouldn't be analyzed.
            //     if (comptime !tmux_enabled) break :tmux;
            //     log.info("tmux control mode event cmd={f}", .{tmux});
            //
            //     switch (tmux) {
            //         .enter => {
            //             // Setup our viewer state
            //             assert(self.tmux_viewer == null);
            //             const viewer = try self.alloc.create(terminal.tmux.Viewer);
            //             errdefer self.alloc.destroy(viewer);
            //             viewer.* = try .init(self.alloc);
            //             errdefer viewer.deinit();
            //             self.tmux_viewer = viewer;
            //             break :tmux;
            //         },
            //
            //         .exit => if (self.tmux_viewer) |viewer| {
            //             // Free our viewer state
            //             viewer.deinit();
            //             self.alloc.destroy(viewer);
            //             self.tmux_viewer = null;
            //             break :tmux;
            //         },
            //
            //         else => {},
            //     }
            //
            //     assert(tmux != .enter);
            //     assert(tmux != .exit);
            //
            //     const viewer = self.tmux_viewer orelse {
            //         // This can only really happen if we failed to
            //         // initialize the viewer on enter.
            //         log.info(
            //             "received tmux control mode command without viewer: {f}",
            //             .{tmux},
            //         );
            //
            //         break :tmux;
            //     };
            //
            //     for (viewer.next(.{ .tmux = tmux })) |action| {
            //         log.info("tmux viewer action={f}", .{action});
            //         switch (action) {
            //             .exit => {
            //                 // We ignore this because we will fully exit when
            //                 // our DCS connection ends. We may want to handle
            //                 // this in the future to notify our GUI we're
            //                 // disconnected though.
            //             },
            //
            //             .command => |command| {
            //                 assert(command.len > 0);
            //                 assert(command[command.len - 1] == '\n');
            //                 self.messageWriter(try termio.Message.writeReq(
            //                     self.alloc,
            //                     command,
            //                 ));
            //             },
            //
            //             .windows => {
            //                 // TODO
            //             },
            //         }
            //     }
            // },

            .xtgettcap => |*gettcap| {
                _ = gettcap;
                // TODO: see if I can get this out of ghostty_vt. Right now it doesn't
                // seem to be exposed.
                // const map = comptime terminfo.ghostty.xtgettcapMap();
                // while (gettcap.next()) |key| {
                //     const response = map.get(key) orelse continue;
                //     self.messageWriter(.{ .write_stable = response });
                // }
            },

            .decrqss => |decrqss| {
                var response: [128]u8 = undefined;
                var stream = std.io.fixedBufferStream(&response);
                const writer = stream.writer();

                // Offset the stream position to just past the response prefix.
                // We will write the "payload" (if any) below. If no payload is
                // written then we send an invalid DECRPSS response.
                const prefix_fmt = "\x1bP{d}$r";
                const prefix_len = std.fmt.comptimePrint(prefix_fmt, .{0}).len;
                stream.pos = prefix_len;

                switch (decrqss) {
                    // Invalid or unhandled request
                    .none => {},

                    .sgr => {
                        const buf = try self.terminal.printAttributes(stream.buffer[stream.pos..]);

                        // printAttributes wrote into our buffer, so adjust the stream
                        // position
                        stream.pos += buf.len;

                        try writer.writeByte('m');
                    },

                    .decscusr => {
                        const blink = self.terminal.modes.get(.cursor_blinking);
                        const style: u8 = switch (self.terminal.screens.active.cursor.cursor_style) {
                            .block => if (blink) 1 else 2,
                            .underline => if (blink) 3 else 4,
                            .bar => if (blink) 5 else 6,

                            // Below here, the cursor styles aren't represented by
                            // DECSCUSR so we map it to some other style.
                            .block_hollow => if (blink) 1 else 2,
                        };
                        try writer.print("{d} q", .{style});
                    },

                    .decstbm => {
                        try writer.print("{d};{d}r", .{
                            self.terminal.scrolling_region.top + 1,
                            self.terminal.scrolling_region.bottom + 1,
                        });
                    },

                    .decslrm => {
                        // We only send a valid response when left and right
                        // margin mode (DECLRMM) is enabled.
                        if (self.terminal.modes.get(.enable_left_and_right_margin)) {
                            try writer.print("{d};{d}s", .{
                                self.terminal.scrolling_region.left + 1,
                                self.terminal.scrolling_region.right + 1,
                            });
                        }
                    },
                }

                // Our response is valid if we have a response payload
                const valid = stream.pos > prefix_len;

                // Write the terminator
                try writer.writeAll("\x1b\\");

                // Write the response prefix into the buffer
                // const msg = try termio.Message.writeReq(self.alloc, response[0..stream.pos]);
                // self.messageWriter(msg);
                // TODO: make sure this works
                _ = try std.fmt.bufPrint(response[0..prefix_len], prefix_fmt, .{@intFromBool(valid)});
                self.term_send(response[0..stream.pos]);
            },
        }
    }

    pub fn apcEnd(self: *Handler) !void {
        var cmd = self.apc.end() orelse return;
        defer cmd.deinit(self.alloc);

        // log.warn("APC command: {}", .{cmd});
        switch (cmd) {
            // TODO: it seems kitty is currently unsupported in the zig module
            .kitty => |*kitty_cmd| _ = kitty_cmd,
            // TODO: kitty graphics :)
            // if (self.callbacks.on_apc) |apc| {
            //     apc(kitty_cmd.data.ptr, kitty_cmd.data.len, self.cbdata);
            // }
            // .kitty => |*kitty_cmd| {
            //     if (self.terminal.kittyGraphics(self.alloc, kitty_cmd)) |resp| {
            //         var buf: [1024]u8 = undefined;
            //         var writer: std.Io.Writer = .fixed(&buf);
            //         try resp.encode(&writer);
            //         const final = writer.buffered();
            //         if (final.len > 2) {
            //             log.debug("kitty graphics response: {x}", .{final});
            //             self.messageWriter(try termio.Message.writeReq(self.alloc, final));
            //         }
            //     }
            // },
        }
    }
};

pub const VTermZOscColor = extern struct {
    command: c_int,
    buf: [*]const u8,
    len: usize = 0,
    terminator: vterm.VTermZTerminator,
};

pub const VTermZCallbacks = extern struct {
    // damage: ?*const fn (rect: VTermRect, user: *anyopaque) callconv(.c) c_int,
    // moverect: ?*const fn (dest: VTermRect, src: VTermRect, user: *anyopaque) callconv(.c) c_int,
    movecursor: ?*const fn (
        row: c_int,
        col: c_int,
        row_abs: c_int,
        user: ?*anyopaque,
    ) callconv(.c) c_int = null,
    // settermprop: ?*const fn (
    //     prop: VTermProp,
    //     val: *VTermValue,
    //     user: ?*anyopaque,
    // ) callconv(.c) c_int = null,
    bell: ?*const fn (user: ?*anyopaque) callconv(.c) c_int = null,
    theme: ?*const fn (dark: *bool, user: ?*anyopaque) callconv(.c) c_int = null,
    osc_color: ?*const fn (osc: VTermZOscColor, user: ?*anyopaque) callconv(.c) c_int = null,
    on_apc: ?*const fn (buf: [*]const u8, len: usize, user: ?*anyopaque) callconv(.c) c_int = null,
    on_dcs: ?*const fn (buf: [*]const u8, len: usize, user: ?*anyopaque) callconv(.c) c_int = null,
    cursor_style: ?*const fn (style: c.VTermZCursorStyle, user: ?*anyopaque) callconv(.c) c_int = null,
    // sb_pushline: ?*const fn (
    //     cols: c_int,
    //     cells: [*]const VTermScreenCell,
    //     user: *anyopaque,
    // ) callconv(.c) c_int,
    // sb_popline: ?*const fn (
    //     cols: c_int,
    //     cells: [*]VTermScreenCell,
    //     user: *anyopaque,
    // ) callconv(.c) c_int,
    // sb_clear: ?*const fn (user: *anyopaque) callconv(.c) c_int,
};

// test "basic print" {
//     var t: Terminal = try .init(testing.allocator, .{ .cols = 10, .rows = 10 });
//     defer t.deinit(testing.allocator);
//
//     var s: Stream = .initAlloc(testing.allocator, .init(&t));
//     defer s.deinit();
//
//     try s.nextSlice("Hello");
//     try testing.expectEqual(@as(usize, 5), t.screens.active.cursor.x);
//     try testing.expectEqual(@as(usize, 0), t.screens.active.cursor.y);
//
//     const str = try t.plainString(testing.allocator);
//     defer testing.allocator.free(str);
//     try testing.expectEqualStrings("Hello", str);
// }
//
// test "cursor movement" {
//     var t: Terminal = try .init(testing.allocator, .{ .cols = 10, .rows = 10 });
//     defer t.deinit(testing.allocator);
//
//     var s: Stream = .initAlloc(testing.allocator, .init(&t));
//     defer s.deinit();
//
//     // Move cursor using escape sequences
//     try s.nextSlice("Hello\x1B[1;1H");
//     try testing.expectEqual(@as(usize, 0), t.screens.active.cursor.x);
//     try testing.expectEqual(@as(usize, 0), t.screens.active.cursor.y);
//
//     // Move to position 2,3
//     try s.nextSlice("\x1B[2;3H");
//     try testing.expectEqual(@as(usize, 2), t.screens.active.cursor.x);
//     try testing.expectEqual(@as(usize, 1), t.screens.active.cursor.y);
// }
//
// test "erase operations" {
//     var t: Terminal = try .init(testing.allocator, .{ .cols = 20, .rows = 10 });
//     defer t.deinit(testing.allocator);
//
//     var s: Stream = .initAlloc(testing.allocator, .init(&t));
//     defer s.deinit();
//
//     // Print some text
//     try s.nextSlice("Hello World");
//     try testing.expectEqual(@as(usize, 11), t.screens.active.cursor.x);
//     try testing.expectEqual(@as(usize, 0), t.screens.active.cursor.y);
//
//     // Move cursor to position 1,6 and erase from cursor to end of line
//     try s.nextSlice("\x1B[1;6H");
//     try s.nextSlice("\x1B[K");
//
//     const str = try t.plainString(testing.allocator);
//     defer testing.allocator.free(str);
//     try testing.expectEqualStrings("Hello", str);
// }
//
// test "tabs" {
//     var t: Terminal = try .init(testing.allocator, .{ .cols = 80, .rows = 10 });
//     defer t.deinit(testing.allocator);
//
//     var s: Stream = .initAlloc(testing.allocator, .init(&t));
//     defer s.deinit();
//
//     try s.nextSlice("A\tB");
//     try testing.expectEqual(@as(usize, 9), t.screens.active.cursor.x);
//
//     const str = try t.plainString(testing.allocator);
//     defer testing.allocator.free(str);
//     try testing.expectEqualStrings("A       B", str);
// }
//
// test "modes" {
//     var t: Terminal = try .init(testing.allocator, .{ .cols = 80, .rows = 24 });
//     defer t.deinit(testing.allocator);
//
//     var s: Stream = .initAlloc(testing.allocator, .init(&t));
//     defer s.deinit();
//
//     // Test wraparound mode
//     try testing.expect(t.modes.get(.wraparound));
//     try s.nextSlice("\x1B[?7l"); // Disable wraparound
//     try testing.expect(!t.modes.get(.wraparound));
//     try s.nextSlice("\x1B[?7h"); // Enable wraparound
//     try testing.expect(t.modes.get(.wraparound));
// }
//
// test "scrolling regions" {
//     var t: Terminal = try .init(testing.allocator, .{ .cols = 80, .rows = 24 });
//     defer t.deinit(testing.allocator);
//
//     var s: Stream = .initAlloc(testing.allocator, .init(&t));
//     defer s.deinit();
//
//     // Set scrolling region from line 5 to 20
//     try s.nextSlice("\x1B[5;20r");
//     try testing.expectEqual(@as(usize, 4), t.scrolling_region.top);
//     try testing.expectEqual(@as(usize, 19), t.scrolling_region.bottom);
//     try testing.expectEqual(@as(usize, 0), t.scrolling_region.left);
//     try testing.expectEqual(@as(usize, 79), t.scrolling_region.right);
// }
//
// test "charsets" {
//     var t: Terminal = try .init(testing.allocator, .{ .cols = 80, .rows = 24 });
//     defer t.deinit(testing.allocator);
//
//     var s: Stream = .initAlloc(testing.allocator, .init(&t));
//     defer s.deinit();
//
//     // Configure G0 as DEC special graphics
//     try s.nextSlice("\x1B(0");
//     try s.nextSlice("`"); // Should print diamond character
//
//     const str = try t.plainString(testing.allocator);
//     defer testing.allocator.free(str);
//     try testing.expectEqualStrings("◆", str);
// }
//
// test "alt screen" {
//     var t: Terminal = try .init(testing.allocator, .{ .cols = 10, .rows = 5 });
//     defer t.deinit(testing.allocator);
//
//     var s: Stream = .initAlloc(testing.allocator, .init(&t));
//     defer s.deinit();
//
//     // Write to primary screen
//     try s.nextSlice("Primary");
//     try testing.expectEqual(.primary, t.screens.active_key);
//
//     // Switch to alt screen
//     try s.nextSlice("\x1B[?1049h");
//     try testing.expectEqual(.alternate, t.screens.active_key);
//
//     // Write to alt screen
//     try s.nextSlice("Alt");
//
//     // Switch back to primary
//     try s.nextSlice("\x1B[?1049l");
//     try testing.expectEqual(.primary, t.screens.active_key);
//
//     const str = try t.plainString(testing.allocator);
//     defer testing.allocator.free(str);
//     try testing.expectEqualStrings("Primary", str);
// }
//
// test "cursor save and restore" {
//     var t: Terminal = try .init(testing.allocator, .{ .cols = 80, .rows = 24 });
//     defer t.deinit(testing.allocator);
//
//     var s: Stream = .initAlloc(testing.allocator, .init(&t));
//     defer s.deinit();
//
//     // Move cursor to 10,15
//     try s.nextSlice("\x1B[10;15H");
//     try testing.expectEqual(@as(usize, 14), t.screens.active.cursor.x);
//     try testing.expectEqual(@as(usize, 9), t.screens.active.cursor.y);
//
//     // Save cursor
//     try s.nextSlice("\x1B7");
//
//     // Move cursor elsewhere
//     try s.nextSlice("\x1B[1;1H");
//     try testing.expectEqual(@as(usize, 0), t.screens.active.cursor.x);
//     try testing.expectEqual(@as(usize, 0), t.screens.active.cursor.y);
//
//     // Restore cursor
//     try s.nextSlice("\x1B8");
//     try testing.expectEqual(@as(usize, 14), t.screens.active.cursor.x);
//     try testing.expectEqual(@as(usize, 9), t.screens.active.cursor.y);
// }
//
// test "attributes" {
//     var t: Terminal = try .init(testing.allocator, .{ .cols = 80, .rows = 24 });
//     defer t.deinit(testing.allocator);
//
//     var s: Stream = .initAlloc(testing.allocator, .init(&t));
//     defer s.deinit();
//
//     // Set bold and write text
//     try s.nextSlice("\x1B[1mBold\x1B[0m");
//
//     // Verify we can write attributes - just check the string was written
//     const str = try t.plainString(testing.allocator);
//     defer testing.allocator.free(str);
//     try testing.expectEqualStrings("Bold", str);
// }
//
// test "DECALN screen alignment" {
//     var t: Terminal = try .init(testing.allocator, .{ .cols = 10, .rows = 3 });
//     defer t.deinit(testing.allocator);
//
//     var s: Stream = .initAlloc(testing.allocator, .init(&t));
//     defer s.deinit();
//
//     // Run DECALN
//     try s.nextSlice("\x1B#8");
//
//     // Verify entire screen is filled with 'E'
//     const str = try t.plainString(testing.allocator);
//     defer testing.allocator.free(str);
//     try testing.expectEqualStrings("EEEEEEEEEE\nEEEEEEEEEE\nEEEEEEEEEE", str);
//
//     // Cursor should be at 1,1
//     try testing.expectEqual(@as(usize, 0), t.screens.active.cursor.x);
//     try testing.expectEqual(@as(usize, 0), t.screens.active.cursor.y);
// }
//
// test "full reset" {
//     var t: Terminal = try .init(testing.allocator, .{ .cols = 80, .rows = 24 });
//     defer t.deinit(testing.allocator);
//
//     var s: Stream = .initAlloc(testing.allocator, .init(&t));
//     defer s.deinit();
//
//     // Make some changes
//     try s.nextSlice("Hello");
//     try s.nextSlice("\x1B[10;20H");
//     try s.nextSlice("\x1B[5;20r"); // Set scroll region
//     try s.nextSlice("\x1B[?7l"); // Disable wraparound
//
//     // Full reset
//     try s.nextSlice("\x1Bc");
//
//     // Verify reset state
//     try testing.expectEqual(@as(usize, 0), t.screens.active.cursor.x);
//     try testing.expectEqual(@as(usize, 0), t.screens.active.cursor.y);
//     try testing.expectEqual(@as(usize, 0), t.scrolling_region.top);
//     try testing.expectEqual(@as(usize, 23), t.scrolling_region.bottom);
//     try testing.expect(t.modes.get(.wraparound));
// }
//
// test "ignores query actions" {
//     var t: Terminal = try .init(testing.allocator, .{ .cols = 80, .rows = 24 });
//     defer t.deinit(testing.allocator);
//
//     var s: Stream = .initAlloc(testing.allocator, .init(&t));
//     defer s.deinit();
//
//     // These should be ignored without error
//     try s.nextSlice("\x1B[c"); // Device attributes
//     try s.nextSlice("\x1B[5n"); // Device status report
//     try s.nextSlice("\x1B[6n"); // Cursor position report
//
//     // Terminal should still be functional
//     try s.nextSlice("Test");
//     const str = try t.plainString(testing.allocator);
//     defer testing.allocator.free(str);
//     try testing.expectEqualStrings("Test", str);
// }
//
// test "OSC 4 set and reset palette" {
//     var t: Terminal = try .init(testing.allocator, .{ .cols = 10, .rows = 10 });
//     defer t.deinit(testing.allocator);
//
//     var s: Stream = .initAlloc(testing.allocator, .init(&t));
//     defer s.deinit();
//
//     // Save default color
//     const default_color_0 = t.colors.palette.original[0];
//
//     // Set color 0 to red
//     try s.nextSlice("\x1b]4;0;rgb:ff/00/00\x1b\\");
//     try testing.expectEqual(@as(u8, 0xff), t.colors.palette.current[0].r);
//     try testing.expectEqual(@as(u8, 0x00), t.colors.palette.current[0].g);
//     try testing.expectEqual(@as(u8, 0x00), t.colors.palette.current[0].b);
//     try testing.expect(t.colors.palette.mask.isSet(0));
//
//     // Reset color 0
//     try s.nextSlice("\x1b]104;0\x1b\\");
//     try testing.expectEqual(default_color_0, t.colors.palette.current[0]);
//     try testing.expect(!t.colors.palette.mask.isSet(0));
// }
//
// test "OSC 104 reset all palette colors" {
//     var t: Terminal = try .init(testing.allocator, .{ .cols = 10, .rows = 10 });
//     defer t.deinit(testing.allocator);
//
//     var s: Stream = .initAlloc(testing.allocator, .init(&t));
//     defer s.deinit();
//
//     // Set multiple colors
//     try s.nextSlice("\x1b]4;0;rgb:ff/00/00\x1b\\");
//     try s.nextSlice("\x1b]4;1;rgb:00/ff/00\x1b\\");
//     try s.nextSlice("\x1b]4;2;rgb:00/00/ff\x1b\\");
//     try testing.expect(t.colors.palette.mask.isSet(0));
//     try testing.expect(t.colors.palette.mask.isSet(1));
//     try testing.expect(t.colors.palette.mask.isSet(2));
//
//     // Reset all palette colors
//     try s.nextSlice("\x1b]104\x1b\\");
//     try testing.expectEqual(t.colors.palette.original[0], t.colors.palette.current[0]);
//     try testing.expectEqual(t.colors.palette.original[1], t.colors.palette.current[1]);
//     try testing.expectEqual(t.colors.palette.original[2], t.colors.palette.current[2]);
//     try testing.expect(!t.colors.palette.mask.isSet(0));
//     try testing.expect(!t.colors.palette.mask.isSet(1));
//     try testing.expect(!t.colors.palette.mask.isSet(2));
// }
//
// test "OSC 10 set and reset foreground color" {
//     var t: Terminal = try .init(testing.allocator, .{ .cols = 10, .rows = 10 });
//     defer t.deinit(testing.allocator);
//
//     var s: Stream = .initAlloc(testing.allocator, .init(&t));
//     defer s.deinit();
//
//     // Initially unset
//     try testing.expect(t.colors.foreground.get() == null);
//
//     // Set foreground to red
//     try s.nextSlice("\x1b]10;rgb:ff/00/00\x1b\\");
//     const fg = t.colors.foreground.get().?;
//     try testing.expectEqual(@as(u8, 0xff), fg.r);
//     try testing.expectEqual(@as(u8, 0x00), fg.g);
//     try testing.expectEqual(@as(u8, 0x00), fg.b);
//
//     // Reset foreground
//     try s.nextSlice("\x1b]110\x1b\\");
//     try testing.expect(t.colors.foreground.get() == null);
// }
//
// test "OSC 11 set and reset background color" {
//     var t: Terminal = try .init(testing.allocator, .{ .cols = 10, .rows = 10 });
//     defer t.deinit(testing.allocator);
//
//     var s: Stream = .initAlloc(testing.allocator, .init(&t));
//     defer s.deinit();
//
//     // Set background to green
//     try s.nextSlice("\x1b]11;rgb:00/ff/00\x1b\\");
//     const bg = t.colors.background.get().?;
//     try testing.expectEqual(@as(u8, 0x00), bg.r);
//     try testing.expectEqual(@as(u8, 0xff), bg.g);
//     try testing.expectEqual(@as(u8, 0x00), bg.b);
//
//     // Reset background
//     try s.nextSlice("\x1b]111\x1b\\");
//     try testing.expect(t.colors.background.get() == null);
// }
//
// test "OSC 12 set and reset cursor color" {
//     var t: Terminal = try .init(testing.allocator, .{ .cols = 10, .rows = 10 });
//     defer t.deinit(testing.allocator);
//
//     var s: Stream = .initAlloc(testing.allocator, .init(&t));
//     defer s.deinit();
//
//     // Set cursor to blue
//     try s.nextSlice("\x1b]12;rgb:00/00/ff\x1b\\");
//     const cursor = t.colors.cursor.get().?;
//     try testing.expectEqual(@as(u8, 0x00), cursor.r);
//     try testing.expectEqual(@as(u8, 0x00), cursor.g);
//     try testing.expectEqual(@as(u8, 0xff), cursor.b);
//
//     // Reset cursor
//     try s.nextSlice("\x1b]112\x1b\\");
//     // After reset, cursor might be null (using default)
// }
//
// test "kitty color protocol set palette" {
//     var t: Terminal = try .init(testing.allocator, .{ .cols = 10, .rows = 10 });
//     defer t.deinit(testing.allocator);
//
//     var s: Stream = .initAlloc(testing.allocator, .init(&t));
//     defer s.deinit();
//
//     // Set palette color 5 to magenta using kitty protocol
//     try s.nextSlice("\x1b]21;5=rgb:ff/00/ff\x1b\\");
//     try testing.expectEqual(@as(u8, 0xff), t.colors.palette.current[5].r);
//     try testing.expectEqual(@as(u8, 0x00), t.colors.palette.current[5].g);
//     try testing.expectEqual(@as(u8, 0xff), t.colors.palette.current[5].b);
//     try testing.expect(t.colors.palette.mask.isSet(5));
//     try testing.expect(t.flags.dirty.palette);
// }
//
// test "kitty color protocol reset palette" {
//     var t: Terminal = try .init(testing.allocator, .{ .cols = 10, .rows = 10 });
//     defer t.deinit(testing.allocator);
//
//     var s: Stream = .initAlloc(testing.allocator, .init(&t));
//     defer s.deinit();
//
//     // Set and then reset palette color
//     const original = t.colors.palette.original[7];
//     try s.nextSlice("\x1b]21;7=rgb:aa/bb/cc\x1b\\");
//     try testing.expect(t.colors.palette.mask.isSet(7));
//
//     try s.nextSlice("\x1b]21;7=\x1b\\");
//     try testing.expectEqual(original, t.colors.palette.current[7]);
//     try testing.expect(!t.colors.palette.mask.isSet(7));
// }
//
// test "kitty color protocol set foreground" {
//     var t: Terminal = try .init(testing.allocator, .{ .cols = 10, .rows = 10 });
//     defer t.deinit(testing.allocator);
//
//     var s: Stream = .initAlloc(testing.allocator, .init(&t));
//     defer s.deinit();
//
//     // Set foreground using kitty protocol
//     try s.nextSlice("\x1b]21;foreground=rgb:12/34/56\x1b\\");
//     const fg = t.colors.foreground.get().?;
//     try testing.expectEqual(@as(u8, 0x12), fg.r);
//     try testing.expectEqual(@as(u8, 0x34), fg.g);
//     try testing.expectEqual(@as(u8, 0x56), fg.b);
// }
//
// test "kitty color protocol set background" {
//     var t: Terminal = try .init(testing.allocator, .{ .cols = 10, .rows = 10 });
//     defer t.deinit(testing.allocator);
//
//     var s: Stream = .initAlloc(testing.allocator, .init(&t));
//     defer s.deinit();
//
//     // Set background using kitty protocol
//     try s.nextSlice("\x1b]21;background=rgb:78/9a/bc\x1b\\");
//     const bg = t.colors.background.get().?;
//     try testing.expectEqual(@as(u8, 0x78), bg.r);
//     try testing.expectEqual(@as(u8, 0x9a), bg.g);
//     try testing.expectEqual(@as(u8, 0xbc), bg.b);
// }
//
// test "kitty color protocol set cursor" {
//     var t: Terminal = try .init(testing.allocator, .{ .cols = 10, .rows = 10 });
//     defer t.deinit(testing.allocator);
//
//     var s: Stream = .initAlloc(testing.allocator, .init(&t));
//     defer s.deinit();
//
//     // Set cursor using kitty protocol
//     try s.nextSlice("\x1b]21;cursor=rgb:de/f0/12\x1b\\");
//     const cursor = t.colors.cursor.get().?;
//     try testing.expectEqual(@as(u8, 0xde), cursor.r);
//     try testing.expectEqual(@as(u8, 0xf0), cursor.g);
//     try testing.expectEqual(@as(u8, 0x12), cursor.b);
// }
//
// test "kitty color protocol reset foreground" {
//     var t: Terminal = try .init(testing.allocator, .{ .cols = 10, .rows = 10 });
//     defer t.deinit(testing.allocator);
//
//     var s: Stream = .initAlloc(testing.allocator, .init(&t));
//     defer s.deinit();
//
//     // Set and reset foreground
//     try s.nextSlice("\x1b]21;foreground=rgb:11/22/33\x1b\\");
//     try testing.expect(t.colors.foreground.get() != null);
//
//     try s.nextSlice("\x1b]21;foreground=\x1b\\");
//     // After reset, should be unset
//     try testing.expect(t.colors.foreground.get() == null);
// }
//
// test "palette dirty flag set on color change" {
//     var t: Terminal = try .init(testing.allocator, .{ .cols = 10, .rows = 10 });
//     defer t.deinit(testing.allocator);
//
//     var s: Stream = .initAlloc(testing.allocator, .init(&t));
//     defer s.deinit();
//
//     // Clear dirty flag
//     t.flags.dirty.palette = false;
//
//     // Setting palette color should set dirty flag
//     try s.nextSlice("\x1b]4;0;rgb:ff/00/00\x1b\\");
//     try testing.expect(t.flags.dirty.palette);
//
//     // Clear and test reset
//     t.flags.dirty.palette = false;
//     try s.nextSlice("\x1b]104;0\x1b\\");
//     try testing.expect(t.flags.dirty.palette);
//
//     // Clear and test kitty protocol
//     t.flags.dirty.palette = false;
//     try s.nextSlice("\x1b]21;1=rgb:00/ff/00\x1b\\");
//     try testing.expect(t.flags.dirty.palette);
// }
