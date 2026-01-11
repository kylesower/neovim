// #pragma once
//
// #include <stdarg.h>
// #include <stdbool.h>
// #include <stdint.h>
// #include <stdlib.h>
//
// #include "nvim/macros_defs.h"
// #include "nvim/types_defs.h"
// #include "nvim/vterm/vterm_defs.h"
// #include "nvim/vterm/vterm_keycodes_defs.h"
//
// #include "vterm/vterm.h.generated.h"
//
// #define VTERM_VERSION_MAJOR 0
// #define VTERM_VERSION_MINOR 3
const std = @import("std");
const ghostty_vt = @import("ghostty-vt");
pub const c = @import("../root.zig").c;
const log = @import("../root.zig").log.scoped(.vterm);
const vterm_handler = @import("../root.zig").handler;
const Handler = vterm_handler.Handler;
const Stream = vterm_handler.Stream;

fn test_preserve_exit(e: [*]const u8) noreturn {
    _ = e;
    std.process.exit(1);
}

const builtin = @import("builtin");
// Don't feel like touching main.c just so I can access preserve_exit in tests.
const preserve_exit = if (builtin.is_test) test_preserve_exit else c.preserve_exit;
const e_outofmem = c.e_outofmem;
pub const NUL = '\x00';

// ================================================================================
// BEGIN KEYBOARD
// ================================================================================
// typedef enum {
//   VTERM_MOD_NONE  = 0x00,
//   VTERM_MOD_SHIFT = 0x01,
//   VTERM_MOD_ALT   = 0x02,
//   VTERM_MOD_CTRL  = 0x04,
//
//   VTERM_ALL_MODS_MASK = 0x07,
// } VTermModifier;
// pub const VTermModifier = c_int;
// pub const VTERM_MOD_NONE: VTermModifier = 0x00;
// pub const VTERM_MOD_SHIFT: VTermModifier = 0x01;
// pub const VTERM_MOD_ALT: VTermModifier = 0x02;
// pub const VTERM_MOD_CTRL: VTermModifier = 0x04;
//
// pub const VTERM_ALL_MODS_MASK: VTermModifier = 0x07;

// typedef enum {
//   VTERM_KEY_NONE,
//
//   VTERM_KEY_ENTER,
//   VTERM_KEY_TAB,
//   VTERM_KEY_BACKSPACE,
//   VTERM_KEY_ESCAPE,
//
//   VTERM_KEY_UP,
//   VTERM_KEY_DOWN,
//   VTERM_KEY_LEFT,
//   VTERM_KEY_RIGHT,
//
//   VTERM_KEY_INS,
//   VTERM_KEY_DEL,
//   VTERM_KEY_HOME,
//   VTERM_KEY_END,
//   VTERM_KEY_PAGEUP,
//   VTERM_KEY_PAGEDOWN,
//
//   VTERM_KEY_FUNCTION_0   = 256,
//   VTERM_KEY_FUNCTION_MAX = VTERM_KEY_FUNCTION_0 + 255,
//
//   VTERM_KEY_KP_0,
//   VTERM_KEY_KP_1,
//   VTERM_KEY_KP_2,
//   VTERM_KEY_KP_3,
//   VTERM_KEY_KP_4,
//   VTERM_KEY_KP_5,
//   VTERM_KEY_KP_6,
//   VTERM_KEY_KP_7,
//   VTERM_KEY_KP_8,
//   VTERM_KEY_KP_9,
//   VTERM_KEY_KP_MULT,
//   VTERM_KEY_KP_PLUS,
//   VTERM_KEY_KP_COMMA,
//   VTERM_KEY_KP_MINUS,
//   VTERM_KEY_KP_PERIOD,
//   VTERM_KEY_KP_DIVIDE,
//   VTERM_KEY_KP_ENTER,
//   VTERM_KEY_KP_EQUAL,
//
//   VTERM_KEY_MAX,  // Must be last
//   VTERM_N_KEYS = VTERM_KEY_MAX,
// } VTermKey;
pub const VTermKey = enum(c_int) {
    none,

    enter,
    tab,
    backspace,
    escape,

    up,
    down,
    left,
    right,

    ins,
    del,
    home,
    end,
    pageup,
    pagedown,

    function_0 = 256,
    function_max = 256 + 255,

    kp_0,
    kp_1,
    kp_2,
    kp_3,
    kp_4,
    kp_5,
    kp_6,
    kp_7,
    kp_8,
    kp_9,
    kp_mult,
    kp_plus,
    kp_comma,
    kp_minus,
    kp_period,
    kp_divide,
    kp_enter,
    kp_equal,

    max, // Must be last
};

const N_KEYS = @intFromEnum(VTermKey.max);

// typedef struct {
//   enum {
//     KEYCODE_NONE,
//     KEYCODE_LITERAL,
//     KEYCODE_TAB,
//     KEYCODE_ENTER,
//     KEYCODE_SS3,
//     KEYCODE_CSI,
//     KEYCODE_CSI_CURSOR,
//     KEYCODE_CSINUM,
//     KEYCODE_KEYPAD,
//   } type;
//   int literal;
//   int csinum;
// } keycodes_s;
pub const KeyCodes = struct {
    type: enum {
        none,
        literal,
        tab,
        enter,
        ss3,
        csi,
        csi_cursor,
        csinum,
        keypad,
    },
    literal: c_int,
    csinum: c_int,
};

// static keycodes_s keycodes[] = {
//   { KEYCODE_NONE, NUL, 0 },  // NONE
//
//   { KEYCODE_ENTER,   '\r',   0 },  // ENTER
//   { KEYCODE_TAB,     '\t',   0 },  // TAB
//   { KEYCODE_LITERAL, '\x7f', 0 },  // BACKSPACE == ASCII DEL
//   { KEYCODE_LITERAL, '\x1b', 0 },  // ESCAPE
//
//   { KEYCODE_CSI_CURSOR, 'A', 0 },  // UP
//   { KEYCODE_CSI_CURSOR, 'B', 0 },  // DOWN
//   { KEYCODE_CSI_CURSOR, 'D', 0 },  // LEFT
//   { KEYCODE_CSI_CURSOR, 'C', 0 },  // RIGHT
//
//   { KEYCODE_CSINUM, '~', 2     },  // INS
//   { KEYCODE_CSINUM, '~', 3     },  // DEL
//   { KEYCODE_CSI_CURSOR, 'H', 0 },  // HOME
//   { KEYCODE_CSI_CURSOR, 'F', 0 },  // END
//   { KEYCODE_CSINUM, '~', 5     },  // PAGEUP
//   { KEYCODE_CSINUM, '~', 6     },  // PAGEDOWN
// };
const keycodes: []const KeyCodes = &.{
    .{ .type = .none, .literal = NUL, .csinum = 0 }, // NONE
    .{ .type = .enter, .literal = '\r', .csinum = 0 }, // ENTER
    .{ .type = .tab, .literal = '\t', .csinum = 0 }, // TAB
    .{ .type = .literal, .literal = '\x7f', .csinum = 0 }, // BACKSPACE == ASCII DEL
    .{ .type = .literal, .literal = '\x1b', .csinum = 0 }, // ESCAPE
    .{ .type = .csi_cursor, .literal = 'A', .csinum = 0 }, // UP
    .{ .type = .csi_cursor, .literal = 'B', .csinum = 0 }, // DOWN
    .{ .type = .csi_cursor, .literal = 'D', .csinum = 0 }, // LEFT
    .{ .type = .csi_cursor, .literal = 'C', .csinum = 0 }, // RIGHT
    .{ .type = .csinum, .literal = '~', .csinum = 2 }, // INS
    .{ .type = .csinum, .literal = '~', .csinum = 3 }, // DEL
    .{ .type = .csi_cursor, .literal = 'H', .csinum = 0 }, // HOME
    .{ .type = .csi_cursor, .literal = 'F', .csinum = 0 }, // END
    .{ .type = .csinum, .literal = '~', .csinum = 5 }, // PAGEUP
    .{ .type = .csinum, .literal = '~', .csinum = 6 }, // PAGEDOWN
};

// static keycodes_s keycodes_fn[] = {
//   { KEYCODE_NONE,   NUL,  0 },    // F0 - shouldn't happen
//   { KEYCODE_SS3,    'P',  0 },    // F1
//   { KEYCODE_SS3,    'Q',  0 },    // F2
//   { KEYCODE_SS3,    'R',  0 },    // F3
//   { KEYCODE_SS3,    'S',  0 },    // F4
//   { KEYCODE_CSINUM, '~',  15 },   // F5
//   { KEYCODE_CSINUM, '~',  17 },   // F6
//   { KEYCODE_CSINUM, '~',  18 },   // F7
//   { KEYCODE_CSINUM, '~',  19 },   // F8
//   { KEYCODE_CSINUM, '~',  20 },   // F9
//   { KEYCODE_CSINUM, '~',  21 },   // F10
//   { KEYCODE_CSINUM, '~',  23 },   // F11
//   { KEYCODE_CSINUM, '~',  24 },   // F12
// };
const keycodes_fn: []const KeyCodes = &.{
    .{ .type = .none, .literal = NUL, .csinum = 0 }, // F0 - shouldn't happen
    .{ .type = .ss3, .literal = 'P', .csinum = 0 }, // F1
    .{ .type = .ss3, .literal = 'Q', .csinum = 0 }, // F2
    .{ .type = .ss3, .literal = 'R', .csinum = 0 }, // F3
    .{ .type = .ss3, .literal = 'S', .csinum = 0 }, // F4
    .{ .type = .csinum, .literal = '~', .csinum = 15 }, // F5
    .{ .type = .csinum, .literal = '~', .csinum = 17 }, // F6
    .{ .type = .csinum, .literal = '~', .csinum = 18 }, // F7
    .{ .type = .csinum, .literal = '~', .csinum = 19 }, // F8
    .{ .type = .csinum, .literal = '~', .csinum = 20 }, // F9
    .{ .type = .csinum, .literal = '~', .csinum = 21 }, // F10
    .{ .type = .csinum, .literal = '~', .csinum = 23 }, // F11
    .{ .type = .csinum, .literal = '~', .csinum = 24 }, // F12
};

// static keycodes_s keycodes_kp[] = {
//   { KEYCODE_KEYPAD, '0',  'p' },  // KP_0
//   { KEYCODE_KEYPAD, '1',  'q' },  // KP_1
//   { KEYCODE_KEYPAD, '2',  'r' },  // KP_2
//   { KEYCODE_KEYPAD, '3',  's' },  // KP_3
//   { KEYCODE_KEYPAD, '4',  't' },  // KP_4
//   { KEYCODE_KEYPAD, '5',  'u' },  // KP_5
//   { KEYCODE_KEYPAD, '6',  'v' },  // KP_6
//   { KEYCODE_KEYPAD, '7',  'w' },  // KP_7
//   { KEYCODE_KEYPAD, '8',  'x' },  // KP_8
//   { KEYCODE_KEYPAD, '9',  'y' },  // KP_9
//   { KEYCODE_KEYPAD, '*',  'j' },  // KP_MULT
//   { KEYCODE_KEYPAD, '+',  'k' },  // KP_PLUS
//   { KEYCODE_KEYPAD, ',',  'l' },  // KP_COMMA
//   { KEYCODE_KEYPAD, '-',  'm' },  // KP_MINUS
//   { KEYCODE_KEYPAD, '.',  'n' },  // KP_PERIOD
//   { KEYCODE_KEYPAD, '/',  'o' },  // KP_DIVIDE
//   { KEYCODE_KEYPAD, '\n', 'M' },  // KP_ENTER
//   { KEYCODE_KEYPAD, '=',  'X' },  // KP_EQUAL
// };
const keycodes_kp: []const KeyCodes = &.{
    .{ .type = .keypad, .literal = '0', .csinum = 'p' }, // KP_0
    .{ .type = .keypad, .literal = '1', .csinum = 'q' }, // KP_1
    .{ .type = .keypad, .literal = '2', .csinum = 'r' }, // KP_2
    .{ .type = .keypad, .literal = '3', .csinum = 's' }, // KP_3
    .{ .type = .keypad, .literal = '4', .csinum = 't' }, // KP_4
    .{ .type = .keypad, .literal = '5', .csinum = 'u' }, // KP_5
    .{ .type = .keypad, .literal = '6', .csinum = 'v' }, // KP_6
    .{ .type = .keypad, .literal = '7', .csinum = 'w' }, // KP_7
    .{ .type = .keypad, .literal = '8', .csinum = 'x' }, // KP_8
    .{ .type = .keypad, .literal = '9', .csinum = 'y' }, // KP_9
    .{ .type = .keypad, .literal = '*', .csinum = 'j' }, // KP_MULT
    .{ .type = .keypad, .literal = '+', .csinum = 'k' }, // KP_PLUS
    .{ .type = .keypad, .literal = ',', .csinum = 'l' }, // KP_COMMA
    .{ .type = .keypad, .literal = '-', .csinum = 'm' }, // KP_MINUS
    .{ .type = .keypad, .literal = '.', .csinum = 'n' }, // KP_PERIOD
    .{ .type = .keypad, .literal = '/', .csinum = 'o' }, // KP_DIVIDE
    .{ .type = .keypad, .literal = '\n', .csinum = 'M' }, // KP_ENTER
    .{ .type = .keypad, .literal = '=', .csinum = 'X' }, // KP_EQUAL
};

// static keycodes_s keycodes_kp_csiu[] = {
//   { KEYCODE_KEYPAD, 57399, 'p' },  // KP_0
//   { KEYCODE_KEYPAD, 57400, 'q' },  // KP_1
//   { KEYCODE_KEYPAD, 57401, 'r' },  // KP_2
//   { KEYCODE_KEYPAD, 57402, 's' },  // KP_3
//   { KEYCODE_KEYPAD, 57403, 't' },  // KP_4
//   { KEYCODE_KEYPAD, 57404, 'u' },  // KP_5
//   { KEYCODE_KEYPAD, 57405, 'v' },  // KP_6
//   { KEYCODE_KEYPAD, 57406, 'w' },  // KP_7
//   { KEYCODE_KEYPAD, 57407, 'x' },  // KP_8
//   { KEYCODE_KEYPAD, 57408, 'y' },  // KP_9
//   { KEYCODE_KEYPAD, 57411, 'j' },  // KP_MULT
//   { KEYCODE_KEYPAD, 57413, 'k' },  // KP_PLUS
//   { KEYCODE_KEYPAD, 57416, 'l' },  // KP_COMMA
//   { KEYCODE_KEYPAD, 57412, 'm' },  // KP_MINUS
//   { KEYCODE_KEYPAD, 57409, 'n' },  // KP_PERIOD
//   { KEYCODE_KEYPAD, 57410, 'o' },  // KP_DIVIDE
//   { KEYCODE_KEYPAD, 57414, 'M' },  // KP_ENTER
//   { KEYCODE_KEYPAD, 57415, 'X' },  // KP_EQUAL
// };
const keycodes_kp_csiu: []const KeyCodes = &.{
    .{ .type = .keypad, .literal = 57399, .csinum = 'p' }, // KP_0
    .{ .type = .keypad, .literal = 57400, .csinum = 'q' }, // KP_1
    .{ .type = .keypad, .literal = 57401, .csinum = 'r' }, // KP_2
    .{ .type = .keypad, .literal = 57402, .csinum = 's' }, // KP_3
    .{ .type = .keypad, .literal = 57403, .csinum = 't' }, // KP_4
    .{ .type = .keypad, .literal = 57404, .csinum = 'u' }, // KP_5
    .{ .type = .keypad, .literal = 57405, .csinum = 'v' }, // KP_6
    .{ .type = .keypad, .literal = 57406, .csinum = 'w' }, // KP_7
    .{ .type = .keypad, .literal = 57407, .csinum = 'x' }, // KP_8
    .{ .type = .keypad, .literal = 57408, .csinum = 'y' }, // KP_9
    .{ .type = .keypad, .literal = 57411, .csinum = 'j' }, // KP_MULT
    .{ .type = .keypad, .literal = 57413, .csinum = 'k' }, // KP_PLUS
    .{ .type = .keypad, .literal = 57416, .csinum = 'l' }, // KP_COMMA
    .{ .type = .keypad, .literal = 57412, .csinum = 'm' }, // KP_MINUS
    .{ .type = .keypad, .literal = 57409, .csinum = 'n' }, // KP_PERIOD
    .{ .type = .keypad, .literal = 57410, .csinum = 'o' }, // KP_DIVIDE
    .{ .type = .keypad, .literal = 57414, .csinum = 'M' }, // KP_ENTER
    .{ .type = .keypad, .literal = 57415, .csinum = 'X' }, // KP_EQUAL
};

// ================================================================================
// END KEYBOARD
// ================================================================================

// TODO: find reasonable default size
pub const VTERM_BUF_DEFAULT_SIZE = 64;
const Terminal = ghostty_vt.Terminal;

pub const VTermMsgWriter = struct {
    outfunc: *const c.VTermZOutputCallback,
    outdata: *anyopaque,

    pub fn output(self: *const VTermMsgWriter, data: []const u8) void {
        self.outfunc(data.ptr, data.len, self.outdata);
    }
};

pub const VTerm = struct {
    t: *ghostty_vt.Terminal,
    rs: ghostty_vt.RenderState,
    s: Stream,
    term_writer: ?VTermMsgWriter = null,
    allocator: std.mem.Allocator,
    // TODO: I don't think we even need 64 bytes for this. libvterm had 4096 bytes for
    // outbuffer, but I don't think it was fully used because it was all
    // handled by outfunc. Maybe I'm missing something, though.
    keyout_buffer: [VTERM_BUF_DEFAULT_SIZE]u8 = undefined,
    keyout_buffer_w: std.Io.Writer,
    mouse: struct {
        event_point: ?ghostty_vt.Coordinate = null,
        buttons: u32 = 0,
    } = .{},

    pub fn term_output(self: *VTerm, data: []const u8) void {
        if (self.term_writer) |w| w.output(data);
    }
};
// pub export const VTermZ = VTerm;
// typedef enum {
//   VTERMZ_TERMINATOR_BEL,  // \x07
//   VTERMZ_TERMINATOR_ST,  // \x1b\x5c
// } VTermZTerminator;
pub const VTermZTerminator = enum(c_int) {
    VTERMZ_TERMINATOR_BEL,
    VTERMZ_TERMINATOR_ST,
};

pub var gpa = std.heap.GeneralPurposeAllocator(.{}).init;
const gpa_alloc = if (builtin.is_test)
    std.testing.allocator
else
    gpa.allocator();

// DONE
pub export fn vtermz_new(rows: u16, cols: u16) callconv(.c) *VTerm {
    const alloc = gpa_alloc;

    const t = alloc.create(ghostty_vt.Terminal) catch preserve_exit(e_outofmem);
    var t_modes = ghostty_vt.modes.ModeState{};
    t_modes.set(.grapheme_cluster, true);
    t.* = ghostty_vt.Terminal.init(alloc, .{
        .rows = @intCast(rows),
        .cols = @intCast(cols),
        .default_modes = t_modes.values,
        // Let nvim handle the scrollback if it gets out of hand
        .max_scrollback = std.math.maxInt(usize),
    }) catch preserve_exit(e_outofmem);

    const rs: ghostty_vt.RenderState = .empty;

    const handler = vterm_handler.Handler.init(t, alloc);
    const stream = vterm_handler.Stream.initAlloc(alloc, handler);

    var vt = alloc.create(VTerm) catch preserve_exit(e_outofmem);
    vt.* = .{
        .t = t,
        .rs = rs,
        .s = stream,
        .keyout_buffer_w = std.Io.Writer.fixed(&vt.keyout_buffer),
        .allocator = alloc,
    };
    return vt;
}

// DONE
pub export fn vtermz_free(vt: *VTerm) callconv(.c) void {
    // TODO: find out what's leaking
    vt.t.deinit(vt.allocator);
    vt.rs.deinit(vt.allocator);
    vt.s.deinit();
    vt.allocator.destroy(vt.t);
    vt.allocator.destroy(vt);
}

pub export fn vtermz_refresh(vt: *VTerm) callconv(.c) void {
    vt.rs.update(vt.allocator, vt.t) catch preserve_exit(e_outofmem);
}

pub export fn vtermz_flush_damage(vt: *VTerm) callconv(.c) void {
    vt.s.handler.flushDamage();
}

pub export fn vtermz_teardown() callconv(.c) void {
    _ = gpa.deinit();
}

fn bytes_hex_leak(vt: *VTerm, bytes: []const u8) []u8 {
    var buf = vt.allocator.alloc(u8, bytes.len * 3) catch @panic("oom");
    var idx: usize = 0;
    for (bytes) |b| {
        const digits = std.fmt.hex(b);
        buf[idx] = digits[0];
        buf[idx + 1] = digits[1];
        buf[idx + 2] = ' ';
        idx += 3;
    }

    return buf[0 .. @max(1, idx) - 1];
}

pub export fn vtermz_input_write(vt: *VTerm, bytes: [*]const u8, len: usize) callconv(.c) usize {
    // TODO: handle errors
    // if (std.mem.containsAtLeastScalar(u8, bytes[0..len], 1, 0x00)) {
    //     log.warn(@src(), "input contains null byte!", .{});
    // } else {
    //     log.warn(@src(), "input: {s}", .{bytes[0..len]});
    // }
    vt.s.nextSlice(bytes[0..len]) catch {};
    return 0;
}

pub export fn vtermz_output_set_callback(
    vt: *VTerm,
    func: *const c.VTermZOutputCallback,
    user: *anyopaque,
) callconv(.c) void {
    const term_writer: VTermMsgWriter = .{
        .outfunc = func,
        .outdata = user,
    };
    vt.term_writer = term_writer;
    vt.s.handler.term_writer = term_writer;
}

pub export fn vtermz_screen_set_callbacks(vt: *VTerm, callbacks: *const c.VTermZCallbacks, user: *anyopaque) callconv(.c) void {
    vt.s.handler.callbacks = callbacks.*;
    vt.s.handler.cbdata = user;
}

// TODO: make this a static lookup or rework terminal.c so it can make use of
// ghostty keys directly
inline fn vterm_key_to_ghostty_key(vkey: VTermKey) ?ghostty_vt.input.Key {
    const val = @intFromEnum(vkey);
    if (val >= @intFromEnum(VTermKey.function_0) and val <= @intFromEnum(VTermKey.function_max)) {
        const new_val = val - @intFromEnum(VTermKey.function_0);
        const ghostty_f1 = @intFromEnum(ghostty_vt.input.Key.f1);
        const ghostty_fmax = @intFromEnum(ghostty_vt.input.Key.f25);
        if (new_val == 0 or new_val > (ghostty_fmax - ghostty_f1)) return null;
        return @enumFromInt(ghostty_f1 + (new_val - 1));
    }
    return switch (vkey) {
        .none => null,
        .enter => .enter,
        .tab => .tab,
        .backspace => .backspace,
        .escape => .escape,
        .up => .arrow_up,
        .down => .arrow_down,
        .left => .arrow_left,
        .right => .arrow_right,
        .ins => .insert,
        .del => .delete,
        .home => .home,
        .end => .end,
        .pageup => ghostty_vt.input.Key.page_up,
        .pagedown => .page_down,
        .function_0 => @panic("this should never happen"),
        .function_max => @panic("this should never happen"),
        .kp_0 => .numpad_0,
        .kp_1 => .numpad_1,
        .kp_2 => .numpad_2,
        .kp_3 => .numpad_3,
        .kp_4 => .numpad_4,
        .kp_5 => .numpad_5,
        .kp_6 => .numpad_6,
        .kp_7 => .numpad_7,
        .kp_8 => .numpad_8,
        .kp_9 => .numpad_9,
        .kp_mult => .numpad_multiply,
        .kp_plus => .numpad_add,
        .kp_comma => .numpad_comma,
        .kp_minus => .numpad_subtract,
        .kp_period => .numpad_decimal,
        .kp_divide => .numpad_divide,
        .kp_enter => .numpad_enter,
        .kp_equal => .numpad_equal,
        .max => null, // Must be last
    };
}

inline fn vterm_mod_to_ghostty_mod(vmod: c.VTermModifier) ghostty_vt.input.KeyMods {
    return .{
        .alt = vmod & c.VTERM_MOD_ALT > 0,
        .ctrl = vmod & c.VTERM_MOD_CTRL > 0,
        .shift = vmod & c.VTERM_MOD_SHIFT > 0,
    };
}

pub export fn vtermz_keyboard_key(vt: *VTerm, vkey: VTermKey, vmod: c.VTermModifier) callconv(.c) void {
    const key = vterm_key_to_ghostty_key(vkey) orelse return;
    const mods = vterm_mod_to_ghostty_mod(vmod);
    const evt: ghostty_vt.input.KeyEvent = .{
        .key = key,
        .mods = mods,
        .action = .press,
    };
    // TODO: handle error
    ghostty_vt.input.encodeKey(&vt.keyout_buffer_w, evt, .{}) catch return;
    vt.term_output(vt.keyout_buffer_w.buffered());
    _ = vt.keyout_buffer_w.consumeAll();
}

pub export fn vtermz_keyboard_unichar(vt: *VTerm, ch: u32, vmod: c.VTermModifier) callconv(.c) void {
    //   bool passthru = false;
    //   if (c == ' ') {
    //     // Space is passed through only when there are no modifiers (including shift)
    //     passthru = mod == VTERM_MOD_NONE;
    //   } else {
    //     // Otherwise pass through when there are no modifiers (ignoring shift)
    //     passthru = (mod & (unsigned)~VTERM_MOD_SHIFT) == 0;
    //   }
    var passthru = false;
    if (ch == ' ') {
        passthru = vmod == c.VTERM_MOD_NONE;
    } else {
        passthru = (@as(c_int, @intCast(vmod)) & (~c.VTERM_MOD_SHIFT)) == 0;
    }

    //   if (passthru) {
    //     char str[6];
    //     int seqlen = fill_utf8((int)c, str);
    //     vterm_push_output_bytes(vt, str, (size_t)seqlen);
    //     return;
    //   }
    //
    if (passthru) {
        if (ch > std.math.maxInt(u21)) return;
        const len = std.unicode.utf8Encode(@intCast(ch), vt.keyout_buffer[0..4]) catch 0;
        vt.term_output(vt.keyout_buffer[0..len]);
        return;
    }

    //   VTermKeyEncodingFlags flags = vterm_state_get_key_encoding_flags(vt->state);
    //   if (flags.disambiguate) {
    //     // Always use unshifted codepoint
    //     if (c >= 'A' && c <= 'Z') {
    //       c += 'a' - 'A';
    //       mod |= VTERM_MOD_SHIFT;
    //     }
    //
    //     vterm_push_output_sprintf_ctrl(vt, C1_CSI, "%d;%du", c, mod + 1);
    //     return;
    //   }
    //   if (mod & VTERM_MOD_CTRL) {
    //     // Handle special cases. These are taken from kitty, but seem mostly
    //     // consistent across terminals.
    //     switch (c) {
    //     case '2':
    //     case ' ':
    //       // Ctrl+2 is NUL to match Ctrl+@ (which is Shift+2 on US keyboards)
    //       // Ctrl+Space is also NUL for some reason
    //       c = 0x00;
    //       break;
    //     case '3':
    //     case '4':
    //     case '5':
    //     case '6':
    //     case '7':
    //       // Ctrl+3 through Ctrl+7 are sequential starting from 0x1b. Importantly,
    //       // this means that Ctrl+6 emits 0x1e (the same as Ctrl+^ on US keyboards)
    //       c = 0x1b + c - '3';
    //       break;
    //     case '8':
    //       // Ctrl+8 is DEL
    //       c = 0x7f;
    //       break;
    //     case '/':
    //       // Ctrl+/ is equivalent to Ctrl+_ for historic reasons
    //       c = 0x1f;
    //       break;
    //     default:
    //       if (c >= '@' && c <= 0x7f) {
    //         c &= 0x1f;
    //       }
    //       break;
    //     }
    //   }
    //
    //   vterm_push_output_sprintf(vt, "%s%c", mod & VTERM_MOD_ALT ? ESC_S : "", c);
    //
    // TODO: make sure all this is handled correctly :)
    if (ch > std.math.maxInt(u8)) {
        @panic("I wrongly assumed everything from here on out would be ASCII");
    }
    const key = ghostty_vt.input.Key.fromASCII(@intCast(ch)) orelse return;
    const evt: ghostty_vt.input.KeyEvent = .{
        .key = key,
        .mods = vterm_mod_to_ghostty_mod(vmod),
        .action = .press,
    };
    ghostty_vt.input.encodeKey(&vt.keyout_buffer_w, evt, .{}) catch return;
    vt.term_output(vt.keyout_buffer_w.buffered());
    _ = vt.keyout_buffer_w.consumeAll();
}

// This function was adapted from Ghostty's src/Surface.zig
pub export fn vtermz_mouse_action(
    vt: *VTerm,
    button: u8,
    row: usize,
    col: u16,
    pressed: bool,
    mod: c.VTermModifier,
) void {
    // log.warn(
    //     @src(),
    //     "calling mouse action. button={}, row={}, col={}, pressed={}, released={}, mod={}",
    //     .{ button, row, col, pressed, released, mod },
    // );
    const mods = vterm_mod_to_ghostty_mod(mod);

    // invalid input
    const action: enum { press, motion } =
        if (pressed) .press else .motion;

    // Logic looted from libvterm to prevent repeat actions for the same button press.
    // ===============================================================================
    const old_buttons = vt.mouse.buttons;

    if ((button > 0 and button <= 3) or (button >= 8 and button <= 11)) {
        if (pressed) {
            vt.mouse.buttons |= (@as(u32, 1) << @as(u5, @intCast(button - 1)));
        } else {
            vt.mouse.buttons &= ~(@as(u32, 1) << @as(u5, @intCast(button - 1)));
        }
    }

    if (action == .press and vt.mouse.buttons == old_buttons and (button < 4 or button > 7)) {
        return;
    }
    // ===============================================================================

    // Mouse reporting must be enabled by both config and terminal state

    // Depending on the event, we may do nothing at all.
    switch (vt.t.flags.mouse_event) {
        .none => return,

        // X10 only reports clicks with mouse button 1, 2, 3. We verify
        // the button later.
        .x10 => if (action != .press or
            !(button == 1 or
                button == 2 or
                button == 3)) return,

        // Doesn't report motion
        .normal => if (action == .motion) return,

        // Button must be pressed
        .button => if (button == 0) return,

        // Everything
        .any => {},
    }

    // Handle scenarios where the mouse position is outside the viewport.
    const pos_outside_viewport = row < 0 or col < 0 or row >= vt.t.rows or col >= vt.t.cols;
    if (pos_outside_viewport) return;

    const viewport_point: ghostty_vt.Coordinate = .{ .x = col, .y = @intCast(row) };

    // Record our new point. We only want to send a mouse event if the
    // cell changed, unless we're tracking raw pixels.
    if (action == .motion and vt.t.flags.mouse_format != .sgr_pixels) {
        if (vt.mouse.event_point) |last_point| {
            if (last_point.eql(viewport_point)) return;
        }
    }
    vt.mouse.event_point = viewport_point;

    // Get the code we'll actually write
    const button_code: u8 = code: {
        var acc: u8 = 0;

        // Determine our initial button value
        if (button == 0) {
            // Null button means motion without a button pressed
            acc = 3;
        } else {
            acc = switch (button) {
                // left
                1 => 0,
                // middle
                2 => 1,
                // right
                3 => 2,
                4 => 64,
                5 => 65,
                6 => 66,
                7 => 67,
                8 => 128,
                9 => 129,
                else => return, // unsupported
            };
        }

        // X10 doesn't have modifiers
        if (vt.t.flags.mouse_event != .x10) {
            if (mods.shift) acc += 4;
            if (mods.alt) acc += 8;
            if (mods.ctrl) acc += 16;
        }

        // Motion adds another bit
        if (action == .motion) acc += 32;

        break :code acc;
    };

    switch (vt.t.flags.mouse_format) {
        .x10 => {
            if (viewport_point.x > 222 or viewport_point.y > 222) {
                log.info(@src(), "X10 mouse format can only encode X/Y up to 223", .{});
                return;
            }

            // + 1 below is because our x/y is 0-indexed and the protocol wants 1
            var data: [6]u8 = undefined;
            data[0] = '\x1b';
            data[1] = '[';
            data[2] = 'M';
            data[3] = 32 + button_code;
            data[4] = 32 + @as(u8, @intCast(viewport_point.x)) + 1;
            data[5] = 32 + @as(u8, @intCast(viewport_point.y)) + 1;

            vt.term_output(&data);
        },

        .utf8 => {
            // Maximum of 12 because at most we have 2 fully UTF-8 encoded chars
            var data: [12]u8 = undefined;
            data[0] = '\x1b';
            data[1] = '[';
            data[2] = 'M';

            // The button code will always fit in a single u8
            data[3] = 32 + button_code;

            // UTF-8 encode the x/y
            var i: usize = 4;
            // TODO: log errors?
            i += std.unicode.utf8Encode(@intCast(32 + viewport_point.x + 1), data[i..]) catch return;
            i += std.unicode.utf8Encode(@intCast(32 + viewport_point.y + 1), data[i..]) catch return;

            vt.term_output(data[0..i]);
        },

        .sgr => {
            // Final character to send in the CSI.
            const final: u8 = if (action == .press) 'M' else 'm';

            // Response always is at least 4 chars, so this leaves the
            // remainder for numbers which are very large...
            var data: [64]u8 = undefined;
            // TODO: log errors?
            const resp = std.fmt.bufPrint(&data, "\x1B[<{d};{d};{d}{c}", .{
                button_code,
                viewport_point.x + 1,
                viewport_point.y + 1,
                final,
            }) catch return;

            vt.term_output(resp);
        },

        .urxvt => {
            // Response always is at least 4 chars, so this leaves the
            // remainder for numbers which are very large...
            var data: [64]u8 = undefined;
            // TODO: log errors?
            const resp = std.fmt.bufPrint(&data, "\x1B[{d};{d};{d}M", .{
                32 + button_code,
                viewport_point.x + 1,
                viewport_point.y + 1,
            }) catch return;

            vt.term_output(resp);
        },

        .sgr_pixels => {
            // unimplemented
            return;
        },
    }
}

inline fn ghostty_color_to_termcolor(color: ghostty_vt.Style.Color) c.VTermZColor {
    return switch (color) {
        .palette => |idx| .{
            .palette = .{
                .type = c.VTERMZ_COLOR_PALETTE,
                .idx = idx,
            },
        },
        .rgb => |col| .{
            .rgb = .{
                .type = c.VTERMZ_COLOR_RGB,
                .r = col.r,
                .g = col.g,
                .b = col.b,
            },
        },
        .none => .{
            .type = c.VTERMZ_COLOR_NONE,
        },
    };
}

/// If the color is a palette color, it looks up the color in the palette and
/// returns it as an RGB int. If it's an RGB color, it simply calculates the
/// RGB int. If it's a default (VTERMZ_COLOR_NONE) color, returns -1.
pub export fn vtermz_color_rgb_int(vt: *const VTerm, color: c.VTermZColor) c_int {
    switch (color.type) {
        c.VTERMZ_COLOR_RGB => return (@as(c_int, @intCast(color.rgb.r)) << 16) |
            (@as(c_int, @intCast(color.rgb.g)) << 8) |
            @as(c_int, @intCast(color.rgb.b)),
        c.VTERMZ_COLOR_PALETTE => {
            const palette_color = vt.rs.colors.palette[color.palette.idx];
            return (@as(c_int, @intCast(palette_color.r)) << 16) |
                (@as(c_int, @intCast(palette_color.g)) << 8) |
                @as(c_int, @intCast(palette_color.b));
        },
        else => return -1,
    }
}

/// Fills buf with utf8 encoded bytes from the terminal on row `row`
/// from `start_col` to `end_col`.
/// Returns number of bytes written.
pub export fn vtermz_fill_buf_row_utf8(
    vt: *VTerm,
    row: usize,
    start_col: usize,
    /// End col exclusive
    end_col: usize,
    buf: [*]u8,
    buf_max_len: usize,
) callconv(.c) usize {
    var idx: usize = 0;

    if (row >= vt.rs.row_data.len or start_col > end_col or end_col == 0) return idx;

    const cell_row: std.MultiArrayList(ghostty_vt.RenderState.Cell) =
        vt.rs.row_data.items(.cells)[@intCast(row)];
    const end_col_clamped = @min(end_col, cell_row.len);

    const cells_raw: []ghostty_vt.Cell = cell_row.items(.raw);
    const cells_grapheme: [][]const u21 = cell_row.items(.grapheme);
    // TODO: make faster using vt.rs.row_data.get(0).raw.grapheme to determine
    // if any cells have multi-codepoint grapheme clusters.

    var col_idx: usize = @intCast(start_col);
    // There can be null codepoints leading up to the text, and there can be null
    // codepoints after/in between text. We record the max_char_idx (the last index
    // of a real character) so that we know how far the buf should truly extend.
    var max_char_idx: usize = 0;
    while (col_idx < end_col_clamped) {
        const cell_raw = cells_raw[col_idx];
        const grapheme = cells_grapheme[col_idx];
        switch (cell_raw.content_tag) {
            .codepoint => {
                if (cell_raw.content.codepoint == 0) {
                    buf[idx] = ' ';
                    idx += 1;
                    col_idx += 1;
                    continue;
                }

                idx += std.unicode.utf8Encode(cell_raw.content.codepoint, buf[idx..buf_max_len]) catch return idx;
                max_char_idx = idx;
                // log.warn(
                //     @src(),
                //     "row={d}, col_idx={d}: put single grapheme: {s} ({any}) (w={})",
                //     .{ row, col_idx, buf[start_idx..idx], buf[start_idx..idx], cell_raw.gridWidth() },
                // );
            },
            .codepoint_grapheme => {
                // TODO: handle links.
                // TODO: keycap emojis seem to not work in a nested nvim
                idx += std.unicode.utf8Encode(cell_raw.content.codepoint, buf[idx..buf_max_len]) catch return idx;
                for (grapheme) |g| {
                    idx += std.unicode.utf8Encode(g, buf[idx..buf_max_len]) catch return idx;
                }
                max_char_idx = idx;
                // log.warn(
                //     @src(),
                //     "row={d}, col_idx={d}: put multi grapheme:  {s} ({any})",
                //     .{ row, col_idx, buf[start_idx..idx], buf[start_idx..idx] },
                // );
            },
            // I believe these only come after any text in the row, but I'm not entirely sure.
            .bg_color_palette, .bg_color_rgb => {
                // if (row == 7 or row == 8 or row == 37) {
                //     log.warn(@src(), "row={}, col_idx={}: adding blank space", .{ row, col_idx });
                // }
                buf[idx] = ' ';
                idx += 1;
            },
        }

        // We advance by the grid width each time, not by 1. Some characters span
        // a width of 2 cols, but the grapheme data is stored entirely in the first
        // col that the character occupies.
        const width = cell_raw.gridWidth();
        // if (width > 1) {
        //     log.warn(@src(), "row={}, col_idx={}: extra width: {d}", .{ row, col_idx, width });
        // }
        col_idx += width;
    }

    return max_char_idx;
}

pub export fn vtermz_fill_buf_lnum_utf8(
    vt: *VTerm,
    /// Zero-indexed line number
    lnum: usize,
    start_col: usize,
    /// End col exclusive
    end_col: usize,
    buf: [*]u8,
    buf_max_len: usize,
) callconv(.c) usize {
    if (lnum >= vt.t.screens.active.pages.total_rows or start_col > end_col or end_col == 0) {
        // log.warn(@src(), "lnum {} out of range. total rows: {}, start_col: {}, end_col: {}", .{lnum, vt.t.screens.active.pages.total_rows, start_col, end_col});
        return 0;
    }
    // log.warn(@src(), "getting lnum style for lnum={}", .{lnum});
    // TODO: I'm not sure how to avoid this if the caller needs to request arbitrary
    // line numbers. Getting the scrollbar every time is potentially expensive.
    const sb = vt.t.screens.active.pages.scrollbar();
    const to_scroll = @as(isize, @intCast(lnum)) - @as(isize, @intCast(sb.offset));
    // log.warn(@src(), "sb: {any}, to_scroll={}", .{ sb, to_scroll });
    return if (to_scroll >= 0 and to_scroll < sb.len) blk: {
        // row is already in viewport
        // log.warn(@src(), "lnum exists at row {}, no scroll necessary", .{to_scroll});
        break :blk vtermz_fill_buf_row_utf8(vt, @intCast(to_scroll), start_col, end_col, buf, buf_max_len);
    } else blk: {
        // TODO: I'm not sure how to avoid this if the caller needs to request arbitrary
        // line numbers. This is terrible.
        // log.warn(@src(), "scrolling {}", .{to_scroll});
        vt.t.scrollViewport(.{ .delta = to_scroll }) catch {};
        vtermz_refresh(vt);
        const res = vtermz_fill_buf_row_utf8(vt, 0, start_col, end_col, buf, buf_max_len);
        // vt.t.scrollViewport(.{ .delta = -to_scroll }) catch {};
        // vtermz_refresh(vt);
        break :blk res;
    };
}

/// Fills buf with cell styles from the terminal on row `row` from `start_col` to `end_col`.
/// Returns number of columns filled out, which could be less than `end_col` depending on
/// how many columns are truly in the row (as well as `buf_max_len`).
pub export fn vtermz_fill_buf_row_style(
    vt: *VTerm,
    row: usize,
    start_col: usize,
    /// End col exclusive
    end_col: usize,
    buf: [*]c.VTermZStyle,
    buf_max_len: usize,
) callconv(.c) usize {
    if (row >= vt.rs.row_data.len or start_col > end_col or end_col == 0) return 0;

    const row_data = vt.rs.row_data.get(row);
    const cell_row = row_data.cells;
    const end_col_clamped = @min(end_col, cell_row.len, buf_max_len);

    const cells_raw: []ghostty_vt.Cell = cell_row.items(.raw);
    const cells_style: []ghostty_vt.Style = cell_row.items(.style);

    // if (row == 7) {
    //     log.warn(@src(), "getting style for row=7 in range {} - {}", .{ start_col, end_col_clamped });
    // }
    for (start_col..end_col_clamped) |col_idx| {
        const cell_raw = cells_raw[col_idx];
        const style: ghostty_vt.Style = if (cell_raw.style_id == 0) .{} else cells_style[col_idx];
        // if (cell_raw.style_id == 0 and row == 7) {
        //     log.warn(@src(), "col={}, using style_id=0", .{col_idx});
        // } else {
        //     log.warn(@src(), "col={}, using style bg_color={any}", .{ col_idx, style.bg_color });
        // }
        buf[col_idx].fg = ghostty_color_to_termcolor(style.fg_color);
        buf[col_idx].bg = ghostty_color_to_termcolor(style.bg_color);
        buf[col_idx].underline_color = ghostty_color_to_termcolor(style.underline_color);
        buf[col_idx].flags.blink = style.flags.blink;
        buf[col_idx].flags.bold = style.flags.bold;
        buf[col_idx].flags.faint = style.flags.faint;
        buf[col_idx].flags.inverse = style.flags.inverse;
        buf[col_idx].flags.invisible = style.flags.invisible;
        buf[col_idx].flags.italic = style.flags.italic;
        buf[col_idx].flags.overline = style.flags.overline;
        buf[col_idx].flags.strikethrough = style.flags.strikethrough;
        buf[col_idx].flags.underline_style = @intCast(style.flags.underline.cval());
        buf[col_idx].uri_len = 0;
        // if (row == 7) {
        //     log.warn(@src(), "computed style bg for ({}, {})={any}", .{ row, col_idx, buf[col_idx].bg });
        // }
    }

    // TODO: Speed up hyperlinks. Not sure if the problem is here or elsewhere. Try a for loop
    // with 100 `ls --hyperlink` to see.
    // Most of the time the row won't have any hyperlinks
    if (row_data.raw.hyperlink) {
        const link_page = row_data.pin.node.data;
        // const page_row = link_page.getRow(row_data.pin.y);
        // const cells = link_page.getCells(page_row);
        for (start_col..end_col_clamped) |col_idx| {
            if (!cells_raw[col_idx].hyperlink) continue;
            // I'm not sure if this pin y can be different from `row`
            // log.warn(@src(), "getting row and cell: ({}, {})", .{ row, col_idx });
            const rac = link_page.getRowAndCell(col_idx, row_data.pin.y);
            // log.warn(@src(), "cell should have hyperlink: ({}, {})", .{ row, col_idx });
            const link_id = link_page.lookupHyperlink(rac.cell) orelse continue;
            // According to the docs, ID 0 is reserved and will never be assigned.
            std.debug.assert(link_id != 0);
            // log.warn(@src(), "getting from hyperlink set: ({}, {}), link_id={}", .{ row, col_idx, link_id });
            const link = link_page.hyperlink_set.get(link_page.memory, link_id);
            // log.warn(@src(), "getting uri slice: ({}, {})", .{ row, col_idx });
            const uri = link.uri.slice(link_page.memory);
            // log.warn(@src(), "yay, got hyperlink for ({}, {}). link={s}", .{ row, col_idx, uri });
            buf[col_idx].uri = uri.ptr;
            buf[col_idx].uri_len = uri.len;
            buf[col_idx].uri_id = link_id;
        }
    }

    return end_col_clamped;
}

/// Fills buf with cell styles from the terminal on line number `lnum` from `start_col` to `end_col`.
/// Returns number of columns filled out, which could be less than `end_col` depending on
/// how many columns are truly in the row (as well as `buf_max_len`).
pub export fn vtermz_fill_buf_lnum_style(
    vt: *VTerm,
    /// Zero indexed line number
    lnum: usize,
    start_col: usize,
    /// End col exclusive
    end_col: usize,
    buf: [*]c.VTermZStyle,
    buf_max_len: usize,
) callconv(.c) usize {
    if (lnum >= vt.t.screens.active.pages.total_rows or start_col > end_col or end_col == 0) {
        // log.warn(@src(), "lnum {} out of range. total rows: {}, start_col: {}, end_col: {}", .{lnum, vt.t.screens.active.pages.total_rows, start_col, end_col});
        return 0;
    }
    // log.warn(@src(), "getting lnum style for lnum={}", .{lnum});
    // TODO: make sure this operation isn't too expensive. I believe the scrollbar
    // should be cached by ghosttty most of the time with how this function gets called.
    // The documentation warns that it can be expensive to calculate depending
    // on the circumstances.
    const sb = vt.t.screens.active.pages.scrollbar();
    const to_scroll = @as(isize, @intCast(lnum)) - @as(isize, @intCast(sb.offset));
    // log.warn(@src(), "sb: {any}, to_scroll={}", .{sb, to_scroll});
    return if (to_scroll >= 0 and to_scroll < sb.len) blk: {
        // row is already in viewport
        // log.warn(@src(), "lnum exists at row {}, no scroll necessary", .{to_scroll});
        break :blk vtermz_fill_buf_row_style(vt, @intCast(to_scroll), start_col, end_col, buf, buf_max_len);
    } else blk: {
        // log.warn(@src(), "scrolling {}", .{to_scroll});
        vt.t.scrollViewport(.{ .delta = to_scroll }) catch {};
        vtermz_refresh(vt);
        const res = vtermz_fill_buf_row_style(vt, 0, start_col, end_col, buf, buf_max_len);
        break :blk res;
    };
}

pub export fn vtermz_update(vt: *VTerm) callconv(.c) void {
    vt.rs.update(vt.allocator, vt.t) catch preserve_exit(e_outofmem);
}

pub export fn vtermz_get_size(vt: *const VTerm, rowsp: ?*u16, colsp: ?*u16) callconv(.c) void {
    // TODO: should this be the vt.rs size or vt.t size?
    if (rowsp) |row| {
        row.* = vt.t.rows;
    }
    if (colsp) |col| {
        col.* = vt.t.cols;
    }
}

pub export fn vtermz_set_size(vt: *VTerm, rows: u16, cols: u16) callconv(.c) void {
    if (rows == 0 or cols == 0) {
        return;
    }

    // log.warn(@src(), "updating term size from ({}, {}) to ({}, {}). total_rows={}", .{ vt.t.rows, vt.t.cols, rows, cols, vt.t.screens.active.pages.total_rows });
    // TODO: is there even anything we can do if it errors?
    vt.t.resize(vt.allocator, @intCast(cols), @intCast(rows)) catch return;
    vt.s.handler.damage_start = 0;
    vt.s.handler.damage_end = @intCast(vt.t.screens.active.pages.total_rows);
    // log.warn(@src(), "new total_rows={}", .{ vt.t.screens.active.pages.total_rows });
}

pub export fn vtermz_set_utf8(vt: *VTerm, is_utf8: bool) callconv(.c) void {
    vt.t.configureCharset(.G0, if (is_utf8) .utf8 else .ascii);
    // vt.t.configureCharset(.G1, if (is_utf8) .utf8 else .ascii);
    // vt.t.configureCharset(.G2, if (is_utf8) .utf8 else .ascii);
    // vt.t.configureCharset(.G3, if (is_utf8) .utf8 else .ascii);
}

pub export fn vtermz_state_set_palette_color(vt: *VTerm, index: u8, col: *const c.VTermZColor) callconv(.c) void {
    if (index >= 0 and index < 16) vt.t.colors.palette.set(index, .{
        .r = col.rgb.r,
        .g = col.rgb.g,
        .b = col.rgb.b,
    });
}

pub export fn vtermz_scroll_linenr(vt: *VTerm, top_linenr: usize) callconv(.c) usize {
    const top = @min(top_linenr, vt.t.screens.active.pages.total_rows - vt.t.rows);
    // log.warn(@src(), "scrolling to linenr: {}, actual={}", .{ top_linenr, top });
    vt.t.screens.active.scroll(.{ .row = top });
    vtermz_refresh(vt);
    return top;
}

pub export fn vtermz_scroll_top(vt: *VTerm) callconv(.c) usize {
    vt.t.scrollViewport(.top) catch {};
    vtermz_refresh(vt);
    return 0;
}

pub export fn vtermz_scroll_bottom(vt: *VTerm) callconv(.c) usize {
    vt.t.scrollViewport(.bottom) catch {};
    vtermz_refresh(vt);
    return vt.t.screens.active.pages.total_rows - vt.t.rows;
}

pub export fn vtermz_top_linenr(vt: *VTerm) callconv(.c) usize {
    return vt.t.screens.active.pages.total_rows - vt.t.rows;
}

pub export fn vtermz_total_rows(vt: *VTerm) callconv(.c) usize {
    return vt.t.screens.active.pages.total_rows;
}

pub export fn vtermz_save_cursor(vt: *VTerm) callconv(.c) void {
    vt.t.saveCursor();
}

pub export fn vtermz_restore_cursor(vt: *VTerm) callconv(.c) void {
    vt.t.restoreCursor() catch {};
}

pub export fn vtermz_start_paste(vt: *VTerm) callconv(.c) void {
    if (vt.t.modes.get(.bracketed_paste)) {
        vt.term_output("\x1b[200~");
    }
}

pub export fn vtermz_end_paste(vt: *VTerm) callconv(.c) void {
    if (vt.t.modes.get(.bracketed_paste)) {
        vt.term_output("\x1b[201~");
    }
}

pub export fn vtermz_delete_from_scrollback(vt: *VTerm, count: usize) callconv(.c) usize {
    const sb_rows = vtermz_total_rows(vt) - vt.t.rows;
    const to_delete = @min(sb_rows, count);
    if (to_delete == 0) return 0;
    vt.t.screens.active.eraseRows(
        .{ .history = .{ .x = 0, .y = 0 } },
        .{ .history = .{ .x = 0, .y = @intCast(to_delete - 1) } },
    );
    return to_delete;
}

test "vterm" {
    const vt = vtermz_new(40, 80);
    defer vtermz_free(vt);

    // const osc_4 = "\x1b]4;1;?\x1b\\\x1b]4;2;?\x1b\\\x1b[1;31m";
    const osc_4 = "\x1b]4;1;?\x1b\x1b]4;2;?\x1b\\\x1b]4;3;?\x07\x1b7\x1b[1;31m\x1b(0\x1b(B\x1b[H";
    const bel = "\x07";
    const bs = "\x08";
    const ht = "\x09";
    const lf = "\x0a";
    const cr = "\x0d";
    const ind = "\x1bD";
    const nel = "\x1bE";
    const hts = "\x1bH";
    const dcs = "\x1bP\x1bP\x1bP";
    const st = "\x1b\\";
    // const more = "\x84\x85\x88\x9c\x9c\x9c\x9d4;1;?\x9c\\";
    const esc_seq = "\x1b(0\x1b(B\x1b(A\x1b(0";
    const apc_seq = "\x1b_nvim;stuff;ARSITENARISENTIAERNSTIEARNST\x1b\\";
    const commands: []const []const u8 = &.{
        osc_4,
        bel,
        bs,
        ht,
        lf,
        cr,
        ind,
        nel,
        hts,
        dcs,
        st,
        esc_seq,
        apc_seq,
    };

    var res: usize = 0;
    for (commands) |cmd| {
        res = vtermz_input_write(vt, cmd.ptr, cmd.len);
    }
    // try std.testing.expectEqual(res, 1);
}

test "utf8 keycaps" {
    // This is a sequence that produced malformed output when opening a file in a nested
    // neovim instance. It moves the cursor manually after every keycap.
    // Oh... I'm pretty sure nvim is getting its positioning wrong. Looks like
    // an off by one. I'm not sure how Ghostty or libvterm normally handle it to make it
    // not broken. Maybe theres some kind of mode I'm missing.
    // 00e3da00: 4b65 7963 6170 733a 1b5b 4b0d 0a30 efb8  Keycaps:.[K..0..
    // 00e3da10: 8fe2 83a3 1b5b 323b 3248 2031 efb8 8fe2  .....[2;2H 1....
    // 00e3da20: 83a3 1b5b 323b 3448 2032 efb8 8fe2 83a3  ...[2;4H 2......
    // 00e3da30: 1b5b 323b 3648 2033 efb8 8fe2 83a3 1b5b  .[2;6H 3.......[
    // Even when I run this printf manually in the terminal, it doesn't seem to produce the right
    // output. The keycaps are overlapping even though it seems like the data should be
    // correct from the logs.
    // printf "\x1b7\x1b[3;1H\x30\xef\xb8\x8f\xe2\x83\xa3\x1b[3;3H\x31\xef\xb8\x8f\xe2\x83\xa3\x1b8"
    // Logs showed this:
    // warning (vterm): vtermz_fill_buf_row_utf8:2351: row=2, col_idx=0: put multi grapheme:  0️⃣
    // warning (vterm): vtermz_fill_buf_row_utf8:2364: row=2, col_idx=0: extra width: 2
    // warning (vterm): vtermz_fill_buf_row_utf8:2351: row=2, col_idx=2: put multi grapheme:  1️⃣
    // warning (vterm): vtermz_fill_buf_row_utf8:2364: row=2, col_idx=2: extra width: 2
    //
    // Okay, I'm not going crazy. nvim incorrectly calculates the width as 1. You can test it with
    // the following:
    // const char *keycap0 = "\x30\xef\xb8\x8f\xe2\x83\xa3";
    //
    // int cell_count = utf_ptr2cells(keycap0);
    // assert(cell_count == 2);

    const vt = vtermz_new(3, 20);
    defer vtermz_free(vt);
    var out_buf: [256]u8 = undefined;

    // 31 = ASCII digit "1"
    // EF B8 8F = Variation Selector-16
    // E2 83 A3 = Combining Enclosing Keycap
    const keycap_main = "\xef\xb8\x8f\xe2\x83\xa3";
    const keycap_0 = "\x30" ++ keycap_main;
    const keycap_1 = "\x31" ++ keycap_main;
    const keycap_2 = "\x32" ++ keycap_main;
    const keycap_3 = "\x33" ++ keycap_main;
    try std.testing.expectEqual(0, vt.t.screens.active.cursor.x);
    try std.testing.expectEqual(0, vt.t.screens.active.cursor.y);
    var moveCursor = "\x1b[1;2H";
    _ = vtermz_input_write(vt, moveCursor, moveCursor.len);
    try std.testing.expectEqual(1, vt.t.screens.active.cursor.x);
    moveCursor = "\x1b[1;1H";
    _ = vtermz_input_write(vt, moveCursor, moveCursor.len);
    try std.testing.expectEqual(0, vt.t.screens.active.cursor.x);
    try std.testing.expectEqual(0, vt.t.screens.active.cursor.y);
    const key0 = keycap_0 ++ "\x1b[1;3H";
    _ = vtermz_input_write(vt, key0, key0.len);
    vtermz_refresh(vt);
    _ = vtermz_fill_buf_row_utf8(vt, 0, 0, 20, &out_buf, out_buf.len);
    try std.testing.expectEqualSlices(u8, keycap_0, out_buf[0..keycap_0.len]);
    const key1 = keycap_1 ++ "\x1b[1;5H";
    _ = vtermz_input_write(vt, key1, key1.len);
    vtermz_refresh(vt);
    _ = vtermz_fill_buf_row_utf8(vt, 0, 0, 20, &out_buf, out_buf.len);
    try std.testing.expectEqualSlices(u8, keycap_0 ++ keycap_1, out_buf[0 .. 2 * keycap_0.len]);
    const key2 = keycap_2 ++ "\x1b[1;7H";
    _ = vtermz_input_write(vt, key2, key2.len);
    vtermz_refresh(vt);
    _ = vtermz_fill_buf_row_utf8(vt, 0, 0, 20, &out_buf, out_buf.len);
    try std.testing.expectEqualSlices(u8, keycap_0 ++ keycap_1 ++ keycap_2, out_buf[0 .. 3 * keycap_0.len]);
    const key3 = keycap_3;
    _ = vtermz_input_write(vt, key3, key3.len);
    vtermz_refresh(vt);
    _ = vtermz_fill_buf_row_utf8(vt, 0, 0, 20, &out_buf, out_buf.len);
    try std.testing.expectEqualSlices(u8, keycap_0 ++ keycap_1 ++ keycap_2 ++ keycap_3, out_buf[0 .. 4 * keycap_0.len]);

    // const all_keycaps = // "\r\n" ++ //"\x1b[2;1H" ++
    //     keycap_0 ++ "\x1b[1;2H" ++ " " ++
    //     keycap_1 ++ "\x1b[1;4H" ++ " " ++
    //     keycap_2 ++ "\x1b[1;6H" ++ " " ++
    //     keycap_3;
    // _ = vtermz_input_write(vt, all_keycaps, all_keycaps.len);
    // vtermz_refresh(vt);
    // _ = vtermz_fill_buf_row_utf8(vt, 0, 0, 20, &out_buf, out_buf.len);
    // const expected = keycap_0 ++ " " ++ keycap_1 ++ " " ++ keycap_2 ++ " " ++ keycap_3;
    // try std.testing.expectEqualSlices(u8, expected, out_buf[0..expected.len]);
}

test "scrollback" {
    const vt = vtermz_new(3, 20);
    defer vtermz_free(vt);
    var out_buf: [256]u8 = undefined;

    const rows = [_][]const u8{
        "ABC",
        "DEF",
        "GHI",
        "JKL",
        "MNO",
        "PQR",
        "STU",
        "VWX",
        "YZA",
        "BCD",
    };

    for (rows, 0..) |row, idx| {
        if (idx > 0) {
            _ = vtermz_input_write(vt, "\r\n", 2);
        }
        _ = vtermz_input_write(vt, row.ptr, row.len);
    }

    for (0..rows.len - vt.t.rows) |scroll_amount| {
        vtermz_refresh(vt);
        for (rows[rows.len - vt.t.rows - scroll_amount .. rows.len - scroll_amount], 0..) |row, idx| {
            _ = vtermz_fill_buf_row_utf8(vt, @intCast(idx), 0, 20, &out_buf, out_buf.len);
            try std.testing.expectEqualSlices(u8, row, out_buf[0..row.len]);
        }
        try vt.t.scrollViewport(.{ .delta = -1 });
    }

    vt.t.screens.active.scroll(.{ .row = 100 });
    vtermz_refresh(vt);
    for (0..rows.len - vt.t.rows) |scroll_amount| {
        vtermz_refresh(vt);
        for (rows[rows.len - vt.t.rows - scroll_amount .. rows.len - scroll_amount], 0..) |row, idx| {
            _ = vtermz_fill_buf_row_utf8(vt, @intCast(idx), 0, 20, &out_buf, out_buf.len);
            try std.testing.expectEqualSlices(u8, row, out_buf[0..row.len]);
        }
        try vt.t.scrollViewport(.{ .delta = -1 });
    }

    vt.t.screens.active.scroll(.{ .row = 1 });
    vtermz_refresh(vt);
    _ = vtermz_fill_buf_row_utf8(vt, 0, 0, 20, &out_buf, out_buf.len);
    try std.testing.expectEqualSlices(u8, rows[1], out_buf[0..rows[1].len]);

    vt.t.screens.active.scroll(.{ .row = 100 });
    vtermz_refresh(vt);
    _ = vtermz_fill_buf_row_utf8(vt, 0, 0, 20, &out_buf, out_buf.len);
    try std.testing.expectEqualSlices(u8, rows[rows.len - vt.t.rows], out_buf[0..rows[rows.len - vt.t.rows].len]);
}

test "scrollback and dirty" {
    const vt = vtermz_new(3, 20);
    defer vtermz_free(vt);
    var out_buf: [256]u8 = undefined;

    const rows = [_][]const u8{
        "ABC",
        "DEF",
        "GHI",
        "JKL",
        "MNO",
        "PQR",
        "STU",
        "VWX",
        "YZA",
        "BCD",
    };

    for (rows, 0..) |row, idx| {
        if (idx > 0) {
            _ = vtermz_input_write(vt, "\r\n", 2);
        }
        _ = vtermz_input_write(vt, row.ptr, row.len);
    }

    vtermz_refresh(vt);
    for (vt.rs.row_data.items(.dirty)) |*dirty| {
        dirty.* = false;
    }
    for (vt.rs.row_data.items(.dirty)) |dirty| {
        try std.testing.expect(!dirty);
    }
    _ = vtermz_scroll_bottom(vt);
    _ = vtermz_scroll_top(vt);
    // for (vt.rs.row_data.items(.dirty)) |dirty| {
    //   try std.testing.expect(!dirty);
    // }

    _ = &out_buf;
    // for (0..rows.len - vt.t.rows) |scroll_amount| {
    //     for (rows[rows.len - vt.t.rows - scroll_amount .. rows.len - scroll_amount], 0..) |row, idx| {
    //         _ = vtermz_fill_buf_row_utf8(vt, @intCast(idx), 0, 20, &out_buf, out_buf.len);
    //         try std.testing.expectEqualSlices(u8, row, out_buf[0..row.len]);
    //     }
    //     try vt.t.scrollViewport(.{ .delta = -1 });
    // }
    //
    // vt.t.screens.active.scroll(.{ .row = 100 });
    // vtermz_refresh(vt);
    // for (0..rows.len - vt.t.rows) |scroll_amount| {
    //     vtermz_refresh(vt);
    //     for (rows[rows.len - vt.t.rows - scroll_amount .. rows.len - scroll_amount], 0..) |row, idx| {
    //         _ = vtermz_fill_buf_row_utf8(vt, @intCast(idx), 0, 20, &out_buf, out_buf.len);
    //         try std.testing.expectEqualSlices(u8, row, out_buf[0..row.len]);
    //     }
    //     try vt.t.scrollViewport(.{ .delta = -1 });
    // }
    //
    // vt.t.screens.active.scroll(.{ .row = 1 });
    // vtermz_refresh(vt);
    // _ = vtermz_fill_buf_row_utf8(vt, 0, 0, 20, &out_buf, out_buf.len);
    // try std.testing.expectEqualSlices(u8, rows[1], out_buf[0..rows[1].len]);
    //
    // vt.t.screens.active.scroll(.{ .row = 100 });
    // vtermz_refresh(vt);
    // _ = vtermz_fill_buf_row_utf8(vt, 0, 0, 20, &out_buf, out_buf.len);
    // try std.testing.expectEqualSlices(u8, rows[rows.len - vt.t.rows], out_buf[0..rows[rows.len - vt.t.rows].len]);
}

test "delete from scrollback" {
    const vt = vtermz_new(5, 20);
    defer vtermz_free(vt);

    for (0..20) |idx| {
        var line_buf: [10]u8 = undefined;
        const buf = try std.fmt.bufPrint(&line_buf, "{}\r\n", .{idx});
        _ = vtermz_input_write(vt, buf.ptr, buf.len);
    }
    // TODO: write test for deleting scrollback
}
