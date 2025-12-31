const std = @import("std");
const c = @cImport({
    @cInclude("terminal.bridge.h");
});
extern var main_loop: @TypeOf(c.main_loop);

// pub const struct_VTerm = opaque {};
pub const VTerm = c.VTerm; // struct_VTerm;
// pub const struct_VTermState = opaque {};
pub const VTermState = c.VTermState; //struct_VTermState;
// src/nvim/vterm/vterm.h:146:12: warning: struct demoted to opaque type - has bitfield
// pub const struct_VTermScreen = opaque {};
pub const VTermScreen = c.VTermScreen; //struct_VTermScreen;
const TermCursor = extern struct {
    row: c_int = @import("std").mem.zeroes(c_int),
    col: c_int = @import("std").mem.zeroes(c_int),
    shape: c_int = @import("std").mem.zeroes(c_int),
    visible: bool = @import("std").mem.zeroes(bool),
    blink: bool = @import("std").mem.zeroes(bool),
};
const TermPending = extern struct {
    resize: bool = @import("std").mem.zeroes(bool),
    cursor: bool = @import("std").mem.zeroes(bool),
    send: [*c]StringBuilder = @import("std").mem.zeroes([*c]StringBuilder),
    events: ?*MultiQueue = @import("std").mem.zeroes(?*MultiQueue),
};
// pub const struct_multiqueue = opaque {};
pub const MultiQueue = c.MultiQueue; // struct_multiqueue;
// pub const Terminal = extern struct {
//     opts: TerminalOptions = @import("std").mem.zeroes(TerminalOptions),
//     vt: ?*VTerm = @import("std").mem.zeroes(?*VTerm),
//     vts: ?*VTermScreen = @import("std").mem.zeroes(?*VTermScreen),
//     textbuf: [8191]u8 = @import("std").mem.zeroes([8191]u8),
//     sb_buffer: [*c][*c]ScrollbackLine = @import("std").mem.zeroes([*c][*c]ScrollbackLine),
//     sb_current: usize = @import("std").mem.zeroes(usize),
//     sb_size: usize = @import("std").mem.zeroes(usize),
//     sb_pending: c_int = @import("std").mem.zeroes(c_int),
//     sb_deleted: usize = @import("std").mem.zeroes(usize),
//     sb_deleted_last: usize = @import("std").mem.zeroes(usize),
//     title: [*c]u8 = @import("std").mem.zeroes([*c]u8),
//     title_len: usize = @import("std").mem.zeroes(usize),
//     title_size: usize = @import("std").mem.zeroes(usize),
//     buf_handle: handle_T = @import("std").mem.zeroes(handle_T),
//     closed: bool = @import("std").mem.zeroes(bool),
//     destroy: bool = @import("std").mem.zeroes(bool),
//     forward_mouse: bool = @import("std").mem.zeroes(bool),
//     invalid_start: c_int = @import("std").mem.zeroes(c_int),
//     invalid_end: c_int = @import("std").mem.zeroes(c_int),
//     cursor: TermCursor = @import("std").mem.zeroes(TermCursor),
//     pending: TermPending = @import("std").mem.zeroes(TermPending),
//     theme_updates: bool = @import("std").mem.zeroes(bool),
//     color_set: [16]bool = @import("std").mem.zeroes([16]bool),
//     selection_buffer: [*c]u8 = @import("std").mem.zeroes([*c]u8),
//     selection: StringBuilder = @import("std").mem.zeroes(StringBuilder),
//     termrequest_buffer: StringBuilder = @import("std").mem.zeroes(StringBuilder),
//     termrequest_terminator: VTermTerminator = @import("std").mem.zeroes(VTermTerminator),
//     refcount: usize = @import("std").mem.zeroes(usize),
// };
pub const Terminal = c.Terminal; // struct_terminal;
pub const buf_T = c.buf_T;
pub const xcalloc = c.xcalloc;
extern var shape_table: @TypeOf(c.shape_table);
pub const SHAPE_IDX_TERM = c.SHAPE_IDX_TERM;
pub const multiqueue_new = c.multiqueue_new;
pub const aco_save_T = c.aco_save_T;
pub const aucmd_prepbuf = c.aucmd_prepbuf;
pub const set_option_value = c.set_option_value;
pub const kOptBuftype = c.kOptBuftype;
pub const OptVal = c.OptVal;
pub const kOptValTypeString = c.kOptValTypeString;
pub const OptValData = c.OptValData;
pub const String = c.String;
pub const OPT_LOCAL = c.OPT_LOCAL;
pub const strlen = c.strlen;
extern var curwin: @TypeOf(c.curwin);
pub const pos_T = c.pos_T;
pub const apply_autocmds = c.apply_autocmds;
pub const EVENT_TERMOPEN = c.EVENT_TERMOPEN;
pub const aucmd_restbuf = c.aucmd_restbuf;
pub const OptInt = c.OptInt;
pub const xmalloc = c.xmalloc;
pub const snprintf = c.snprintf;
pub const RgbValue = c.RgbValue;
pub const name_to_color = c.name_to_color;
extern var exiting: @TypeOf(c.exiting);
pub const block_autocmds = c.block_autocmds;
pub const unblock_autocmds = c.unblock_autocmds;
pub const map_get_intptr_t = c.map_get_intptr_t;
extern var buffer_handles: @TypeOf(c.buffer_handles);
pub const Channel = c.Channel;
pub const kChannelStreamInternal = c.kChannelStreamInternal;
pub const is_autocmd_blocked = c.is_autocmd_blocked;
pub const save_v_event_T = c.save_v_event_T;
pub const dict_T = c.dict_T;
pub const get_v_event = c.get_v_event;
pub const tv_dict_add_nr = c.tv_dict_add_nr;
pub const varnumber_T = c.varnumber_T;
pub const tv_dict_set_keys_readonly = c.tv_dict_set_keys_readonly;
pub const EVENT_TERMCLOSE = c.EVENT_TERMCLOSE;
pub const restore_v_event = c.restore_v_event;
pub const tabpage_T = c.tabpage_T;
extern var first_tabpage: @TypeOf(c.first_tabpage);
pub const win_T = c.win_T;
extern var curtab: @TypeOf(c.curtab);
extern var firstwin: @TypeOf(c.firstwin);
pub const is_aucmd_win = c.is_aucmd_win;
pub const win_col_off = c.win_col_off;
extern var curbuf: @TypeOf(c.curbuf);
pub const VimState = c.VimState;
pub const state_execute_callback = c.state_execute_callback;
pub const handle_T = c.handle_T;
pub const stop_insert_mode = c.stop_insert_mode;
extern var State: @TypeOf(c.State);
pub const RedrawingDisabled = c.RedrawingDisabled;
pub const MODE_TERMINAL = c.MODE_TERMINAL;
pub const mapped_ctrl_c = c.mapped_ctrl_c;
pub const showmode = c.showmode;
pub const ui_cursor_shape = c.ui_cursor_shape;
pub const buf_get_changedtick = c.buf_get_changedtick;
pub const EVENT_TERMENTER = c.EVENT_TERMENTER;
pub const may_trigger_modechanged = c.may_trigger_modechanged;
pub const state_enter = c.state_enter;
pub const restart_edit = c.restart_edit;
pub const ui_busy_stop = c.ui_busy_stop;
pub const parse_shape_opt = c.parse_shape_opt;
pub const unshowmode = c.unshowmode;
pub const EVENT_TERMLEAVE = c.EVENT_TERMLEAVE;
pub const do_buffer = c.do_buffer;
pub const DOBUF_WIPE = c.DOBUF_WIPE;
pub const DOBUF_FIRST = c.DOBUF_FIRST;
pub const FORWARD = c.FORWARD;
pub const set_has_ptr_t = c.set_has_ptr_t;
pub const ptr_t = c.ptr_t;
pub const set_del_ptr_t = c.set_del_ptr_t;
pub const xfree = c.xfree;
pub const multiqueue_free = c.multiqueue_free;
pub const xrealloc = c.xrealloc;
pub const utf_ptr2len = c.utf_ptr2len;
pub const utf_ptr2char = c.utf_ptr2char;
pub const memcpy = c.memcpy;
pub const StringBuilder = c.StringBuilder;
pub const TERM_ATTRS_MAX = c.TERM_ATTRS_MAX;
pub const HL_BOLD = c.HL_BOLD;
pub const HL_ITALIC = c.HL_ITALIC;
pub const HL_INVERSE = c.HL_INVERSE;
pub const HL_STRIKETHROUGH = c.HL_STRIKETHROUGH;
pub const HL_FG_INDEXED = c.HL_FG_INDEXED;
pub const HL_BG_INDEXED = c.HL_BG_INDEXED;
pub const HlAttrs = c.HlAttrs;
pub const hl_get_term_attr = c.hl_get_term_attr;
pub const hl_combine_attr = c.hl_combine_attr;
pub const Buffer = c.Buffer;
pub const schar_T = c.schar_T;
pub const Error = c.Error;
pub const WinConfig = c.WinConfig;
pub const frame_T = c.frame_T;
pub const WinInfo = c.WinInfo;
pub const garray_T = c.garray_T;
pub const optset_T = c.optset_T;
pub const multiqueue_put_event = c.multiqueue_put_event;
pub const Event = c.Event;
pub const set_vim_var_string = c.set_vim_var_string;
pub const VV_TERMREQUEST = c.VV_TERMREQUEST;
pub const ptrdiff_t = c.ptrdiff_t;
pub const Array = c.Array;
pub const Object = c.Object;
pub const kObjectTypeInteger = c.kObjectTypeInteger;
pub const Integer = c.Integer;
pub const Dict = c.Dict;
pub const KeyValuePair = c.KeyValuePair;
pub const cstr_as_string = c.cstr_as_string;
pub const kObjectTypeString = c.kObjectTypeString;
pub const kObjectTypeArray = c.kObjectTypeArray;
pub const kObjectTypeDict = c.kObjectTypeDict;
pub const apply_autocmds_group = c.apply_autocmds_group;
pub const EVENT_TERMREQUEST = c.EVENT_TERMREQUEST;
pub const AUGROUP_ALL = c.AUGROUP_ALL;
pub const xmemdup = c.xmemdup;
pub const hl_add_url = c.hl_add_url;
pub const has_event = c.has_event;
pub const kv_do_printf = c.kv_do_printf;
pub const kOptCuloptFlagNumber = c.kOptCuloptFlagNumber;
pub const strequal = c.strequal;
pub const xstrdup = c.xstrdup;
pub const redraw_later = c.redraw_later;
pub const UPD_SOME_VALID = c.UPD_SOME_VALID;
pub const UPD_VALID = c.UPD_VALID;
pub const window_handles = c.window_handles;
pub const free_string_option = c.free_string_option;
pub const linenr_T = c.linenr_T;
pub const set_topline = c.set_topline;
pub const coladvance = c.coladvance;
pub const validate_cursor = c.validate_cursor;
pub const EVENT_TEXTCHANGEDT = c.EVENT_TEXTCHANGEDT;
pub const show_cursor_info_later = c.show_cursor_info_later;
pub const must_redraw = c.must_redraw;
pub const update_screen = c.update_screen;
pub const redraw_statuslines = c.redraw_statuslines;
pub const clear_cmdline = c.clear_cmdline;
pub const redraw_cmdline = c.redraw_cmdline;
pub const redraw_mode = c.redraw_mode;
pub const setcursor = c.setcursor;
pub const ui_flush = c.ui_flush;
pub const kOptTpfFlagBS = c.kOptTpfFlagBS;
pub const kOptTpfFlagHT = c.kOptTpfFlagHT;
pub const kOptTpfFlagFF = c.kOptTpfFlagFF;
pub const kOptTpfFlagESC = c.kOptTpfFlagESC;
pub const kOptTpfFlagDEL = c.kOptTpfFlagDEL;
pub const kOptTpfFlagC0 = c.kOptTpfFlagC0;
pub const kOptTpfFlagC1 = c.kOptTpfFlagC1;
extern var tpf_flags: @TypeOf(c.tpf_flags);
pub const HL_UNDERLINE = c.HL_UNDERLINE;
pub const HL_UNDERDOUBLE = c.HL_UNDERDOUBLE;
pub const HL_UNDERCURL = c.HL_UNDERCURL;
pub const kErrorTypeNone = c.kErrorTypeNone;
pub const dict_set_var = c.dict_set_var;
pub const api_clear_error = c.api_clear_error;
pub const status_redraw_buf = c.status_redraw_buf;
pub const vim_beep = c.vim_beep;
pub const kOptBoFlagTerm = c.kOptBoFlagTerm;
extern var p_bg: @TypeOf(c.p_bg);
pub const memmove = c.memmove;
pub const set_put_ptr_t = c.set_put_ptr_t;
pub const list_T = c.list_T;
pub const tv_list_alloc = c.tv_list_alloc;
pub const tv_list_append_allocated_string = c.tv_list_append_allocated_string;
pub const tv_list_append_list = c.tv_list_append_list;
pub const tv_list_append_string = c.tv_list_append_string;
pub const eval_call_provider = c.eval_call_provider;
pub const xmemdupz = c.xmemdupz;
pub const mod_mask = c.mod_mask;
pub const time_watcher_start = c.time_watcher_start;
pub const buf_valid = c.buf_valid;
pub const multiqueue_move_events = c.multiqueue_move_events;
pub const ui_busy_start = c.ui_busy_start;
pub const SHAPE_BLOCK = c.SHAPE_BLOCK;
pub const SHAPE_HOR = c.SHAPE_HOR;
pub const SHAPE_VER = c.SHAPE_VER;
pub const ui_mode_info_set = c.ui_mode_info_set;
pub const TimeWatcher = c.TimeWatcher;
pub const mh_clear = c.mh_clear;
pub const abort = c.abort;
pub const ml_delete_buf = c.ml_delete_buf;
pub const mark_adjust_buf = c.mark_adjust_buf;
pub const MAXLNUM = c.MAXLNUM;
pub const kMarkAdjustTerm = c.kMarkAdjustTerm;
pub const kExtmarkUndo = c.kExtmarkUndo;
pub const deleted_lines_buf = c.deleted_lines_buf;
pub const ml_append_buf = c.ml_append_buf;
pub const appended_lines_buf = c.appended_lines_buf;
pub const ml_replace_buf = c.ml_replace_buf;
pub const changed_lines = c.changed_lines;
pub const mb_check_adjust_col = c.mb_check_adjust_col;
pub const dict_get_value = c.dict_get_value;
pub const kObjectTypeNil = c.kObjectTypeNil;
pub const get_globvar_dict = c.get_globvar_dict;
pub const api_free_object = c.api_free_object;
pub const Set_ptr_t = c.Set_ptr_t;
pub const MapHash = c.MapHash;

pub const terminal_write_cb = ?*const fn ([*c]const u8, usize, ?*anyopaque) callconv(.c) void;
pub const terminal_resize_cb = ?*const fn (u16, u16, ?*anyopaque) callconv(.c) void;
pub const terminal_close_cb = ?*const fn (?*anyopaque) callconv(.c) void;
// pub const TerminalOptions = extern struct {
//     data: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
//     width: u16 = @import("std").mem.zeroes(u16),
//     height: u16 = @import("std").mem.zeroes(u16),
//     write_cb: terminal_write_cb = @import("std").mem.zeroes(terminal_write_cb),
//     resize_cb: terminal_resize_cb = @import("std").mem.zeroes(terminal_resize_cb),
//     close_cb: terminal_close_cb = @import("std").mem.zeroes(terminal_close_cb),
//     force_crlf: bool = @import("std").mem.zeroes(bool),
// };
pub const TerminalOptions = c.TerminalOptions;
pub export fn terminal_init() void {
    c.time_watcher_init(&main_loop, term_refresh_timer(), null);
    term_refresh_timer().?.events = c.multiqueue_new_child(main_loop.events);
}
pub export fn terminal_teardown() void {
    c.time_watcher_stop(term_refresh_timer());
    c.multiqueue_free(term_refresh_timer().?.events);
    c.time_watcher_close(term_refresh_timer(), null);
    while (true) {
        c.xfree(@as(?*anyopaque, @ptrCast((&invalidated_terminals).*.keys)));
        c.xfree(@as(?*anyopaque, @ptrCast((&invalidated_terminals).*.h.hash)));
        (&invalidated_terminals).* = c.Set_ptr_t{
            .h = c.MapHash{
                .n_buckets = @as(u32, @bitCast(@as(c_int, 0))),
                .size = @as(u32, @bitCast(@as(c_int, 0))),
                .n_occupied = @as(u32, @bitCast(@as(c_int, 0))),
                .upper_bound = @as(u32, @bitCast(@as(c_int, 0))),
                .n_keys = @as(u32, @bitCast(@as(c_int, 0))),
                .keys_capacity = @as(u32, @bitCast(@as(c_int, 0))),
                .hash = null,
            },
            .keys = null,
        };
        if (!false) break;
    }
    invalidated_terminals = c.Set_ptr_t{
        .h = c.MapHash{
            .n_buckets = @as(u32, @bitCast(@as(c_int, 0))),
            .size = @as(u32, @bitCast(@as(c_int, 0))),
            .n_occupied = @as(u32, @bitCast(@as(c_int, 0))),
            .upper_bound = @as(u32, @bitCast(@as(c_int, 0))),
            .n_keys = @as(u32, @bitCast(@as(c_int, 0))),
            .keys_capacity = @as(u32, @bitCast(@as(c_int, 0))),
            .hash = null,
        },
        .keys = null,
    };
}
pub export fn terminal_open(arg_termpp: [*c]?*Terminal, arg_buf: [*c]buf_T, arg_opts: TerminalOptions) callconv(.c) void {
    const termpp = arg_termpp;
    const buf = arg_buf;
    const opts = arg_opts;
    const term: [*c]Terminal = blk: {
        const tmp = @as([*c]Terminal, @ptrCast(@alignCast(xcalloc(1, @sizeOf(Terminal)))));
        termpp.* = tmp;
        break :blk tmp;
    };
    term.*.opts = opts;
    // std.debug.print("term opts: {}\n", .{term.*.opts});
    term.*.buf_handle = buf.*.handle;
    buf.*.terminal = term;
    // std.debug.print("calling vterm_new\n", .{});
    term.*.vt = vterm_new(opts.height, opts.width);
    // if (term.*.vt == null) {
    //   std.debug.print("ERROR: did not get vt from vterm_new\n", .{});
    // }
    // std.debug.print("calling vterm_set_utf8\n", .{});
    vterm_set_utf8(term.*.vt, 1);
    // std.debug.print("calling vterm_obtain_state", .{});
    var state: ?*VTermState = vterm_obtain_state(term.*.vt);
    // if (state == null) {
    //   std.debug.print("ERROR: did not get state from vterm_obtain_state\n", .{});
    // }
    _ = &state;
    // std.debug.print("calling vterm_obtain_screen", .{});
    term.*.vts = vterm_obtain_screen(term.*.vt);
    // if (term.*.vts == null) {
    //   std.debug.print("ERROR: did not get vts from vterm_obtain_screen\n", .{});
    // }
    // std.debug.print("calling vterm_enable_altscreen", .{});
    vterm_screen_enable_altscreen(term.*.vts, 1);
    // std.debug.print("calling vterm_enable_reflow", .{});
    vterm_screen_enable_reflow(term.*.vts, true);
    // std.debug.print("calling vterm_set_callbacks", .{});
    vterm_screen_set_callbacks(term.*.vts, &vterm_screen_callbacks, @as(?*anyopaque, @ptrCast(term)));
    // std.debug.print("calling vterm_set_unrecognised_callbacks", .{});
    vterm_screen_set_unrecognised_fallbacks(term.*.vts, &vterm_fallbacks, @as(?*anyopaque, @ptrCast(term)));
    // std.debug.print("calling vterm_set_damage_merge", .{});
    vterm_screen_set_damage_merge(term.*.vts, VTERM_DAMAGE_SCROLL);
    // std.debug.print("calling vterm_screen_reset", .{});
    vterm_screen_reset(term.*.vts, 1);
    // std.debug.print("calling vterm_output_set_callback", .{});
    vterm_output_set_callback(term.*.vt, &term_output_callback, @as(?*anyopaque, @ptrCast(term)));
    // std.debug.print("calling vterm_output_set_callback", .{});
    term.*.selection_buffer = @as([*c]u8, @ptrCast(@alignCast(xcalloc(@as(usize, @bitCast(@as(c_long, @as(c_int, 1024)))), @as(usize, @bitCast(@as(c_long, @as(c_int, 1))))))));
    // std.debug.print("calling vterm_state_set_selection_callbacks", .{});
    vterm_state_set_selection_callbacks(state, &vterm_selection_callbacks, @as(?*anyopaque, @ptrCast(term)), term.*.selection_buffer, @as(usize, @bitCast(@as(c_long, @as(c_int, 1024)))));
    var cursor_shape: VTermValue = undefined;
    _ = &cursor_shape;
    // std.debug.print("before while loop", .{});
    while (true) {
        switch (shape_table[@as(c_uint, @intCast(SHAPE_IDX_TERM))].shape) {
            @as(c_uint, @bitCast(@as(c_int, 0))) => {
                cursor_shape.number = VTERM_PROP_CURSORSHAPE_BLOCK;
                break;
            },
            @as(c_uint, @bitCast(@as(c_int, 1))) => {
                cursor_shape.number = VTERM_PROP_CURSORSHAPE_UNDERLINE;
                break;
            },
            @as(c_uint, @bitCast(@as(c_int, 2))) => {
                cursor_shape.number = VTERM_PROP_CURSORSHAPE_BAR_LEFT;
                break;
            },
            else => {},
        }
        break;
    }
    // std.debug.print("after while loop", .{});
    _ = vterm_state_set_termprop(state, @as(c_uint, @bitCast(VTERM_PROP_CURSORSHAPE)), &cursor_shape);
    var cursor_blink: VTermValue = undefined;
    _ = &cursor_blink;
    if ((shape_table[@as(c_uint, @intCast(SHAPE_IDX_TERM))].blinkon != @as(c_int, 0)) and (shape_table[@as(c_uint, @intCast(SHAPE_IDX_TERM))].blinkoff != @as(c_int, 0))) {
        cursor_blink.boolean = 1;
    } else {
        cursor_blink.boolean = 0;
    }
    _ = vterm_state_set_termprop(state, @as(c_uint, @bitCast(VTERM_PROP_CURSORBLINK)), &cursor_blink);
    term.*.invalid_start = 0;
    term.*.invalid_end = @as(c_int, @bitCast(@as(c_uint, opts.height)));
    term.*.pending.events = multiqueue_new(null, @as(?*anyopaque, @ptrFromInt(@as(c_int, 0))));
    var aco: aco_save_T = undefined;
    _ = &aco;

    // std.debug.print("before prepbuf", .{});
    aucmd_prepbuf(&aco, buf);
    // std.debug.print("before refresh_screen", .{});
    refresh_screen(term, buf);
    _ = set_option_value(kOptBuftype, OptVal{
        .type = kOptValTypeString,
        .data = OptValData{
            .string = String{
                .data = @as([*c]u8, @ptrCast(@constCast(@volatileCast("terminal")))),
                .size = @sizeOf([9]u8) -% @as(c_ulong, @bitCast(@as(c_long, @as(c_int, 1)))),
            },
        },
    }, OPT_LOCAL);
    if (buf.*.b_ffname != @as([*c]u8, @ptrCast(@alignCast(@as(?*anyopaque, @ptrFromInt(@as(c_int, 0))))))) {
        buf_set_term_title(buf, buf.*.b_ffname, strlen(buf.*.b_ffname));
    }
    while (true) {
        curwin.*.w_onebuf_opt.wo_scb = 0;
        curwin.*.w_onebuf_opt.wo_crb = 0;
        if (!false) break;
    }
    curwin.*.w_cursor = pos_T{
        .lnum = @as(c_int, 1),
        .col = @as(c_int, 0),
        .coladd = @as(c_int, 0),
    };
    term.*.sb_buffer = null;
    _ = apply_autocmds(@as(c_uint, @bitCast(EVENT_TERMOPEN)), null, null, @as(c_int, 0) != 0, buf);
    aucmd_restbuf(&aco);
    if (termpp.* == @as([*c]Terminal, @ptrCast(@alignCast(@as(?*anyopaque, @ptrFromInt(@as(c_int, 0))))))) {
        return;
    }
    if (term.*.sb_buffer == @as([*c][*c]ScrollbackLine, @ptrCast(@alignCast(@as(?*anyopaque, @ptrFromInt(@as(c_int, 0))))))) {
        if (buf.*.b_p_scbk < @as(OptInt, @bitCast(@as(c_long, @as(c_int, 1))))) {
            buf.*.b_p_scbk = @as(OptInt, @bitCast(@as(c_long, @as(c_int, 1000000))));
        }
        term.*.sb_size = @as(usize, @bitCast(buf.*.b_p_scbk));
        term.*.sb_buffer = @as([*c][*c]ScrollbackLine, @ptrCast(@alignCast(xmalloc(@sizeOf([*c]ScrollbackLine) *% term.*.sb_size))));
    }
    {
        var i: c_int = 0;
        _ = &i;
        while (i < @as(c_int, 16)) : (i += 1) {
            var @"var": [64]u8 = undefined;
            _ = &@"var";
            _ = snprintf(@as([*c]u8, @ptrCast(@alignCast(&@"var"[@as(usize, @intCast(0))]))), @sizeOf([64]u8), "terminal_color_%d", i);
            var name: [*c]u8 = get_config_string(@as([*c]u8, @ptrCast(@alignCast(&@"var"[@as(usize, @intCast(0))]))));
            _ = &name;
            if (name != null) {
                var dummy: c_int = undefined;
                _ = &dummy;
                var color_val: RgbValue = name_to_color(name, &dummy);
                _ = &color_val;
                if (color_val != -@as(c_int, 1)) {
                    var color: VTermColor = undefined;
                    _ = &color;
                    vterm_color_rgb(&color, @as(u8, @bitCast(@as(i8, @truncate((color_val >> @intCast(16)) & @as(c_int, 255))))), @as(u8, @bitCast(@as(i8, @truncate((color_val >> @intCast(8)) & @as(c_int, 255))))), @as(u8, @bitCast(@as(i8, @truncate((color_val >> @intCast(0)) & @as(c_int, 255))))));
                    vterm_state_set_palette_color(state, i, &color);
                    term.*.color_set[@as(c_uint, @intCast(i))] = @as(c_int, 1) != 0;
                }
            }
        }
    }

    // std.debug.print("finished terminal_open", .{});
}
pub export fn terminal_close(arg_termpp: [*c][*c]Terminal, arg_status: c_int) void {
    var termpp = arg_termpp;
    _ = &termpp;
    var status = arg_status;
    _ = &status;
    var term: [*c]Terminal = termpp.*;
    _ = &term;
    if (term.*.destroy) {
        return;
    }
    var only_destroy: bool = @as(c_int, 0) != 0;
    _ = &only_destroy;
    if (term.*.closed) {
        only_destroy = @as(c_int, 1) != 0;
    } else {
        term.*.forward_mouse = @as(c_int, 0) != 0;
        if (!exiting) {
            block_autocmds();
            refresh_terminal(term);
            unblock_autocmds();
        }
        term.*.closed = @as(c_int, 1) != 0;
    }
    var buf: [*c]buf_T = @as([*c]buf_T, @ptrCast(@alignCast(map_get_intptr_t(&buffer_handles, term.*.buf_handle))));
    _ = &buf;
    if ((status == -@as(c_int, 1)) or (@as(c_int, @intFromBool(exiting)) != 0)) {
        term.*.buf_handle = 0;
        if (buf != null) {
            buf.*.terminal = null;
        }
        if (!(term.*.refcount != 0)) {
            term.*.destroy = @as(c_int, 1) != 0;
            term.*.opts.close_cb.?(term.*.opts.data);
        }
    } else if (!only_destroy) {
        var msg_1: [85]u8 = undefined;
        _ = &msg_1;
        if (@as([*c]Channel, @ptrCast(@alignCast(term.*.opts.data))).*.streamtype == @as(c_uint, @bitCast(kChannelStreamInternal))) {
            _ = snprintf(@as([*c]u8, @ptrCast(@alignCast(&msg_1[@as(usize, @intCast(0))]))), @sizeOf([85]u8), "\r\n[Terminal closed]");
        } else {
            _ = snprintf(@as([*c]u8, @ptrCast(@alignCast(&msg_1[@as(usize, @intCast(0))]))), @sizeOf([85]u8), "\r\n[Process exited %d]", status);
        }
        terminal_receive(term, @as([*c]u8, @ptrCast(@alignCast(&msg_1[@as(usize, @intCast(0))]))), strlen(@as([*c]u8, @ptrCast(@alignCast(&msg_1[@as(usize, @intCast(0))])))));
    }
    if (only_destroy) {
        return;
    }
    if ((buf != null) and !is_autocmd_blocked()) {
        var save_v_event: save_v_event_T = undefined;
        _ = &save_v_event;
        var dict: [*c]dict_T = get_v_event(&save_v_event);
        _ = &dict;
        _ = tv_dict_add_nr(dict, "status", @sizeOf([7]u8) -% @as(c_ulong, @bitCast(@as(c_long, @as(c_int, 1)))), @as(varnumber_T, @bitCast(@as(c_long, status))));
        tv_dict_set_keys_readonly(dict);
        _ = apply_autocmds(@as(c_uint, @bitCast(EVENT_TERMCLOSE)), null, null, @as(c_int, 0) != 0, buf);
        restore_v_event(dict, &save_v_event);
    }
}
pub export fn terminal_check_size(arg_term: [*c]Terminal) void {
    var term = arg_term;
    _ = &term;
    if (term.*.closed) {
        return;
    }
    var curwidth: c_int = undefined;
    _ = &curwidth;
    var curheight: c_int = undefined;
    _ = &curheight;
    vterm_get_size(term.*.vt, &curheight, &curwidth);
    var width: u16 = 0;
    _ = &width;
    var height: u16 = 0;
    _ = &height;
    {
        var tp: [*c]tabpage_T = first_tabpage;
        _ = &tp;
        while (tp != @as([*c]tabpage_T, @ptrCast(@alignCast(@as(?*anyopaque, @ptrFromInt(@as(c_int, 0))))))) : (tp = tp.*.tp_next) {
            var wp: [*c]win_T = if (tp == curtab) firstwin else tp.*.tp_firstwin;
            _ = &wp;
            while (wp != @as([*c]win_T, @ptrCast(@alignCast(@as(?*anyopaque, @ptrFromInt(@as(c_int, 0))))))) : (wp = wp.*.w_next) {
                if (is_aucmd_win(wp)) {
                    continue;
                }
                if ((wp.*.w_buffer != null) and (wp.*.w_buffer.*.terminal == term)) {
                    const win_width: u16 = @as(u16, @bitCast(@as(c_short, @truncate(if (@as(c_int, 0) > (wp.*.w_view_width - win_col_off(wp))) @as(c_int, 0) else wp.*.w_view_width - win_col_off(wp)))));
                    _ = &win_width;
                    width = @as(u16, @bitCast(@as(c_short, @truncate(if (@as(c_int, @bitCast(@as(c_uint, width))) > @as(c_int, @bitCast(@as(c_uint, win_width)))) @as(c_int, @bitCast(@as(c_uint, width))) else @as(c_int, @bitCast(@as(c_uint, win_width)))))));
                    height = @as(u16, @bitCast(@as(c_short, @truncate(if (@as(c_int, @bitCast(@as(c_uint, height))) > wp.*.w_view_height) @as(c_int, @bitCast(@as(c_uint, height))) else wp.*.w_view_height))));
                }
            }
        }
    }
    if ((((curheight == @as(c_int, @bitCast(@as(c_uint, height)))) and (curwidth == @as(c_int, @bitCast(@as(c_uint, width))))) or (@as(c_int, @bitCast(@as(c_uint, height))) == @as(c_int, 0))) or (@as(c_int, @bitCast(@as(c_uint, width))) == @as(c_int, 0))) {
        return;
    }
    vterm_set_size(term.*.vt, @as(c_int, @bitCast(@as(c_uint, height))), @as(c_int, @bitCast(@as(c_uint, width))));
    vterm_screen_flush_damage(term.*.vts);
    term.*.pending.resize = @as(c_int, 1) != 0;
    invalidate_terminal(term, -@as(c_int, 1), -@as(c_int, 1));
}
pub export fn terminal_enter() bool {
    var buf: [*c]buf_T = curbuf;
    _ = &buf;
    _ = blk: {
        _ = @sizeOf(c_int);
        break :blk blk_1: {
            break :blk_1 if (buf.*.terminal != null) {} else {
                c.__assert_fail("buf->terminal", "src/nvim/terminal.c", @as(c_uint, @bitCast(@as(c_int, 765))), "_Bool terminal_enter(void)");
            };
        };
    };
    var s: [1]TerminalState = [1]TerminalState{
        TerminalState{
            .state = VimState{
                .check = null,
                .execute = @import("std").mem.zeroes(state_execute_callback),
            },
            .term = null,
            .save_rd = 0,
            .close = false,
            .got_bsl = false,
            .got_bsl_o = false,
            .cursor_visible = false,
            .save_curwin_handle = @import("std").mem.zeroes(handle_T),
            .save_w_p_cul = false,
            .save_w_p_culopt = null,
            .save_w_p_culopt_flags = @import("std").mem.zeroes(u8),
            .save_w_p_cuc = 0,
            .save_w_p_so = @import("std").mem.zeroes(OptInt),
            .save_w_p_siso = @import("std").mem.zeroes(OptInt),
        },
    };
    _ = &s;
    @as([*c]TerminalState, @ptrCast(@alignCast(&s[@as(usize, @intCast(0))]))).*.term = buf.*.terminal;
    @as([*c]TerminalState, @ptrCast(@alignCast(&s[@as(usize, @intCast(0))]))).*.cursor_visible = @as(c_int, 1) != 0;
    stop_insert_mode = @as(c_int, 0) != 0;
    terminal_check_size(@as([*c]TerminalState, @ptrCast(@alignCast(&s[@as(usize, @intCast(0))]))).*.term);
    var save_state: c_int = State;
    _ = &save_state;
    @as([*c]TerminalState, @ptrCast(@alignCast(&s[@as(usize, @intCast(0))]))).*.save_rd = RedrawingDisabled;
    State = MODE_TERMINAL;
    mapped_ctrl_c |= MODE_TERMINAL;
    RedrawingDisabled = 0;
    set_terminal_winopts(@as([*c]TerminalState, @ptrCast(@alignCast(&s[@as(usize, @intCast(0))]))));
    @as([*c]TerminalState, @ptrCast(@alignCast(&s[@as(usize, @intCast(0))]))).*.term.*.pending.cursor = @as(c_int, 1) != 0;
    adjust_topline_cursor(@as([*c]TerminalState, @ptrCast(@alignCast(&s[@as(usize, @intCast(0))]))).*.term, buf, @as(c_int, 0));
    _ = showmode();
    ui_cursor_shape();
    terminal_focus(@as([*c]TerminalState, @ptrCast(@alignCast(&s[@as(usize, @intCast(0))]))).*.term, @as(c_int, 1) != 0);
    curbuf.*.b_last_changedtick_i = buf_get_changedtick(curbuf);
    _ = apply_autocmds(@as(c_uint, @bitCast(EVENT_TERMENTER)), null, null, @as(c_int, 0) != 0, curbuf);
    may_trigger_modechanged();
    @as([*c]TerminalState, @ptrCast(@alignCast(&s[@as(usize, @intCast(0))]))).*.state.execute = &terminal_execute;
    @as([*c]TerminalState, @ptrCast(@alignCast(&s[@as(usize, @intCast(0))]))).*.state.check = &terminal_check;
    state_enter(&@as([*c]TerminalState, @ptrCast(@alignCast(&s[@as(usize, @intCast(0))]))).*.state);
    if (!@as([*c]TerminalState, @ptrCast(@alignCast(&s[@as(usize, @intCast(0))]))).*.got_bsl_o) {
        restart_edit = 0;
    }
    State = save_state;
    RedrawingDisabled = @as([*c]TerminalState, @ptrCast(@alignCast(&s[@as(usize, @intCast(0))]))).*.save_rd;
    if (!@as([*c]TerminalState, @ptrCast(@alignCast(&s[@as(usize, @intCast(0))]))).*.cursor_visible) {
        ui_busy_stop();
    }
    _ = parse_shape_opt(@as(c_int, 2));
    unset_terminal_winopts(@as([*c]TerminalState, @ptrCast(@alignCast(&s[@as(usize, @intCast(0))]))));
    terminal_focus(@as([*c]TerminalState, @ptrCast(@alignCast(&s[@as(usize, @intCast(0))]))).*.term, @as(c_int, 0) != 0);
    curbuf.*.b_last_changedtick = buf_get_changedtick(curbuf);
    if ((curbuf.*.terminal == @as([*c]TerminalState, @ptrCast(@alignCast(&s[@as(usize, @intCast(0))]))).*.term) and !@as([*c]TerminalState, @ptrCast(@alignCast(&s[@as(usize, @intCast(0))]))).*.close) {
        terminal_check_cursor();
    }
    if (restart_edit != 0) {
        _ = showmode();
    } else {
        unshowmode(@as(c_int, 1) != 0);
    }
    ui_cursor_shape();
    if (@as([*c]TerminalState, @ptrCast(@alignCast(&s[@as(usize, @intCast(0))]))).*.close) {
        @as([*c]TerminalState, @ptrCast(@alignCast(&s[@as(usize, @intCast(0))]))).*.term.*.refcount +%= 1;
    }
    _ = apply_autocmds(@as(c_uint, @bitCast(EVENT_TERMLEAVE)), null, null, @as(c_int, 0) != 0, curbuf);
    if (@as([*c]TerminalState, @ptrCast(@alignCast(&s[@as(usize, @intCast(0))]))).*.close) {
        @as([*c]TerminalState, @ptrCast(@alignCast(&s[@as(usize, @intCast(0))]))).*.term.*.refcount -%= 1;
        const buf_handle: handle_T = @as([*c]TerminalState, @ptrCast(@alignCast(&s[@as(usize, @intCast(0))]))).*.term.*.buf_handle;
        _ = &buf_handle;
        @as([*c]TerminalState, @ptrCast(@alignCast(&s[@as(usize, @intCast(0))]))).*.term.*.destroy = @as(c_int, 1) != 0;
        @as([*c]TerminalState, @ptrCast(@alignCast(&s[@as(usize, @intCast(0))]))).*.term.*.opts.close_cb.?(@as([*c]TerminalState, @ptrCast(@alignCast(&s[@as(usize, @intCast(0))]))).*.term.*.opts.data);
        if (buf_handle != @as(c_int, 0)) {
            _ = do_buffer(DOBUF_WIPE, DOBUF_FIRST, FORWARD, buf_handle, @as(c_int, 1));
        }
    }
    return @as([*c]TerminalState, @ptrCast(@alignCast(&s[@as(usize, @intCast(0))]))).*.got_bsl_o;
}
pub export fn terminal_destroy(arg_termpp: [*c][*c]Terminal) void {
    var termpp = arg_termpp;
    _ = &termpp;
    var term: [*c]Terminal = termpp.*;
    _ = &term;
    var buf: [*c]buf_T = @as([*c]buf_T, @ptrCast(@alignCast(map_get_intptr_t(&buffer_handles, term.*.buf_handle))));
    _ = &buf;
    if (buf != null) {
        term.*.buf_handle = 0;
        buf.*.terminal = null;
    }
    if (!(term.*.refcount != 0)) {
        if (set_has_ptr_t(&invalidated_terminals, @as(ptr_t, @ptrCast(term)))) {
            block_autocmds();
            refresh_terminal(term);
            unblock_autocmds();
            _ = set_del_ptr_t(&invalidated_terminals, @as(ptr_t, @ptrCast(term)));
        }
        {
            var i: usize = 0;
            _ = &i;
            while (i < term.*.sb_current) : (i +%= 1) {
                xfree(@as(?*anyopaque, @ptrCast(term.*.sb_buffer[i])));
            }
        }
        xfree(@as(?*anyopaque, @ptrCast(term.*.sb_buffer)));
        xfree(@as(?*anyopaque, @ptrCast(term.*.title)));
        xfree(@as(?*anyopaque, @ptrCast(term.*.selection_buffer)));
        while (true) {
            xfree(@as(?*anyopaque, @ptrCast(term.*.selection.items)));
            _ = blk: {
                term.*.selection.size = blk_1: {
                    const tmp = @as(usize, @bitCast(@as(c_long, @as(c_int, 0))));
                    term.*.selection.capacity = tmp;
                    break :blk_1 tmp;
                };
                break :blk blk_1: {
                    const tmp = null;
                    term.*.selection.items = tmp;
                    break :blk_1 tmp;
                };
            };
            if (!false) break;
        }
        while (true) {
            xfree(@as(?*anyopaque, @ptrCast(term.*.termrequest_buffer.items)));
            _ = blk: {
                term.*.termrequest_buffer.size = blk_1: {
                    const tmp = @as(usize, @bitCast(@as(c_long, @as(c_int, 0))));
                    term.*.termrequest_buffer.capacity = tmp;
                    break :blk_1 tmp;
                };
                break :blk blk_1: {
                    const tmp = null;
                    term.*.termrequest_buffer.items = tmp;
                    break :blk_1 tmp;
                };
            };
            if (!false) break;
        }
        vterm_free(term.*.vt);
        multiqueue_free(term.*.pending.events);
        xfree(@as(?*anyopaque, @ptrCast(term)));
        termpp.* = null;
    }
}
pub export fn terminal_paste(arg_count: c_int, arg_y_array: [*c]String, arg_y_size: usize) void {
    var count = arg_count;
    _ = &count;
    var y_array = arg_y_array;
    _ = &y_array;
    var y_size = arg_y_size;
    _ = &y_size;
    if (y_size == @as(usize, @bitCast(@as(c_long, @as(c_int, 0))))) {
        return;
    }
    vterm_keyboard_start_paste(curbuf.*.terminal.*.vt);
    var buff_len: usize = y_array[@as(c_uint, @intCast(@as(c_int, 0)))].size;
    _ = &buff_len;
    var buff: [*c]u8 = @as([*c]u8, @ptrCast(@alignCast(xmalloc(buff_len))));
    _ = &buff;
    {
        var i: c_int = 0;
        _ = &i;
        while (i < count) : (i += 1) {
            {
                var j: usize = 0;
                _ = &j;
                while (j < y_size) : (j +%= 1) {
                    if (j != 0) {
                        terminal_send(curbuf.*.terminal, "\n", @as(usize, @bitCast(@as(c_long, @as(c_int, 1)))));
                    }
                    var len: usize = y_array[j].size;
                    _ = &len;
                    if (len > buff_len) {
                        buff = @as([*c]u8, @ptrCast(@alignCast(xrealloc(@as(?*anyopaque, @ptrCast(buff)), len))));
                        buff_len = len;
                    }
                    var dst: [*c]u8 = buff;
                    _ = &dst;
                    var src: [*c]u8 = y_array[j].data;
                    _ = &src;
                    while (@as(c_int, @bitCast(@as(c_uint, src.*))) != @as(c_int, '\x00')) {
                        len = @as(usize, @bitCast(@as(c_long, utf_ptr2len(src))));
                        var ch: c_int = utf_ptr2char(src);
                        _ = &ch;
                        if (!is_filter_char(ch)) {
                            _ = memcpy(@as(?*anyopaque, @ptrCast(dst)), @as(?*const anyopaque, @ptrCast(src)), len);
                            dst += len;
                        }
                        src += len;
                    }
                    terminal_send(curbuf.*.terminal, buff, @as(usize, @bitCast(@divExact(@as(c_long, @bitCast(@intFromPtr(dst) -% @intFromPtr(buff))), @sizeOf(u8)))));
                }
            }
        }
    }
    xfree(@as(?*anyopaque, @ptrCast(buff)));
    vterm_keyboard_end_paste(curbuf.*.terminal.*.vt);
}
pub export fn terminal_receive(arg_term: [*c]Terminal, arg_data: [*c]const u8, arg_len: usize) void {
    var term = arg_term;
    _ = &term;
    var data = arg_data;
    _ = &data;
    var len = arg_len;
    _ = &len;
    if (!(data != null)) {
        return;
    }
    if (term.*.opts.force_crlf) {
        var crlf_data: StringBuilder = StringBuilder{
            .size = @as(usize, @bitCast(@as(c_long, @as(c_int, 0)))),
            .capacity = @as(usize, @bitCast(@as(c_long, @as(c_int, 0)))),
            .items = null,
        };
        _ = &crlf_data;
        {
            var i: usize = 0;
            _ = &i;
            while (i < len) : (i +%= 1) {
                if ((@as(c_int, @bitCast(@as(c_uint, data[i]))) == @as(c_int, '\n')) and ((i == @as(usize, @bitCast(@as(c_long, @as(c_int, 0))))) or ((i > @as(usize, @bitCast(@as(c_long, @as(c_int, 0))))) and (@as(c_int, @bitCast(@as(c_uint, data[i -% @as(usize, @bitCast(@as(c_long, @as(c_int, 1))))]))) != @as(c_int, '\r'))))) {
                    _ = blk: {
                        const tmp = @as(u8, @bitCast(@as(i8, @truncate(@as(c_int, '\r')))));
                        (blk_1: {
                            _ = if (crlf_data.size == crlf_data.capacity) blk_2: {
                                _ = blk_3: {
                                    crlf_data.capacity = if (crlf_data.capacity != 0) crlf_data.capacity << @intCast(1) else @as(usize, @bitCast(@as(c_long, @as(c_int, 8))));
                                    break :blk_3 blk_4: {
                                        const tmp_5 = @as([*c]u8, @ptrCast(@alignCast(xrealloc(@as(?*anyopaque, @ptrCast(crlf_data.items)), @sizeOf(u8) *% crlf_data.capacity))));
                                        crlf_data.items = tmp_5;
                                        break :blk_4 tmp_5;
                                    };
                                };
                                break :blk_2 @as(c_int, 0);
                            } else @as(c_int, 0);
                            break :blk_1 crlf_data.items + (blk_2: {
                                const ref = &crlf_data.size;
                                const tmp_3 = ref.*;
                                ref.* +%= 1;
                                break :blk_2 tmp_3;
                            });
                        }).* = tmp;
                        break :blk tmp;
                    };
                }
                _ = blk: {
                    const tmp = data[i];
                    (blk_1: {
                        _ = if (crlf_data.size == crlf_data.capacity) blk_2: {
                            _ = blk_3: {
                                crlf_data.capacity = if (crlf_data.capacity != 0) crlf_data.capacity << @intCast(1) else @as(usize, @bitCast(@as(c_long, @as(c_int, 8))));
                                break :blk_3 blk_4: {
                                    const tmp_5 = @as([*c]u8, @ptrCast(@alignCast(xrealloc(@as(?*anyopaque, @ptrCast(crlf_data.items)), @sizeOf(u8) *% crlf_data.capacity))));
                                    crlf_data.items = tmp_5;
                                    break :blk_4 tmp_5;
                                };
                            };
                            break :blk_2 @as(c_int, 0);
                        } else @as(c_int, 0);
                        break :blk_1 crlf_data.items + (blk_2: {
                            const ref = &crlf_data.size;
                            const tmp_3 = ref.*;
                            ref.* +%= 1;
                            break :blk_2 tmp_3;
                        });
                    }).* = tmp;
                    break :blk tmp;
                };
            }
        }
        _ = vterm_input_write(term.*.vt, crlf_data.items, crlf_data.size);
        while (true) {
            xfree(@as(?*anyopaque, @ptrCast(crlf_data.items)));
            _ = blk: {
                crlf_data.size = blk_1: {
                    const tmp = @as(usize, @bitCast(@as(c_long, @as(c_int, 0))));
                    crlf_data.capacity = tmp;
                    break :blk_1 tmp;
                };
                break :blk blk_1: {
                    const tmp = null;
                    crlf_data.items = tmp;
                    break :blk_1 tmp;
                };
            };
            if (!false) break;
        }
    } else {
        _ = vterm_input_write(term.*.vt, data, len);
    }
    vterm_screen_flush_damage(term.*.vts);
}
pub export fn terminal_get_line_attributes(arg_term: [*c]Terminal, arg_wp: [*c]win_T, arg_linenr: c_int, arg_term_attrs: [*c]c_int) void {
    var term = arg_term;
    _ = &term;
    var wp = arg_wp;
    _ = &wp;
    var linenr = arg_linenr;
    _ = &linenr;
    var term_attrs = arg_term_attrs;
    _ = &term_attrs;
    var height: c_int = undefined;
    _ = &height;
    var width: c_int = undefined;
    _ = &width;
    vterm_get_size(term.*.vt, &height, &width);
    var state: ?*VTermState = vterm_obtain_state(term.*.vt);
    _ = &state;
    _ = blk: {
        _ = @sizeOf(c_int);
        break :blk blk_1: {
            break :blk_1 if (linenr != 0) {} else {
                c.__assert_fail("linenr", "src/nvim/terminal.c", @as(c_uint, @bitCast(@as(c_int, 1228))), "void terminal_get_line_attributes(Terminal *, win_T *, int, int *)");
            };
        };
    };
    var row: c_int = linenr_to_row(term, linenr);
    _ = &row;
    if (row >= height) {
        return;
    }
    width = if (TERM_ATTRS_MAX < width) TERM_ATTRS_MAX else width;
    {
        var col: c_int = 0;
        _ = &col;
        while (col < width) : (col += 1) {
            var cell: VTermScreenCell = undefined;
            _ = &cell;
            var color_valid: bool = fetch_cell(term, row, col, &cell);
            _ = &color_valid;
            var fg_default: bool = !color_valid or !!((@as(c_int, @bitCast(@as(c_uint, (&cell.fg).*.type))) & VTERM_COLOR_DEFAULT_FG) != 0);
            _ = &fg_default;
            var bg_default: bool = !color_valid or !!((@as(c_int, @bitCast(@as(c_uint, (&cell.bg).*.type))) & VTERM_COLOR_DEFAULT_BG) != 0);
            _ = &bg_default;
            var vt_fg: c_int = if (@as(c_int, @intFromBool(fg_default)) != 0) -@as(c_int, 1) else get_rgb(state, cell.fg);
            _ = &vt_fg;
            var vt_bg: c_int = if (@as(c_int, @intFromBool(bg_default)) != 0) -@as(c_int, 1) else get_rgb(state, cell.bg);
            _ = &vt_bg;
            var fg_indexed: bool = (@as(c_int, @bitCast(@as(c_uint, (&cell.fg).*.type))) & VTERM_COLOR_TYPE_MASK) == VTERM_COLOR_INDEXED;
            _ = &fg_indexed;
            var bg_indexed: bool = (@as(c_int, @bitCast(@as(c_uint, (&cell.bg).*.type))) & VTERM_COLOR_TYPE_MASK) == VTERM_COLOR_INDEXED;
            _ = &bg_indexed;
            var vt_fg_idx: i16 = @as(i16, @bitCast(@as(c_short, @truncate(if (!fg_default and (@as(c_int, @intFromBool(fg_indexed)) != 0)) @as(c_int, @bitCast(@as(c_uint, cell.fg.indexed.idx))) + @as(c_int, 1) else @as(c_int, 0)))));
            _ = &vt_fg_idx;
            var vt_bg_idx: i16 = @as(i16, @bitCast(@as(c_short, @truncate(if (!bg_default and (@as(c_int, @intFromBool(bg_indexed)) != 0)) @as(c_int, @bitCast(@as(c_uint, cell.bg.indexed.idx))) + @as(c_int, 1) else @as(c_int, 0)))));
            _ = &vt_bg_idx;
            var fg_set: bool = ((@as(c_int, @bitCast(@as(c_int, vt_fg_idx))) != 0) and (@as(c_int, @bitCast(@as(c_int, vt_fg_idx))) <= @as(c_int, 16))) and (@as(c_int, @intFromBool(term.*.color_set[@as(c_uint, @intCast(@as(c_int, @bitCast(@as(c_int, vt_fg_idx))) - @as(c_int, 1)))])) != 0);
            _ = &fg_set;
            var bg_set: bool = ((@as(c_int, @bitCast(@as(c_int, vt_bg_idx))) != 0) and (@as(c_int, @bitCast(@as(c_int, vt_bg_idx))) <= @as(c_int, 16))) and (@as(c_int, @intFromBool(term.*.color_set[@as(c_uint, @intCast(@as(c_int, @bitCast(@as(c_int, vt_bg_idx))) - @as(c_int, 1)))])) != 0);
            _ = &bg_set;
            var hl_attrs: c_int = ((((((if (cell.attrs.bold != 0) HL_BOLD else @as(c_int, 0)) | (if (cell.attrs.italic != 0) HL_ITALIC else @as(c_int, 0))) | (if (cell.attrs.reverse != 0) HL_INVERSE else @as(c_int, 0))) | get_underline_hl_flag(cell.attrs)) | (if (cell.attrs.strike != 0) HL_STRIKETHROUGH else @as(c_int, 0))) | (if ((@intFromBool(fg_indexed) != 0) and !fg_set) HL_FG_INDEXED else 0)) | (if ((@intFromBool(bg_indexed) != 0) and !bg_set) HL_BG_INDEXED else @as(c_int, 0));
            _ = &hl_attrs;
            var attr_id: c_int = 0;
            _ = &attr_id;
            if (((hl_attrs != 0) or !fg_default) or !bg_default) {
                var attrs = HlAttrs{
                    .rgb_ae_attr = @as(i16, @bitCast(@as(c_short, @truncate(hl_attrs)))),
                    .cterm_ae_attr = @as(i16, @bitCast(@as(c_short, @truncate(hl_attrs)))),
                    .rgb_fg_color = vt_fg,
                    .rgb_bg_color = vt_bg,
                    .rgb_sp_color = -@as(c_int, 1),
                    .cterm_fg_color = vt_fg_idx,
                    .cterm_bg_color = vt_bg_idx,
                    .hl_blend = -@as(c_int, 1),
                    .url = -@as(c_int, 1),
                };
                attr_id = hl_get_term_attr(&attrs);
            }
            if (cell.uri > @as(c_int, 0)) {
                attr_id = hl_combine_attr(attr_id, cell.uri);
            }
            (blk: {
                const tmp = col;
                if (tmp >= 0) break :blk term_attrs + @as(usize, @intCast(tmp)) else break :blk term_attrs - ~@as(usize, @bitCast(@as(isize, @intCast(tmp)) +% -1));
            }).* = attr_id;
        }
    }
}
pub export fn terminal_buf(arg_term: [*c]const Terminal) Buffer {
    var term = arg_term;
    _ = &term;
    return term.*.buf_handle;
}
pub export fn terminal_running(arg_term: [*c]const Terminal) bool {
    var term = arg_term;
    _ = &term;
    return !term.*.closed;
}
pub export fn terminal_notify_theme(arg_term: [*c]Terminal, arg_dark: bool) void {
    var term = arg_term;
    _ = &term;
    var dark = arg_dark;
    _ = &dark;
    if (!term.*.theme_updates) {
        return;
    }
    var buf: [10]u8 = undefined;
    _ = &buf;
    var ret: isize = @as(isize, @bitCast(@as(c_long, snprintf(@as([*c]u8, @ptrCast(@alignCast(&buf[@as(usize, @intCast(0))]))), @sizeOf([10]u8), "\x1b[997;%cn", if (@as(c_int, @intFromBool(dark)) != 0) @as(c_int, '1') else @as(c_int, '2')))));
    _ = &ret;
    _ = blk: {
        _ = @sizeOf(c_int);
        break :blk blk_1: {
            break :blk_1 if (ret > @as(isize, @bitCast(@as(c_long, @as(c_int, 0))))) {} else {
                c.__assert_fail("ret > 0", "src/nvim/terminal.c", @as(c_uint, @bitCast(@as(c_int, 1307))), "void terminal_notify_theme(Terminal *, _Bool)");
            };
        };
    };
    _ = blk: {
        _ = @sizeOf(c_int);
        break :blk blk_1: {
            break :blk_1 if (@as(usize, @bitCast(ret)) <= @sizeOf([10]u8)) {} else {
                c.__assert_fail("(size_t)ret <= sizeof(buf)", "src/nvim/terminal.c", @as(c_uint, @bitCast(@as(c_int, 1308))), "void terminal_notify_theme(Terminal *, _Bool)");
            };
        };
    };
    terminal_send(term, @as([*c]u8, @ptrCast(@alignCast(&buf[@as(usize, @intCast(0))]))), @as(usize, @bitCast(ret)));
}
pub export fn on_scrollback_option_changed(arg_term: [*c]Terminal) void {
    var term = arg_term;
    _ = &term;
    if (term.*.sb_buffer != @as([*c][*c]ScrollbackLine, @ptrCast(@alignCast(@as(?*anyopaque, @ptrFromInt(@as(c_int, 0))))))) {
        refresh_terminal(term);
    }
}
pub const VTermPos = extern struct {
    row: c_int = @import("std").mem.zeroes(c_int),
    col: c_int = @import("std").mem.zeroes(c_int),
};
pub const VTermRect = extern struct {
    start_row: c_int = @import("std").mem.zeroes(c_int),
    end_row: c_int = @import("std").mem.zeroes(c_int),
    start_col: c_int = @import("std").mem.zeroes(c_int),
    end_col: c_int = @import("std").mem.zeroes(c_int),
};
const struct_unnamed_193 = extern struct {
    type: u8 = @import("std").mem.zeroes(u8),
    red: u8 = @import("std").mem.zeroes(u8),
    green: u8 = @import("std").mem.zeroes(u8),
    blue: u8 = @import("std").mem.zeroes(u8),
};
const struct_unnamed_194 = extern struct {
    type: u8 = @import("std").mem.zeroes(u8),
    idx: u8 = @import("std").mem.zeroes(u8),
};
pub const VTermColor = extern union {
    type: u8,
    rgb: struct_unnamed_193,
    indexed: struct_unnamed_194,
};
// src/nvim/vterm/vterm_defs.h:56:12: warning: struct demoted to opaque type - has bitfield
// typedef struct {
//   unsigned bold      : 1;
//   unsigned underline : 2;
//   unsigned italic    : 1;
//   unsigned blink     : 1;
//   unsigned reverse   : 1;
//   unsigned conceal   : 1;
//   unsigned strike    : 1;
//   unsigned font      : 4;  // 0 to 9
//   unsigned dwl       : 1;  // On a DECDWL or DECDHL line
//   unsigned dhl       : 2;  // On a DECDHL line (1=top 2=bottom)
//   unsigned small     : 1;
//   unsigned baseline  : 2;
// } VTermScreenCellAttrs;
pub const VTermScreenCellAttrs = packed struct {
    bold: u1,
    underline: u2,
    italic: u1,
    blink: u1,
    reverse: u1,
    conceal: u1,
    strike: u1,
    font: u4, // 0 to 9
    dwl: u1, // On a DECDWL or DECDHL line
    dhl: u2, // On a DECDHL line (1=top 2=bottom)
    small: u1,
    baseline: u2,
    _padding: u14,
};
pub const VTermScreenCell = extern struct {
    schar: schar_T = @import("std").mem.zeroes(schar_T),
    width: u8 = @import("std").mem.zeroes(u8),
    attrs: VTermScreenCellAttrs = @import("std").mem.zeroes(VTermScreenCellAttrs),
    fg: VTermColor = @import("std").mem.zeroes(VTermColor),
    bg: VTermColor = @import("std").mem.zeroes(VTermColor),
    uri: c_int = @import("std").mem.zeroes(c_int),
};
pub const VTERM_PROP_CURSORVISIBLE: c_int = 1;
pub const VTERM_PROP_CURSORBLINK: c_int = 2;
pub const VTERM_PROP_ALTSCREEN: c_int = 3;
pub const VTERM_PROP_TITLE: c_int = 4;
pub const VTERM_PROP_ICONNAME: c_int = 5;
pub const VTERM_PROP_REVERSE: c_int = 6;
pub const VTERM_PROP_CURSORSHAPE: c_int = 7;
pub const VTERM_PROP_MOUSE: c_int = 8;
pub const VTERM_PROP_FOCUSREPORT: c_int = 9;
pub const VTERM_PROP_THEMEUPDATES: c_int = 10;
pub const VTERM_N_PROPS: c_int = 11;
pub const VTermProp = c_uint;
pub const VTERM_TERMINATOR_BEL: c_int = 0;
pub const VTERM_TERMINATOR_ST: c_int = 1;
pub const VTermTerminator = c_uint;
// src/nvim/vterm/vterm_defs.h:101:10: warning: struct demoted to opaque type - has bitfield
// typedef struct {
//   const char *str;
//   size_t len : 30;
//   bool initial : 1;
//   bool final : 1;
//   VTermTerminator terminator;
// } VTermStringFragment;
pub const VTermStringFragment = packed struct {
    str: [*c]u8,
    len: u30,
    initial: bool,
    final: bool,
    terminator: VTermTerminator,
};
pub const VTermValue = extern union {
    boolean: c_int,
    number: c_int,
    string: VTermStringFragment,
    color: VTermColor,
};
pub const VTermScreenCallbacks = extern struct {
    damage: ?*const fn (VTermRect, ?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn (VTermRect, ?*anyopaque) callconv(.c) c_int),
    moverect: ?*const fn (VTermRect, VTermRect, ?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn (VTermRect, VTermRect, ?*anyopaque) callconv(.c) c_int),
    movecursor: ?*const fn (VTermPos, VTermPos, c_int, ?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn (VTermPos, VTermPos, c_int, ?*anyopaque) callconv(.c) c_int),
    settermprop: ?*const fn (VTermProp, ?*VTermValue, ?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn (VTermProp, ?*VTermValue, ?*anyopaque) callconv(.c) c_int),
    bell: ?*const fn (?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn (?*anyopaque) callconv(.c) c_int),
    resize: ?*const fn (c_int, c_int, ?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn (c_int, c_int, ?*anyopaque) callconv(.c) c_int),
    theme: ?*const fn ([*c]bool, ?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn ([*c]bool, ?*anyopaque) callconv(.c) c_int),
    sb_pushline: ?*const fn (c_int, ?*const VTermScreenCell, ?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn (c_int, ?*const VTermScreenCell, ?*anyopaque) callconv(.c) c_int),
    sb_popline: ?*const fn (c_int, ?*VTermScreenCell, ?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn (c_int, ?*VTermScreenCell, ?*anyopaque) callconv(.c) c_int),
    sb_clear: ?*const fn (?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn (?*anyopaque) callconv(.c) c_int),
};
pub const VTermStateFallbacks = extern struct {
    control: ?*const fn (u8, ?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn (u8, ?*anyopaque) callconv(.c) c_int),
    csi: ?*const fn ([*c]const u8, [*c]const c_long, c_int, [*c]const u8, u8, ?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn ([*c]const u8, [*c]const c_long, c_int, [*c]const u8, u8, ?*anyopaque) callconv(.c) c_int),
    osc: ?*const fn (c_int, VTermStringFragment, ?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn (c_int, VTermStringFragment, ?*anyopaque) callconv(.c) c_int),
    dcs: ?*const fn ([*c]const u8, usize, VTermStringFragment, ?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn ([*c]const u8, usize, VTermStringFragment, ?*anyopaque) callconv(.c) c_int),
    apc: ?*const fn (VTermStringFragment, ?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn (VTermStringFragment, ?*anyopaque) callconv(.c) c_int),
    pm: ?*const fn (VTermStringFragment, ?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn (VTermStringFragment, ?*anyopaque) callconv(.c) c_int),
    sos: ?*const fn (VTermStringFragment, ?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn (VTermStringFragment, ?*anyopaque) callconv(.c) c_int),
};
pub const VTERM_DAMAGE_CELL: c_int = 0;
pub const VTERM_DAMAGE_ROW: c_int = 1;
pub const VTERM_DAMAGE_SCREEN: c_int = 2;
pub const VTERM_DAMAGE_SCROLL: c_int = 3;
pub const VTERM_N_DAMAGES: c_int = 4;
pub const VTermDamageSize = c_uint;
pub const VTERM_ATTR_BOLD_MASK: c_int = 1;
pub const VTERM_ATTR_UNDERLINE_MASK: c_int = 2;
pub const VTERM_ATTR_ITALIC_MASK: c_int = 4;
pub const VTERM_ATTR_BLINK_MASK: c_int = 8;
pub const VTERM_ATTR_REVERSE_MASK: c_int = 16;
pub const VTERM_ATTR_STRIKE_MASK: c_int = 32;
pub const VTERM_ATTR_FONT_MASK: c_int = 64;
pub const VTERM_ATTR_FOREGROUND_MASK: c_int = 128;
pub const VTERM_ATTR_BACKGROUND_MASK: c_int = 256;
pub const VTERM_ATTR_CONCEAL_MASK: c_int = 512;
pub const VTERM_ATTR_SMALL_MASK: c_int = 1024;
pub const VTERM_ATTR_BASELINE_MASK: c_int = 2048;
pub const VTERM_ATTR_URI_MASK: c_int = 4096;
pub const VTERM_ALL_ATTRS_MASK: c_int = 8191;
pub const VTermAttrMask = c_uint;
pub const VTERM_VALUETYPE_BOOL: c_int = 1;
pub const VTERM_VALUETYPE_INT: c_int = 2;
pub const VTERM_VALUETYPE_STRING: c_int = 3;
pub const VTERM_VALUETYPE_COLOR: c_int = 4;
pub const VTERM_N_VALUETYPES: c_int = 5;
pub const VTermValueType = c_uint;
pub const VTERM_ATTR_BOLD: c_int = 1;
pub const VTERM_ATTR_UNDERLINE: c_int = 2;
pub const VTERM_ATTR_ITALIC: c_int = 3;
pub const VTERM_ATTR_BLINK: c_int = 4;
pub const VTERM_ATTR_REVERSE: c_int = 5;
pub const VTERM_ATTR_CONCEAL: c_int = 6;
pub const VTERM_ATTR_STRIKE: c_int = 7;
pub const VTERM_ATTR_FONT: c_int = 8;
pub const VTERM_ATTR_FOREGROUND: c_int = 9;
pub const VTERM_ATTR_BACKGROUND: c_int = 10;
pub const VTERM_ATTR_SMALL: c_int = 11;
pub const VTERM_ATTR_BASELINE: c_int = 12;
pub const VTERM_ATTR_URI: c_int = 13;
pub const VTERM_N_ATTRS: c_int = 14;
pub const VTermAttr = c_uint;
pub const VTERM_PROP_CURSORSHAPE_BLOCK: c_int = 1;
pub const VTERM_PROP_CURSORSHAPE_UNDERLINE: c_int = 2;
pub const VTERM_PROP_CURSORSHAPE_BAR_LEFT: c_int = 3;
pub const VTERM_N_PROP_CURSORSHAPES: c_int = 4;
const enum_unnamed_195 = c_uint;
pub const VTERM_PROP_MOUSE_NONE: c_int = 0;
pub const VTERM_PROP_MOUSE_CLICK: c_int = 1;
pub const VTERM_PROP_MOUSE_DRAG: c_int = 2;
pub const VTERM_PROP_MOUSE_MOVE: c_int = 3;
pub const VTERM_N_PROP_MOUSES: c_int = 4;
const enum_unnamed_196 = c_uint;
pub const VTERM_SELECTION_CLIPBOARD: c_int = 1;
pub const VTERM_SELECTION_PRIMARY: c_int = 2;
pub const VTERM_SELECTION_SECONDARY: c_int = 4;
pub const VTERM_SELECTION_SELECT: c_int = 8;
pub const VTERM_SELECTION_CUT0: c_int = 16;
pub const VTermSelectionMask = c_uint;
// src/nvim/vterm/vterm_defs.h:222:12: warning: struct demoted to opaque type - has bitfield
pub const VTermGlyphInfo = opaque {};
// src/nvim/vterm/vterm_defs.h:228:12: warning: struct demoted to opaque type - has bitfield
pub const VTermLineInfo = opaque {};
pub const VTermStateFields = extern struct {
    pos: VTermPos = @import("std").mem.zeroes(VTermPos),
    lineinfos: [2]?*VTermLineInfo = @import("std").mem.zeroes([2]?*VTermLineInfo),
};
pub const VTermAllocatorFunctions = extern struct {
    malloc: ?*const fn (usize, ?*anyopaque) callconv(.c) ?*anyopaque = @import("std").mem.zeroes(?*const fn (usize, ?*anyopaque) callconv(.c) ?*anyopaque),
    free: ?*const fn (?*anyopaque, ?*anyopaque) callconv(.c) void = @import("std").mem.zeroes(?*const fn (?*anyopaque, ?*anyopaque) callconv(.c) void),
};
pub const VTermOutputCallback = fn ([*c]const u8, usize, ?*anyopaque) callconv(.c) void;
pub const struct_VTermBuilder = extern struct {
    ver: c_int = @import("std").mem.zeroes(c_int),
    rows: c_int = @import("std").mem.zeroes(c_int),
    cols: c_int = @import("std").mem.zeroes(c_int),
    allocator: [*c]const VTermAllocatorFunctions = @import("std").mem.zeroes([*c]const VTermAllocatorFunctions),
    allocdata: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    outbuffer_len: usize = @import("std").mem.zeroes(usize),
    tmpbuffer_len: usize = @import("std").mem.zeroes(usize),
};
pub const VTermStateCallbacks = extern struct {
    putglyph: ?*const fn (?*VTermGlyphInfo, VTermPos, ?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn (?*VTermGlyphInfo, VTermPos, ?*anyopaque) callconv(.c) c_int),
    movecursor: ?*const fn (VTermPos, VTermPos, c_int, ?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn (VTermPos, VTermPos, c_int, ?*anyopaque) callconv(.c) c_int),
    scrollrect: ?*const fn (VTermRect, c_int, c_int, ?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn (VTermRect, c_int, c_int, ?*anyopaque) callconv(.c) c_int),
    moverect: ?*const fn (VTermRect, VTermRect, ?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn (VTermRect, VTermRect, ?*anyopaque) callconv(.c) c_int),
    erase: ?*const fn (VTermRect, c_int, ?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn (VTermRect, c_int, ?*anyopaque) callconv(.c) c_int),
    initpen: ?*const fn (?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn (?*anyopaque) callconv(.c) c_int),
    setpenattr: ?*const fn (VTermAttr, ?*VTermValue, ?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn (VTermAttr, ?*VTermValue, ?*anyopaque) callconv(.c) c_int),
    settermprop: ?*const fn (VTermProp, ?*VTermValue, ?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn (VTermProp, ?*VTermValue, ?*anyopaque) callconv(.c) c_int),
    bell: ?*const fn (?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn (?*anyopaque) callconv(.c) c_int),
    resize: ?*const fn (c_int, c_int, [*c]VTermStateFields, ?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn (c_int, c_int, [*c]VTermStateFields, ?*anyopaque) callconv(.c) c_int),
    theme: ?*const fn ([*c]bool, ?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn ([*c]bool, ?*anyopaque) callconv(.c) c_int),
    setlineinfo: ?*const fn (c_int, ?*const VTermLineInfo, ?*const VTermLineInfo, ?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn (c_int, ?*const VTermLineInfo, ?*const VTermLineInfo, ?*anyopaque) callconv(.c) c_int),
    sb_clear: ?*const fn (?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn (?*anyopaque) callconv(.c) c_int),
};
pub const VTermSelectionCallbacks = extern struct {
    set: ?*const fn (VTermSelectionMask, VTermStringFragment, ?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn (VTermSelectionMask, VTermStringFragment, ?*anyopaque) callconv(.c) c_int),
    query: ?*const fn (VTermSelectionMask, ?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn (VTermSelectionMask, ?*anyopaque) callconv(.c) c_int),
};
pub const VTermParserCallbacks = extern struct {
    text: ?*const fn ([*c]const u8, usize, ?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn ([*c]const u8, usize, ?*anyopaque) callconv(.c) c_int),
    control: ?*const fn (u8, ?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn (u8, ?*anyopaque) callconv(.c) c_int),
    escape: ?*const fn ([*c]const u8, usize, ?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn ([*c]const u8, usize, ?*anyopaque) callconv(.c) c_int),
    csi: ?*const fn ([*c]const u8, [*c]const c_long, c_int, [*c]const u8, u8, ?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn ([*c]const u8, [*c]const c_long, c_int, [*c]const u8, u8, ?*anyopaque) callconv(.c) c_int),
    osc: ?*const fn (c_int, VTermStringFragment, ?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn (c_int, VTermStringFragment, ?*anyopaque) callconv(.c) c_int),
    dcs: ?*const fn ([*c]const u8, usize, VTermStringFragment, ?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn ([*c]const u8, usize, VTermStringFragment, ?*anyopaque) callconv(.c) c_int),
    apc: ?*const fn (VTermStringFragment, ?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn (VTermStringFragment, ?*anyopaque) callconv(.c) c_int),
    pm: ?*const fn (VTermStringFragment, ?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn (VTermStringFragment, ?*anyopaque) callconv(.c) c_int),
    sos: ?*const fn (VTermStringFragment, ?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn (VTermStringFragment, ?*anyopaque) callconv(.c) c_int),
    resize: ?*const fn (c_int, c_int, ?*anyopaque) callconv(.c) c_int = @import("std").mem.zeroes(?*const fn (c_int, c_int, ?*anyopaque) callconv(.c) c_int),
};
// src/nvim/vterm/vterm_defs.h:307:12: warning: struct demoted to opaque type - has bitfield
pub const ScreenPen = opaque {};
pub const ScreenCell = extern struct {
    schar: schar_T = @import("std").mem.zeroes(schar_T),
    pen: ScreenPen = @import("std").mem.zeroes(ScreenPen),
};
pub const VTERM_MOD_NONE: c_int = 0;
pub const VTERM_MOD_SHIFT: c_int = 1;
pub const VTERM_MOD_ALT: c_int = 2;
pub const VTERM_MOD_CTRL: c_int = 4;
pub const VTERM_ALL_MODS_MASK: c_int = 7;
pub const VTermModifier = c_uint;
pub const VTERM_KEY_NONE: c_int = 0;
pub const VTERM_KEY_ENTER: c_int = 1;
pub const VTERM_KEY_TAB: c_int = 2;
pub const VTERM_KEY_BACKSPACE: c_int = 3;
pub const VTERM_KEY_ESCAPE: c_int = 4;
pub const VTERM_KEY_UP: c_int = 5;
pub const VTERM_KEY_DOWN: c_int = 6;
pub const VTERM_KEY_LEFT: c_int = 7;
pub const VTERM_KEY_RIGHT: c_int = 8;
pub const VTERM_KEY_INS: c_int = 9;
pub const VTERM_KEY_DEL: c_int = 10;
pub const VTERM_KEY_HOME: c_int = 11;
pub const VTERM_KEY_END: c_int = 12;
pub const VTERM_KEY_PAGEUP: c_int = 13;
pub const VTERM_KEY_PAGEDOWN: c_int = 14;
pub const VTERM_KEY_FUNCTION_0: c_int = 256;
pub const VTERM_KEY_FUNCTION_MAX: c_int = 511;
pub const VTERM_KEY_KP_0: c_int = 512;
pub const VTERM_KEY_KP_1: c_int = 513;
pub const VTERM_KEY_KP_2: c_int = 514;
pub const VTERM_KEY_KP_3: c_int = 515;
pub const VTERM_KEY_KP_4: c_int = 516;
pub const VTERM_KEY_KP_5: c_int = 517;
pub const VTERM_KEY_KP_6: c_int = 518;
pub const VTERM_KEY_KP_7: c_int = 519;
pub const VTERM_KEY_KP_8: c_int = 520;
pub const VTERM_KEY_KP_9: c_int = 521;
pub const VTERM_KEY_KP_MULT: c_int = 522;
pub const VTERM_KEY_KP_PLUS: c_int = 523;
pub const VTERM_KEY_KP_COMMA: c_int = 524;
pub const VTERM_KEY_KP_MINUS: c_int = 525;
pub const VTERM_KEY_KP_PERIOD: c_int = 526;
pub const VTERM_KEY_KP_DIVIDE: c_int = 527;
pub const VTERM_KEY_KP_ENTER: c_int = 528;
pub const VTERM_KEY_KP_EQUAL: c_int = 529;
pub const VTERM_KEY_MAX: c_int = 530;
pub const VTERM_N_KEYS: c_int = 530;
pub const VTermKey = c_uint;
pub extern fn vterm_keyboard_unichar(vt: ?*VTerm, c: u32, mod: VTermModifier) void;
pub extern fn vterm_keyboard_key(vt: ?*VTerm, key: VTermKey, mod: VTermModifier) void;
pub extern fn vterm_keyboard_start_paste(vt: ?*VTerm) void;
pub extern fn vterm_keyboard_end_paste(vt: ?*VTerm) void;
pub extern fn vterm_mouse_move(vt: ?*VTerm, row: c_int, col: c_int, mod: VTermModifier) void;
pub extern fn vterm_mouse_button(vt: ?*VTerm, button: c_int, pressed: bool, mod: VTermModifier) void;
pub extern fn vterm_input_write(vt: ?*VTerm, bytes: [*c]const u8, len: usize) usize;
pub extern fn vterm_parser_set_callbacks(vt: ?*VTerm, callbacks: [*c]const VTermParserCallbacks, user: ?*anyopaque) void;
pub extern fn vterm_state_newpen(state: ?*VTermState) void;
pub extern fn vterm_state_resetpen(state: ?*VTermState) void;
pub extern fn vterm_state_savepen(state: ?*VTermState, save: c_int) void;
pub extern fn vterm_state_set_default_colors(state: ?*VTermState, default_fg: [*c]const VTermColor, default_bg: [*c]const VTermColor) void;
pub extern fn vterm_state_set_palette_color(state: ?*VTermState, index: c_int, col: [*c]const VTermColor) void;
pub extern fn vterm_state_convert_color_to_rgb(state: ?*const VTermState, col: [*c]VTermColor) void;
pub extern fn vterm_state_setpen(state: ?*VTermState, args: [*c]const c_long, argcount: c_int) void;
pub extern fn vterm_state_getpen(state: ?*VTermState, args: [*c]c_long, argcount: c_int) c_int;
pub extern fn vterm_state_set_penattr(state: ?*VTermState, attr: VTermAttr, @"type": VTermValueType, val: ?*VTermValue) c_int;
pub extern fn getcell(screen: ?*const VTermScreen, row: c_int, col: c_int) ?*ScreenCell;
pub extern fn vterm_screen_free(screen: ?*VTermScreen) void;
pub extern fn vterm_screen_reset(screen: ?*VTermScreen, hard: c_int) void;
pub extern fn vterm_screen_get_cell(screen: ?*const VTermScreen, pos: VTermPos, cell: ?*VTermScreenCell) c_int;
pub extern fn vterm_obtain_screen(vt: ?*VTerm) ?*VTermScreen;
pub extern fn vterm_screen_enable_reflow(screen: ?*VTermScreen, reflow: bool) void;
pub extern fn vterm_screen_set_reflow(screen: ?*VTermScreen, reflow: bool) void;
pub extern fn vterm_screen_enable_altscreen(screen: ?*VTermScreen, altscreen: c_int) void;
pub extern fn vterm_screen_set_callbacks(screen: ?*VTermScreen, callbacks: [*c]const VTermScreenCallbacks, user: ?*anyopaque) void;
pub extern fn vterm_screen_set_unrecognised_fallbacks(screen: ?*VTermScreen, fallbacks: [*c]const VTermStateFallbacks, user: ?*anyopaque) void;
pub extern fn vterm_screen_flush_damage(screen: ?*VTermScreen) void;
pub extern fn vterm_screen_set_damage_merge(screen: ?*VTermScreen, size: VTermDamageSize) void;
pub extern fn vterm_screen_convert_color_to_rgb(screen: ?*const VTermScreen, col: [*c]VTermColor) void;
pub extern fn rect_expand(dst: [*c]VTermRect, src: [*c]VTermRect) void;
pub extern fn rect_clip(dst: [*c]VTermRect, bounds: [*c]VTermRect) void;
pub extern fn rect_equal(a: [*c]VTermRect, b: [*c]VTermRect) c_int;
pub extern fn rect_contains(big: [*c]VTermRect, small: [*c]VTermRect) c_int;
pub extern fn rect_intersects(a: [*c]VTermRect, b: [*c]VTermRect) c_int;
pub extern fn vterm_state_free(state: ?*VTermState) void;
pub extern fn vterm_obtain_state(vt: ?*VTerm) ?*VTermState;
pub extern fn vterm_state_reset(state: ?*VTermState, hard: c_int) void;
pub extern fn vterm_state_set_callbacks(state: ?*VTermState, callbacks: [*c]const VTermStateCallbacks, user: ?*anyopaque) void;
pub extern fn vterm_state_set_unrecognised_fallbacks(state: ?*VTermState, fallbacks: [*c]const VTermStateFallbacks, user: ?*anyopaque) void;
pub extern fn vterm_state_set_termprop(state: ?*VTermState, prop: VTermProp, val: ?*VTermValue) c_int;
pub extern fn vterm_state_focus_in(state: ?*VTermState) void;
pub extern fn vterm_state_focus_out(state: ?*VTermState) void;
pub extern fn vterm_state_get_lineinfo(state: ?*const VTermState, row: c_int) ?*const VTermLineInfo;
pub extern fn vterm_state_set_selection_callbacks(state: ?*VTermState, callbacks: [*c]const VTermSelectionCallbacks, user: ?*anyopaque, buffer: [*c]u8, buflen: usize) void;
pub extern fn vterm_new(rows: c_int, cols: c_int) ?*VTerm;
pub extern fn vterm_build(builder: [*c]const struct_VTermBuilder) ?*VTerm;
pub extern fn vterm_free(vt: ?*VTerm) void;
pub extern fn vterm_allocator_malloc(vt: ?*VTerm, size: usize) ?*anyopaque;
pub extern fn vterm_allocator_free(vt: ?*VTerm, ptr: ?*anyopaque) void;
pub extern fn vterm_get_size(vt: ?*const VTerm, rowsp: [*c]c_int, colsp: [*c]c_int) void;
pub extern fn vterm_set_size(vt: ?*VTerm, rows: c_int, cols: c_int) void;
pub extern fn vterm_set_utf8(vt: ?*VTerm, is_utf8: c_int) void;
pub extern fn vterm_output_set_callback(vt: ?*VTerm, func: ?*const VTermOutputCallback, user: ?*anyopaque) void;
pub extern fn vterm_push_output_bytes(vt: ?*VTerm, bytes: [*c]const u8, len: usize) void;
pub extern fn vterm_push_output_sprintf(vt: ?*VTerm, format: [*c]const u8, ...) void;
pub extern fn vterm_push_output_sprintf_ctrl(vt: ?*VTerm, ctrl: u8, fmt: [*c]const u8, ...) void;
pub extern fn vterm_push_output_sprintf_str(vt: ?*VTerm, ctrl: u8, term: bool, fmt: [*c]const u8, ...) void;
pub extern fn vterm_get_attr_type(attr: VTermAttr) VTermValueType;
pub fn vterm_rect_move(arg_rect: [*c]VTermRect, arg_row_delta: c_int, arg_col_delta: c_int) callconv(.c) void {
    var rect = arg_rect;
    _ = &rect;
    var row_delta = arg_row_delta;
    _ = &row_delta;
    var col_delta = arg_col_delta;
    _ = &col_delta;
    rect.*.start_row += row_delta;
    rect.*.end_row += row_delta;
    rect.*.start_col += col_delta;
    rect.*.end_col += col_delta;
}
pub const VTERM_COLOR_RGB: c_int = 0;
pub const VTERM_COLOR_INDEXED: c_int = 1;
pub const VTERM_COLOR_TYPE_MASK: c_int = 1;
pub const VTERM_COLOR_DEFAULT_FG: c_int = 2;
pub const VTERM_COLOR_DEFAULT_BG: c_int = 4;
pub const VTERM_COLOR_DEFAULT_MASK: c_int = 6;
pub const VTermColorType = c_uint;
pub fn vterm_color_rgb(arg_col: [*c]VTermColor, arg_red: u8, arg_green: u8, arg_blue: u8) callconv(.c) void {
    var col = arg_col;
    _ = &col;
    var red = arg_red;
    _ = &red;
    var green = arg_green;
    _ = &green;
    var blue = arg_blue;
    _ = &blue;
    col.*.type = @as(u8, @bitCast(@as(i8, @truncate(VTERM_COLOR_RGB))));
    col.*.rgb.red = red;
    col.*.rgb.green = green;
    col.*.rgb.blue = blue;
}
pub fn vterm_color_indexed(arg_col: [*c]VTermColor, arg_idx: u8) callconv(.c) void {
    var col = arg_col;
    _ = &col;
    var idx = arg_idx;
    _ = &idx;
    col.*.type = @as(u8, @bitCast(@as(i8, @truncate(VTERM_COLOR_INDEXED))));
    col.*.indexed.idx = idx;
}
pub const VTERM_UNDERLINE_OFF: c_int = 0;
pub const VTERM_UNDERLINE_SINGLE: c_int = 1;
pub const VTERM_UNDERLINE_DOUBLE: c_int = 2;
pub const VTERM_UNDERLINE_CURLY: c_int = 3;
const enum_unnamed_197 = c_uint;
pub const VTERM_BASELINE_NORMAL: c_int = 0;
pub const VTERM_BASELINE_RAISE: c_int = 1;
pub const VTERM_BASELINE_LOWER: c_int = 2;
const enum_unnamed_198 = c_uint;
pub extern fn vterm_scroll_rect(rect: VTermRect, downward: c_int, rightward: c_int, moverect: ?*const fn (VTermRect, VTermRect, ?*anyopaque) callconv(.c) c_int, eraserect: ?*const fn (VTermRect, c_int, ?*anyopaque) callconv(.c) c_int, user: ?*anyopaque) void;
pub const WSP_ROOM: c_int = 1;
pub const WSP_VERT: c_int = 2;
pub const WSP_HOR: c_int = 4;
pub const WSP_TOP: c_int = 8;
pub const WSP_BOT: c_int = 16;
pub const WSP_HELP: c_int = 32;
pub const WSP_BELOW: c_int = 64;
pub const WSP_ABOVE: c_int = 128;
pub const WSP_NEWLOC: c_int = 256;
pub const WSP_NOENTER: c_int = 512;
pub const WSP_QUICKFIX: c_int = 1024;
const enum_unnamed_199 = c_uint;
pub const MIN_COLUMNS: c_int = 12;
pub const MIN_LINES: c_int = 2;
pub const STATUS_HEIGHT: c_int = 1;
const enum_unnamed_200 = c_uint;
pub const LOWEST_WIN_ID: c_int = 1000;
const enum_unnamed_201 = c_uint;
pub extern var tabpage_move_disallowed: c_int;
pub extern fn check_can_set_curbuf_disabled() bool;
pub extern fn check_can_set_curbuf_forceit(forceit: c_int) bool;
pub extern fn prevwin_curwin() [*c]win_T;
pub extern fn swbuf_goto_win_with_buf(buf: [*c]buf_T) [*c]win_T;
pub extern fn do_window(nchar: c_int, Prenum: c_int, xchar: c_int) void;
pub extern fn win_set_buf(win: [*c]win_T, buf: [*c]buf_T, err: [*c]Error) void;
pub extern fn win_fdccol_count(wp: [*c]win_T) c_int;
pub extern fn merge_win_config(dst: [*c]WinConfig, src: WinConfig) void;
pub extern fn ui_ext_win_position(wp: [*c]win_T, validate: bool) void;
pub extern fn ui_ext_win_viewport(wp: [*c]win_T) void;
pub extern fn check_split_disallowed(wp: [*c]const win_T) c_int;
pub extern fn check_split_disallowed_err(wp: [*c]const win_T, err: [*c]Error) bool;
pub extern fn win_split(size: c_int, flags: c_int) c_int;
pub extern fn win_split_ins(size: c_int, flags: c_int, new_wp: [*c]win_T, dir: c_int, to_flatten: [*c]frame_T) [*c]win_T;
pub extern fn win_init(newp: [*c]win_T, oldp: [*c]win_T, flags: c_int) void;
pub extern fn win_valid(win: [*c]const win_T) bool;
pub extern fn tabpage_win_valid(tp: [*c]const tabpage_T, win: [*c]const win_T) bool;
pub extern fn win_find_by_handle(handle: handle_T) [*c]win_T;
pub extern fn win_valid_any_tab(win: [*c]win_T) bool;
pub extern fn win_count() c_int;
pub extern fn make_windows(count: c_int, vertical: bool) c_int;
pub extern fn win_splitmove(wp: [*c]win_T, size: c_int, flags: c_int) c_int;
pub extern fn win_move_after(win1: [*c]win_T, win2: [*c]win_T) void;
pub extern fn win_equal(next_curwin: [*c]win_T, current: bool, dir: c_int) void;
pub extern fn leaving_window(win: [*c]win_T) void;
pub extern fn entering_window(win: [*c]win_T) void;
pub extern fn win_init_empty(wp: [*c]win_T) void;
pub extern fn curwin_init() void;
pub extern fn close_windows(buf: [*c]buf_T, keep_curwin: bool) void;
pub extern fn last_window(win: [*c]win_T) bool;
pub extern fn one_window(win: [*c]win_T, tp: [*c]tabpage_T) bool;
pub extern fn can_close_in_cmdwin(win: [*c]win_T, err: [*c]Error) bool;
pub extern fn win_close(win: [*c]win_T, free_buf: bool, force: bool) c_int;
pub extern fn win_close_othertab(win: [*c]win_T, free_buf: c_int, tp: [*c]tabpage_T, force: bool) bool;
pub extern fn win_free_all() void;
pub extern fn winframe_remove(win: [*c]win_T, dirp: [*c]c_int, tp: [*c]tabpage_T, unflat_altfr: [*c][*c]frame_T) [*c]win_T;
pub extern fn winframe_find_altwin(win: [*c]win_T, dirp: [*c]c_int, tp: [*c]tabpage_T, altfr: [*c][*c]frame_T) [*c]win_T;
pub extern fn winframe_restore(wp: [*c]win_T, dir: c_int, unflat_altfr: [*c]frame_T) void;
pub extern fn frame2win(frp: [*c]frame_T) [*c]win_T;
pub extern fn frame_new_height(topfrp: [*c]frame_T, height: c_int, topfirst: bool, wfh: bool, set_ch: bool) void;
pub extern fn close_others(message: c_int, forceit: c_int) void;
pub extern fn unuse_tabpage(tp: [*c]tabpage_T) void;
pub extern fn use_tabpage(tp: [*c]tabpage_T) void;
pub extern fn win_alloc_first() void;
pub extern fn win_alloc_aucmd_win(idx: c_int) void;
pub extern fn win_init_size() void;
pub extern fn free_tabpage(tp: [*c]tabpage_T) void;
pub extern fn win_new_tabpage(after: c_int, filename: [*c]u8) c_int;
pub extern fn make_tabpages(maxcount: c_int) c_int;
pub extern fn valid_tabpage(tpc: [*c]tabpage_T) bool;
pub extern fn valid_tabpage_win(tpc: [*c]tabpage_T) c_int;
pub extern fn close_tabpage(tab: [*c]tabpage_T) void;
pub extern fn find_tabpage(n: c_int) [*c]tabpage_T;
pub extern fn tabpage_index(ftp: [*c]tabpage_T) c_int;
pub extern fn goto_tabpage(n: c_int) void;
pub extern fn goto_tabpage_tp(tp: [*c]tabpage_T, trigger_enter_autocmds: bool, trigger_leave_autocmds: bool) void;
pub extern fn goto_tabpage_lastused() bool;
pub extern fn goto_tabpage_win(tp: [*c]tabpage_T, wp: [*c]win_T) void;
pub extern fn tabpage_move(nr: c_int) void;
pub extern fn win_goto(wp: [*c]win_T) void;
pub extern fn win_find_tabpage(win: [*c]win_T) [*c]tabpage_T;
pub extern fn win_vert_neighbor(tp: [*c]tabpage_T, wp: [*c]win_T, up: bool, count: c_int) [*c]win_T;
pub extern fn win_horz_neighbor(tp: [*c]tabpage_T, wp: [*c]win_T, left: bool, count: c_int) [*c]win_T;
pub extern fn win_enter(wp: [*c]win_T, undo_sync: bool) void;
pub extern fn win_fix_current_dir() void;
pub extern fn buf_jump_open_win(buf: [*c]buf_T) [*c]win_T;
pub extern fn buf_jump_open_tab(buf: [*c]buf_T) [*c]win_T;
pub extern fn win_alloc(after: [*c]win_T, hidden: bool) [*c]win_T;
pub extern fn free_wininfo(wip: [*c]WinInfo, bp: [*c]buf_T) void;
pub extern fn win_free(wp: [*c]win_T, tp: [*c]tabpage_T) void;
pub extern fn win_free_grid(wp: [*c]win_T, reinit: bool) void;
pub extern fn win_append(after: [*c]win_T, wp: [*c]win_T, tp: [*c]tabpage_T) void;
pub extern fn win_remove(wp: [*c]win_T, tp: [*c]tabpage_T) void;
pub extern fn win_new_screensize() void;
pub extern fn win_new_screen_rows() void;
pub extern fn win_new_screen_cols() void;
pub extern fn snapshot_windows_scroll_size() void;
pub extern fn may_make_initial_scroll_size_snapshot() void;
pub extern fn may_trigger_win_scrolled_resized() void;
pub extern fn win_size_save(gap: [*c]garray_T) void;
pub extern fn win_size_restore(gap: [*c]garray_T) void;
pub extern fn win_comp_pos() c_int;
pub extern fn win_setheight(height: c_int) void;
pub extern fn win_setheight_win(height: c_int, win: [*c]win_T) void;
pub extern fn win_setwidth(width: c_int) void;
pub extern fn win_setwidth_win(width: c_int, wp: [*c]win_T) void;
pub extern fn did_set_winminheight(args: [*c]optset_T) [*c]const u8;
pub extern fn did_set_winminwidth(args: [*c]optset_T) [*c]const u8;
pub extern fn win_drag_status_line(dragwin: [*c]win_T, offset: c_int) void;
pub extern fn win_drag_vsep_line(dragwin: [*c]win_T, offset: c_int) void;
pub extern fn set_fraction(wp: [*c]win_T) void;
pub extern fn win_fix_scroll(resize: bool) void;
pub extern fn win_new_height(wp: [*c]win_T, height: c_int) void;
pub extern fn scroll_to_fraction(wp: [*c]win_T, prev_height: c_int) void;
pub extern fn win_set_inner_size(wp: [*c]win_T, valid_cursor: bool) void;
pub extern fn win_new_width(wp: [*c]win_T, width: c_int) void;
pub extern fn win_default_scroll(wp: [*c]win_T) OptInt;
pub extern fn win_comp_scroll(wp: [*c]win_T) void;
pub extern fn command_height() void;
pub extern fn last_status(morewin: bool) void;
pub extern fn win_remove_status_line(wp: [*c]win_T, add_hsep: bool) void;
pub extern fn set_winbar_win(wp: [*c]win_T, make_room: bool, valid_cursor: bool) c_int;
pub extern fn set_winbar(make_room: bool) void;
pub extern fn tabline_height() c_int;
pub extern fn global_winbar_height() c_int;
pub extern fn global_stl_height() c_int;
pub extern fn last_stl_height(morewin: bool) c_int;
pub extern fn min_rows(tp: [*c]tabpage_T) c_int;
pub extern fn min_rows_for_all_tabpages() c_int;
pub extern fn only_one_window() bool;
pub extern fn check_lnums(do_curwin: bool) void;
pub extern fn check_lnums_nested(do_curwin: bool) void;
pub extern fn reset_lnums() void;
pub extern fn make_snapshot(idx: c_int) void;
pub extern fn restore_snapshot(idx: c_int, close_curwin: c_int) void;
pub extern fn check_colorcolumn(cc: [*c]u8, wp: [*c]win_T) [*c]const u8;
pub extern fn get_last_winid() c_int;
pub extern fn win_locked(wp: [*c]win_T) c_int;
pub extern fn win_get_tabwin(id: handle_T, tabnr: [*c]c_int, winnr: [*c]c_int) void;
pub extern fn win_ui_flush(validate: bool) void;
pub extern fn lastwin_nofloating() [*c]win_T;
pub const TerminalState = extern struct {
    state: VimState = @import("std").mem.zeroes(VimState),
    term: [*c]Terminal = @import("std").mem.zeroes([*c]Terminal),
    save_rd: c_int = @import("std").mem.zeroes(c_int),
    close: bool = @import("std").mem.zeroes(bool),
    got_bsl: bool = @import("std").mem.zeroes(bool),
    got_bsl_o: bool = @import("std").mem.zeroes(bool),
    cursor_visible: bool = @import("std").mem.zeroes(bool),
    save_curwin_handle: handle_T = @import("std").mem.zeroes(handle_T),
    save_w_p_cul: bool = @import("std").mem.zeroes(bool),
    save_w_p_culopt: [*c]u8 = @import("std").mem.zeroes([*c]u8),
    save_w_p_culopt_flags: u8 = @import("std").mem.zeroes(u8),
    save_w_p_cuc: c_int = @import("std").mem.zeroes(c_int),
    save_w_p_so: OptInt = @import("std").mem.zeroes(OptInt),
    save_w_p_siso: OptInt = @import("std").mem.zeroes(OptInt),
};
pub fn emit_termrequest(arg_argv: [*c]?*anyopaque) callconv(.c) void {
    var argv = arg_argv;
    _ = &argv;
    var term: [*c]Terminal = @as([*c]Terminal, @ptrCast(@alignCast(argv[@as(c_uint, @intCast(@as(c_int, 0)))])));
    _ = &term;
    var sequence: [*c]u8 = @as([*c]u8, @ptrCast(@alignCast(argv[@as(c_uint, @intCast(@as(c_int, 1)))])));
    _ = &sequence;
    var sequence_length: usize = @as(usize, @intCast(@intFromPtr(argv[@as(c_uint, @intCast(@as(c_int, 2)))])));
    _ = &sequence_length;
    var pending_send: [*c]StringBuilder = @as([*c]StringBuilder, @ptrCast(@alignCast(argv[@as(c_uint, @intCast(@as(c_int, 3)))])));
    _ = &pending_send;
    var row: c_int = @as(c_int, @bitCast(@as(c_int, @truncate(@as(isize, @intCast(@intFromPtr(argv[@as(c_uint, @intCast(@as(c_int, 4)))])))))));
    _ = &row;
    var col: c_int = @as(c_int, @bitCast(@as(c_int, @truncate(@as(isize, @intCast(@intFromPtr(argv[@as(c_uint, @intCast(@as(c_int, 5)))])))))));
    _ = &col;
    var sb_deleted: usize = @as(usize, @bitCast(@as(isize, @intCast(@intFromPtr(argv[@as(c_uint, @intCast(@as(c_int, 6)))])))));
    _ = &sb_deleted;
    var terminator: VTermTerminator = @as(c_uint, @bitCast(@as(c_int, @truncate(@as(isize, @intCast(@intFromPtr(argv[@as(c_uint, @intCast(@as(c_int, 7)))])))))));
    _ = &terminator;
    if (term.*.sb_pending > @as(c_int, 0)) {
        while (true) {
            multiqueue_put_event(term.*.pending.events, Event{
                .handler = &emit_termrequest,
                .argv = [8]?*anyopaque{
                    @as(?*anyopaque, @ptrCast(term)),
                    @as(?*anyopaque, @ptrCast(sequence)),
                    @as(?*anyopaque, @ptrFromInt(sequence_length)),
                    @as(?*anyopaque, @ptrCast(pending_send)),
                    @as(?*anyopaque, @ptrFromInt(@as(usize, @intCast(row)))),
                    @as(?*anyopaque, @ptrFromInt(@as(usize, @intCast(col)))),
                    @as(?*anyopaque, @ptrFromInt(sb_deleted)),
                    @as(?*anyopaque, @ptrFromInt(@as(usize, @intCast(terminator)))),
                } ++ [1]?*anyopaque{null} ** 2,
            });
            if (!false) break;
        }
        return;
    }
    set_vim_var_string(@as(c_uint, @bitCast(VV_TERMREQUEST)), sequence, @as(ptrdiff_t, @bitCast(sequence_length)));
    var cursor: Array = Array{
        .size = @as(usize, @bitCast(@as(c_long, @as(c_int, 0)))),
        .capacity = @as(usize, @bitCast(@as(c_long, @as(c_int, 0)))),
        .items = null,
    };
    _ = &cursor;
    var cursor__items: [2]Object = undefined;
    _ = &cursor__items;
    cursor.capacity = 2;
    cursor.items = @as([*c]Object, @ptrCast(@alignCast(&cursor__items[@as(usize, @intCast(0))])));
    _ = blk: {
        const tmp = Object{
            .type = @as(c_uint, @bitCast(kObjectTypeInteger)),
            .data = .{
                .integer = @as(i64, @bitCast(@as(c_long, row))) - @as(i64, @bitCast(term.*.sb_deleted -% sb_deleted)),
            },
        };
        (cursor.items + (blk_1: {
            const ref = &cursor.size;
            const tmp_2 = ref.*;
            ref.* +%= 1;
            break :blk_1 tmp_2;
        })).* = tmp;
        break :blk tmp;
    };
    _ = blk: {
        const tmp = Object{
            .type = @as(c_uint, @bitCast(kObjectTypeInteger)),
            .data = .{
                .integer = @as(Integer, @bitCast(@as(c_long, col))),
            },
        };
        (cursor.items + (blk_1: {
            const ref = &cursor.size;
            const tmp_2 = ref.*;
            ref.* +%= 1;
            break :blk_1 tmp_2;
        })).* = tmp;
        break :blk tmp;
    };
    var data: Dict = Dict{
        .size = @as(usize, @bitCast(@as(c_long, @as(c_int, 0)))),
        .capacity = @as(usize, @bitCast(@as(c_long, @as(c_int, 0)))),
        .items = null,
    };
    _ = &data;
    var data__items: [3]KeyValuePair = undefined;
    _ = &data__items;
    data.capacity = 3;
    data.items = @as([*c]KeyValuePair, @ptrCast(@alignCast(&data__items[@as(usize, @intCast(0))])));
    var termrequest: String = String{
        .data = sequence,
        .size = sequence_length,
    };
    _ = &termrequest;
    _ = blk: {
        const tmp = KeyValuePair{
            .key = cstr_as_string("sequence"),
            .value = Object{
                .type = @as(c_uint, @bitCast(kObjectTypeString)),
                .data = .{
                    .string = termrequest,
                },
            },
        };
        (data.items + (blk_1: {
            const ref = &data.size;
            const tmp_2 = ref.*;
            ref.* +%= 1;
            break :blk_1 tmp_2;
        })).* = tmp;
        break :blk tmp;
    };
    _ = blk: {
        const tmp = KeyValuePair{
            .key = cstr_as_string("cursor"),
            .value = Object{
                .type = @as(c_uint, @bitCast(kObjectTypeArray)),
                .data = .{
                    .array = cursor,
                },
            },
        };
        (data.items + (blk_1: {
            const ref = &data.size;
            const tmp_2 = ref.*;
            ref.* +%= 1;
            break :blk_1 tmp_2;
        })).* = tmp;
        break :blk tmp;
    };
    _ = blk: {
        const tmp = KeyValuePair{
            .key = cstr_as_string("terminator"),
            .value = if (terminator == @as(c_uint, @bitCast(VTERM_TERMINATOR_BEL))) Object{
                .type = @as(c_uint, @bitCast(kObjectTypeString)),
                .data = .{
                    .string = String{
                        .data = @as([*c]u8, @ptrCast(@constCast(@volatileCast("\x07")))),
                        .size = @sizeOf([2]u8) -% @as(c_ulong, @bitCast(@as(c_long, @as(c_int, 1)))),
                    },
                },
            } else Object{
                .type = @as(c_uint, @bitCast(kObjectTypeString)),
                .data = .{
                    .string = String{
                        .data = @as([*c]u8, @ptrCast(@constCast(@volatileCast("\x1b\\")))),
                        .size = @sizeOf([3]u8) -% @as(c_ulong, @bitCast(@as(c_long, @as(c_int, 1)))),
                    },
                },
            },
        };
        (data.items + (blk_1: {
            const ref = &data.size;
            const tmp_2 = ref.*;
            ref.* +%= 1;
            break :blk_1 tmp_2;
        })).* = tmp;
        break :blk tmp;
    };
    var buf: [*c]buf_T = @as([*c]buf_T, @ptrCast(@alignCast(map_get_intptr_t(&buffer_handles, term.*.buf_handle))));
    _ = &buf;
    var o = Object{
        .type = @as(c_uint, @bitCast(kObjectTypeDict)),
        .data = .{
            .dict = data,
        },
    };
    _ = apply_autocmds_group(@as(c_uint, @bitCast(EVENT_TERMREQUEST)), null, null, @as(c_int, 1) != 0, AUGROUP_ALL, buf, null, &o);
    xfree(@as(?*anyopaque, @ptrCast(sequence)));
    var term_pending_send: [*c]StringBuilder = term.*.pending.send;
    _ = &term_pending_send;
    term.*.pending.send = null;
    if (pending_send.*.size != 0) {
        terminal_send(term, pending_send.*.items, pending_send.*.size);
        while (true) {
            xfree(@as(?*anyopaque, @ptrCast(pending_send.*.items)));
            _ = blk: {
                pending_send.*.size = blk_1: {
                    const tmp = @as(usize, @bitCast(@as(c_long, @as(c_int, 0))));
                    pending_send.*.capacity = tmp;
                    break :blk_1 tmp;
                };
                break :blk blk_1: {
                    const tmp = null;
                    pending_send.*.items = tmp;
                    break :blk_1 tmp;
                };
            };
            if (!false) break;
        }
    }
    if (term_pending_send != pending_send) {
        term.*.pending.send = term_pending_send;
    }
    xfree(@as(?*anyopaque, @ptrCast(pending_send)));
}
pub fn schedule_termrequest(arg_term: [*c]Terminal) callconv(.c) void {
    var term = arg_term;
    _ = &term;
    term.*.pending.send = @as([*c]StringBuilder, @ptrCast(@alignCast(xmalloc(@sizeOf(StringBuilder)))));
    _ = blk: {
        term.*.pending.send.*.size = blk_1: {
            const tmp = @as(usize, @bitCast(@as(c_long, @as(c_int, 0))));
            term.*.pending.send.*.capacity = tmp;
            break :blk_1 tmp;
        };
        break :blk blk_1: {
            const tmp = null;
            term.*.pending.send.*.items = tmp;
            break :blk_1 tmp;
        };
    };
    var line: c_int = row_to_linenr(term, term.*.cursor.row);
    _ = &line;
    while (true) {
        multiqueue_put_event(main_loop.events, Event{
            .handler = &emit_termrequest,
            .argv = [8]?*anyopaque{
                @as(?*anyopaque, @ptrCast(term)),
                xmemdup(@as(?*const anyopaque, @ptrCast(term.*.termrequest_buffer.items)), term.*.termrequest_buffer.size),
                @as(?*anyopaque, @ptrFromInt(@as(usize, @intCast(term.*.termrequest_buffer.size)))),
                @as(?*anyopaque, @ptrCast(term.*.pending.send)),
                @as(?*anyopaque, @ptrFromInt(@as(usize, @intCast(@as(c_long, line))))),
                @as(?*anyopaque, @ptrFromInt(@as(usize, @intCast(term.*.cursor.col)))),
                @as(?*anyopaque, @ptrFromInt(term.*.sb_deleted)),
                @as(?*anyopaque, @ptrFromInt(@as(usize, @intCast(term.*.termrequest_terminator)))),
            } ++ [1]?*anyopaque{null} ** 2,
        });
        if (!false) break;
    }
}
pub fn parse_osc8(arg_str: [*c]const u8, arg_attr: [*c]c_int) callconv(.c) c_int {
    var str = arg_str;
    _ = &str;
    var attr = arg_attr;
    _ = &attr;
    var i: usize = 0;
    _ = &i;
    while (@as(c_int, @bitCast(@as(c_uint, str[i]))) != @as(c_int, '\x00')) : (i +%= 1) {
        if (@as(c_int, @bitCast(@as(c_uint, str[i]))) == @as(c_int, ';')) {
            break;
        }
    }
    if (@as(c_int, @bitCast(@as(c_uint, str[i]))) != @as(c_int, ';')) {
        return 0;
    }
    i +%= 1;
    if (@as(c_int, @bitCast(@as(c_uint, str[i]))) == @as(c_int, '\x00')) {
        attr.* = 0;
        return 1;
    }
    attr.* = hl_add_url(@as(c_int, 0), str + i);
    return 1;
}
// src/nvim/terminal.c:355:20: warning: local variable has opaque type

// src/nvim/terminal.c:326:12: warning: unable to translate function, demoted to extern
pub fn on_osc(arg_command: c_int, arg_frag: VTermStringFragment, arg_user: ?*anyopaque) callconv(.c) c_int {
    _ = arg_command;
    _ = arg_frag;
    _ = arg_user;
    @panic("on_osc unimplemented");
    // Terminal *term = user;
    //
    // if (frag.str == NULL || frag.len == 0) {
    //   return 0;
    // }
    //
    // if (command != 8 && !has_event(EVENT_TERMREQUEST)) {
    //   return 1;
    // }
    //
    // if (frag.initial) {
    //   kv_size(term->termrequest_buffer) = 0;
    //   kv_printf(term->termrequest_buffer, "\x1b]%d;", command);
    // }
    // kv_concat_len(term->termrequest_buffer, frag.str, frag.len);
    // if (frag.final) {
    //   term->termrequest_terminator = frag.terminator;
    //   if (has_event(EVENT_TERMREQUEST)) {
    //     schedule_termrequest(term);
    //   }
    //   if (command == 8) {
    //     kv_push(term->termrequest_buffer, NUL);
    //     const size_t off = STRLEN_LITERAL("\x1b]8;");
    //     int attr = 0;
    //     if (parse_osc8(term->termrequest_buffer.items + off, &attr)) {
    //       VTermState *state = vterm_obtain_state(term->vt);
    //       VTermValue value = { .number = attr };
    //       vterm_state_set_penattr(state, VTERM_ATTR_URI, VTERM_VALUETYPE_INT, &value);
    //     }
    //   }
    // }
    // return 1;
}

pub fn on_dcs(arg_command: [*c]const u8, arg_commandlen: usize, arg_frag: VTermStringFragment, arg_user: ?*anyopaque) callconv(.c) c_int {
    var command = arg_command;
    _ = &command;
    var commandlen = arg_commandlen;
    _ = &commandlen;
    var frag = arg_frag;
    _ = &frag;
    var user = arg_user;
    _ = &user;
    var term: [*c]Terminal = @as([*c]Terminal, @ptrCast(@alignCast(user)));
    _ = &term;
    if ((command == @as([*c]const u8, @ptrCast(@alignCast(@as(?*anyopaque, @ptrFromInt(@as(c_int, 0))))))) or (frag.str == @as([*c]const u8, @ptrCast(@alignCast(@as(?*anyopaque, @ptrFromInt(@as(c_int, 0)))))))) {
        return 0;
    }
    if (!has_event(@as(c_uint, @bitCast(EVENT_TERMREQUEST)))) {
        return 1;
    }
    if (frag.initial) {
        term.*.termrequest_buffer.size = 0;
        _ = kv_do_printf(&term.*.termrequest_buffer, "\x1bP%*s", @as(c_int, @bitCast(@as(c_uint, @truncate(commandlen)))), command);
    }
    if (frag.len > 0) {
        while (true) {
            if (term.*.termrequest_buffer.capacity < (term.*.termrequest_buffer.size +% frag.len)) {
                term.*.termrequest_buffer.capacity = term.*.termrequest_buffer.size +% frag.len;
                _ = blk: {
                    _ = blk_1: {
                        _ = blk_2: {
                            const ref = &term.*.termrequest_buffer.capacity;
                            ref.* -%= 1;
                            break :blk_2 ref.*;
                        };
                        break :blk_1 blk_2: {
                            _ = blk_3: {
                                _ = blk_4: {
                                    _ = blk_5: {
                                        term.*.termrequest_buffer.capacity |= term.*.termrequest_buffer.capacity >> @intCast(1);
                                        break :blk_5 blk_6: {
                                            const ref = &term.*.termrequest_buffer.capacity;
                                            ref.* |= term.*.termrequest_buffer.capacity >> @intCast(2);
                                            break :blk_6 ref.*;
                                        };
                                    };
                                    break :blk_4 blk_5: {
                                        const ref = &term.*.termrequest_buffer.capacity;
                                        ref.* |= term.*.termrequest_buffer.capacity >> @intCast(4);
                                        break :blk_5 ref.*;
                                    };
                                };
                                break :blk_3 blk_4: {
                                    const ref = &term.*.termrequest_buffer.capacity;
                                    ref.* |= term.*.termrequest_buffer.capacity >> @intCast(8);
                                    break :blk_4 ref.*;
                                };
                            };
                            break :blk_2 blk_3: {
                                const ref = &term.*.termrequest_buffer.capacity;
                                ref.* |= term.*.termrequest_buffer.capacity >> @intCast(16);
                                break :blk_3 ref.*;
                            };
                        };
                    };
                    break :blk blk_1: {
                        const ref = &term.*.termrequest_buffer.capacity;
                        ref.* +%= 1;
                        break :blk_1 ref.*;
                    };
                };
                _ = blk: {
                    term.*.termrequest_buffer.capacity = term.*.termrequest_buffer.capacity;
                    break :blk blk_1: {
                        const tmp = @as([*c]u8, @ptrCast(@alignCast(xrealloc(@as(?*anyopaque, @ptrCast(term.*.termrequest_buffer.items)), @sizeOf(u8) *% term.*.termrequest_buffer.capacity))));
                        term.*.termrequest_buffer.items = tmp;
                        break :blk_1 tmp;
                    };
                };
            }
            if (!false) break;
        }
        _ = blk: {
            _ = @sizeOf(c_int);
            break :blk blk_1: {
                break :blk_1 if (term.*.termrequest_buffer.items != null) {} else {
                    c.__assert_fail("(term->termrequest_buffer).items", "src/nvim/terminal.c", @as(c_uint, @bitCast(@as(c_int, 378))), "int on_dcs(const char *, size_t, VTermStringFragment, void *)");
                };
            };
        };
        _ = memcpy(
            @as(?*anyopaque, @ptrCast(term.*.termrequest_buffer.items + term.*.termrequest_buffer.size)),
            @as(?*const anyopaque, @ptrCast(frag.str)),
            @sizeOf(u8) *% @as(c_ulong, @intCast(frag.len)),
        );
        term.*.termrequest_buffer.size = term.*.termrequest_buffer.size +% frag.len;
    }
    if (frag.final) {
        term.*.termrequest_terminator = frag.terminator;
        schedule_termrequest(term);
    }
    return 1;
}
pub fn on_apc(arg_frag: VTermStringFragment, arg_user: ?*anyopaque) callconv(.c) c_int {
    var frag = arg_frag;
    _ = &frag;
    var user = arg_user;
    _ = &user;
    var term: [*c]Terminal = @as([*c]Terminal, @ptrCast(@alignCast(user)));
    _ = &term;
    if ((frag.str == @as([*c]const u8, @ptrCast(@alignCast(@as(?*anyopaque, @ptrFromInt(@as(c_int, 0))))))) or (@as(c_int, frag.len) == 0)) {
        return 0;
    }
    if (!has_event(@as(c_uint, @bitCast(EVENT_TERMREQUEST)))) {
        return 1;
    }
    if (frag.initial) {
        term.*.termrequest_buffer.size = 0;
        _ = kv_do_printf(&term.*.termrequest_buffer, "\x1b_");
    }
    if (frag.len > 0) {
        while (true) {
            if (term.*.termrequest_buffer.capacity < (term.*.termrequest_buffer.size +% frag.len)) {
                term.*.termrequest_buffer.capacity = term.*.termrequest_buffer.size +% frag.len;
                _ = blk: {
                    _ = blk_1: {
                        _ = blk_2: {
                            const ref = &term.*.termrequest_buffer.capacity;
                            ref.* -%= 1;
                            break :blk_2 ref.*;
                        };
                        break :blk_1 blk_2: {
                            _ = blk_3: {
                                _ = blk_4: {
                                    _ = blk_5: {
                                        term.*.termrequest_buffer.capacity |= term.*.termrequest_buffer.capacity >> @intCast(1);
                                        break :blk_5 blk_6: {
                                            const ref = &term.*.termrequest_buffer.capacity;
                                            ref.* |= term.*.termrequest_buffer.capacity >> @intCast(2);
                                            break :blk_6 ref.*;
                                        };
                                    };
                                    break :blk_4 blk_5: {
                                        const ref = &term.*.termrequest_buffer.capacity;
                                        ref.* |= term.*.termrequest_buffer.capacity >> @intCast(4);
                                        break :blk_5 ref.*;
                                    };
                                };
                                break :blk_3 blk_4: {
                                    const ref = &term.*.termrequest_buffer.capacity;
                                    ref.* |= term.*.termrequest_buffer.capacity >> @intCast(8);
                                    break :blk_4 ref.*;
                                };
                            };
                            break :blk_2 blk_3: {
                                const ref = &term.*.termrequest_buffer.capacity;
                                ref.* |= term.*.termrequest_buffer.capacity >> @intCast(16);
                                break :blk_3 ref.*;
                            };
                        };
                    };
                    break :blk blk_1: {
                        const ref = &term.*.termrequest_buffer.capacity;
                        ref.* +%= 1;
                        break :blk_1 ref.*;
                    };
                };
                _ = blk: {
                    term.*.termrequest_buffer.capacity = term.*.termrequest_buffer.capacity;
                    break :blk blk_1: {
                        const tmp = @as([*c]u8, @ptrCast(@alignCast(xrealloc(@as(?*anyopaque, @ptrCast(term.*.termrequest_buffer.items)), @sizeOf(u8) *% term.*.termrequest_buffer.capacity))));
                        term.*.termrequest_buffer.items = tmp;
                        break :blk_1 tmp;
                    };
                };
            }
            if (!false) break;
        }
        _ = blk: {
            _ = @sizeOf(c_int);
            break :blk blk_1: {
                break :blk_1 if (term.*.termrequest_buffer.items != null) {} else {
                    c.__assert_fail("(term->termrequest_buffer).items", "src/nvim/terminal.c", @as(c_uint, @bitCast(@as(c_int, 401))), "int on_apc(VTermStringFragment, void *)");
                };
            };
        };
        _ = memcpy(
            @as(?*anyopaque, @ptrCast(term.*.termrequest_buffer.items + term.*.termrequest_buffer.size)),
            @as(?*const anyopaque, @ptrCast(frag.str)),
            @sizeOf(u8) *% @as(c_ulong, @intCast(frag.len)),
        );
        term.*.termrequest_buffer.size = term.*.termrequest_buffer.size +% frag.len;
    }
    if (frag.final) {
        term.*.termrequest_terminator = frag.terminator;
        schedule_termrequest(term);
    }
    return 1;
}
pub fn term_output_callback(arg_s: [*c]const u8, arg_len: usize, arg_user_data: ?*anyopaque) callconv(.c) void {
    var s = arg_s;
    _ = &s;
    var len = arg_len;
    _ = &len;
    var user_data = arg_user_data;
    _ = &user_data;
    terminal_send(@as([*c]Terminal, @ptrCast(@alignCast(user_data))), s, len);
}
pub fn set_terminal_winopts(s: [*c]TerminalState) callconv(.c) void {
    _ = &s;
    _ = blk: {
        _ = @sizeOf(c_int);
        break :blk blk_1: {
            break :blk_1 if (s.*.save_curwin_handle == @as(c_int, 0)) {} else {
                c.__assert_fail("s->save_curwin_handle == 0", "src/nvim/terminal.c", @as(c_uint, @bitCast(@as(c_int, 695))), "void set_terminal_winopts(TerminalState *const)");
            };
        };
    };
    s.*.save_curwin_handle = curwin.*.handle;
    s.*.save_w_p_cul = curwin.*.w_onebuf_opt.wo_cul != 0;
    s.*.save_w_p_culopt = null;
    s.*.save_w_p_culopt_flags = curwin.*.w_p_culopt_flags;
    s.*.save_w_p_cuc = curwin.*.w_onebuf_opt.wo_cuc;
    s.*.save_w_p_so = curwin.*.w_onebuf_opt.wo_so;
    s.*.save_w_p_siso = curwin.*.w_onebuf_opt.wo_siso;
    if ((curwin.*.w_onebuf_opt.wo_cul != 0) and ((@as(c_int, @bitCast(@as(c_uint, curwin.*.w_p_culopt_flags))) & kOptCuloptFlagNumber) != 0)) {
        if (!strequal(curwin.*.w_onebuf_opt.wo_culopt, "number")) {
            s.*.save_w_p_culopt = curwin.*.w_onebuf_opt.wo_culopt;
            curwin.*.w_onebuf_opt.wo_culopt = xstrdup("number");
        }
        curwin.*.w_p_culopt_flags = @as(u8, @bitCast(@as(i8, @truncate(kOptCuloptFlagNumber))));
    } else {
        curwin.*.w_onebuf_opt.wo_cul = 0;
    }
    curwin.*.w_onebuf_opt.wo_cuc = 0;
    curwin.*.w_onebuf_opt.wo_so = 0;
    curwin.*.w_onebuf_opt.wo_siso = 0;
    if (curwin.*.w_onebuf_opt.wo_cuc != s.*.save_w_p_cuc) {
        redraw_later(curwin, UPD_SOME_VALID);
    } else if ((curwin.*.w_onebuf_opt.wo_cul != @as(c_int, @intFromBool(s.*.save_w_p_cul))) or ((curwin.*.w_onebuf_opt.wo_cul != 0) and (@as(c_int, @bitCast(@as(c_uint, curwin.*.w_p_culopt_flags))) != @as(c_int, @bitCast(@as(c_uint, s.*.save_w_p_culopt_flags)))))) {
        redraw_later(curwin, UPD_VALID);
    }
}
pub fn unset_terminal_winopts(s: [*c]TerminalState) callconv(.c) void {
    _ = &s;
    _ = blk: {
        _ = @sizeOf(c_int);
        break :blk blk_1: {
            break :blk_1 if (s.*.save_curwin_handle != @as(c_int, 0)) {} else {
                c.__assert_fail("s->save_curwin_handle != 0", "src/nvim/terminal.c", @as(c_uint, @bitCast(@as(c_int, 731))), "void unset_terminal_winopts(TerminalState *const)");
            };
        };
    };
    const wp: [*c]win_T = @as([*c]win_T, @ptrCast(@alignCast(map_get_intptr_t(&window_handles, s.*.save_curwin_handle))));
    _ = &wp;
    if (!(wp != null)) {
        free_string_option(s.*.save_w_p_culopt);
        s.*.save_curwin_handle = 0;
        return;
    }
    if (win_valid(wp)) {
        if (s.*.save_w_p_cuc != wp.*.w_onebuf_opt.wo_cuc) {
            redraw_later(wp, UPD_SOME_VALID);
        } else if ((@as(c_int, @intFromBool(s.*.save_w_p_cul)) != wp.*.w_onebuf_opt.wo_cul) or ((@as(c_int, @intFromBool(s.*.save_w_p_cul)) != 0) and (@as(c_int, @bitCast(@as(c_uint, s.*.save_w_p_culopt_flags))) != @as(c_int, @bitCast(@as(c_uint, wp.*.w_p_culopt_flags)))))) {
            redraw_later(wp, UPD_VALID);
        }
    }
    wp.*.w_onebuf_opt.wo_cul = @as(c_int, @intFromBool(s.*.save_w_p_cul));
    if (s.*.save_w_p_culopt != null) {
        free_string_option(wp.*.w_onebuf_opt.wo_culopt);
        wp.*.w_onebuf_opt.wo_culopt = s.*.save_w_p_culopt;
    }
    wp.*.w_p_culopt_flags = s.*.save_w_p_culopt_flags;
    wp.*.w_onebuf_opt.wo_cuc = s.*.save_w_p_cuc;
    wp.*.w_onebuf_opt.wo_so = s.*.save_w_p_so;
    wp.*.w_onebuf_opt.wo_siso = s.*.save_w_p_siso;
    s.*.save_curwin_handle = 0;
}
pub fn terminal_check_cursor() callconv(.c) void {
    var term: [*c]Terminal = curbuf.*.terminal;
    _ = &term;
    curwin.*.w_cursor.lnum = if (curbuf.*.b_ml.ml_line_count < row_to_linenr(term, term.*.cursor.row)) curbuf.*.b_ml.ml_line_count else row_to_linenr(term, term.*.cursor.row);
    const topline: linenr_T = if (((curbuf.*.b_ml.ml_line_count - curwin.*.w_view_height) + @as(c_int, 1)) > @as(c_int, 1)) (curbuf.*.b_ml.ml_line_count - curwin.*.w_view_height) + @as(c_int, 1) else @as(c_int, 1);
    _ = &topline;
    if (topline != curwin.*.w_topline) {
        set_topline(curwin, topline);
    }
    var off: c_int = if (@as(c_int, @intFromBool(is_focused(term))) != 0) @as(c_int, 0) else if (curwin.*.w_onebuf_opt.wo_rl != 0) @as(c_int, 1) else -@as(c_int, 1);
    _ = &off;
    _ = coladvance(curwin, if (@as(c_int, 0) > (term.*.cursor.col + off)) @as(c_int, 0) else term.*.cursor.col + off);
}
pub fn terminal_check_focus(s: [*c]TerminalState) callconv(.c) bool {
    _ = &s;
    if (curbuf.*.terminal == @as([*c]Terminal, @ptrCast(@alignCast(@as(?*anyopaque, @ptrFromInt(@as(c_int, 0))))))) {
        return @as(c_int, 0) != 0;
    }
    if (s.*.save_curwin_handle != curwin.*.handle) {
        unset_terminal_winopts(s);
        set_terminal_winopts(s);
    }
    if (s.*.term != curbuf.*.terminal) {
        terminal_focus(s.*.term, @as(c_int, 0) != 0);
        s.*.term = curbuf.*.terminal;
        s.*.term.*.pending.cursor = @as(c_int, 1) != 0;
        invalidate_terminal(s.*.term, -@as(c_int, 1), -@as(c_int, 1));
        terminal_focus(s.*.term, @as(c_int, 1) != 0);
    }
    return @as(c_int, 1) != 0;
}
pub fn terminal_check(arg_state: [*c]VimState) callconv(.c) c_int {
    var state = arg_state;
    _ = &state;
    const s: [*c]TerminalState = @as([*c]TerminalState, @ptrCast(@alignCast(state)));
    _ = &s;
    if ((@as(c_int, @intFromBool(stop_insert_mode)) != 0) or !terminal_check_focus(s)) {
        return 0;
    }
    terminal_check_cursor();
    validate_cursor(curwin);
    s.*.term.*.refcount +%= 1;
    if ((@as(c_int, @intFromBool(has_event(@as(c_uint, @bitCast(EVENT_TEXTCHANGEDT))))) != 0) and (curbuf.*.b_last_changedtick_i != buf_get_changedtick(curbuf))) {
        _ = apply_autocmds(@as(c_uint, @bitCast(EVENT_TEXTCHANGEDT)), null, null, @as(c_int, 0) != 0, curbuf);
        curbuf.*.b_last_changedtick_i = buf_get_changedtick(curbuf);
    }
    may_trigger_win_scrolled_resized();
    s.*.term.*.refcount -%= 1;
    if (s.*.term.*.buf_handle == @as(c_int, 0)) {
        s.*.close = @as(c_int, 1) != 0;
        return 0;
    }
    if (!terminal_check_focus(s)) {
        return 0;
    }
    terminal_check_cursor();
    validate_cursor(curwin);
    show_cursor_info_later(@as(c_int, 0) != 0);
    if (must_redraw != 0) {
        _ = update_screen();
    } else {
        redraw_statuslines();
        if (((@as(c_int, @intFromBool(clear_cmdline)) != 0) or (@as(c_int, @intFromBool(redraw_cmdline)) != 0)) or (@as(c_int, @intFromBool(redraw_mode)) != 0)) {
            _ = showmode();
        }
    }
    setcursor();
    refresh_cursor(s.*.term, &s.*.cursor_visible);
    ui_flush();
    return 1;
}
// src/nvim/macros_defs.h:110:25: warning: TODO implement translation of stmt class AttributedStmtClass

// src/nvim/terminal.c:943:12: warning: unable to translate function, demoted to extern
pub fn terminal_execute(arg_state: [*c]VimState, arg_key: c_int) callconv(.c) c_int {
    _ = arg_state;
    _ = arg_key;
    @panic("terminal_execute unimplemented");
    //   TerminalState *s = (TerminalState *)state;
    //
    //   // Check for certain control keys like Ctrl-C and Ctrl-\. We still send the
    //   // unmerged key and modifiers to the terminal.
    //   int tmp_mod_mask = mod_mask;
    //   int mod_key = merge_modifiers(key, &tmp_mod_mask);
    //
    //   switch (mod_key) {
    //   case K_LEFTMOUSE:
    //   case K_LEFTDRAG:
    //   case K_LEFTRELEASE:
    //   case K_MIDDLEMOUSE:
    //   case K_MIDDLEDRAG:
    //   case K_MIDDLERELEASE:
    //   case K_RIGHTMOUSE:
    //   case K_RIGHTDRAG:
    //   case K_RIGHTRELEASE:
    //   case K_X1MOUSE:
    //   case K_X1DRAG:
    //   case K_X1RELEASE:
    //   case K_X2MOUSE:
    //   case K_X2DRAG:
    //   case K_X2RELEASE:
    //   case K_MOUSEDOWN:
    //   case K_MOUSEUP:
    //   case K_MOUSELEFT:
    //   case K_MOUSERIGHT:
    //   case K_MOUSEMOVE:
    //     if (send_mouse_event(s->term, key)) {
    //       return 0;
    //     }
    //     break;
    //
    //   case K_PASTE_START:
    //     paste_repeat(1);
    //     break;
    //
    //   case K_EVENT:
    //     // We cannot let an event free the terminal yet. It is still needed.
    //     s->term->refcount++;
    //     state_handle_k_event();
    //     s->term->refcount--;
    //     if (s->term->buf_handle == 0) {
    //       s->close = true;
    //       return 0;
    //     }
    //     break;
    //
    //   case K_COMMAND:
    //     do_cmdline(NULL, getcmdkeycmd, NULL, 0);
    //     break;
    //
    //   case K_LUA:
    //     map_execute_lua(false, false);
    //     break;
    //
    //   case Ctrl_N:
    //     if (s->got_bsl) {
    //       return 0;
    //     }
    //     FALLTHROUGH;
    //
    //   case Ctrl_O:
    //     if (s->got_bsl) {
    //       s->got_bsl_o = true;
    //       restart_edit = 'I';
    //       return 0;
    //     }
    //     FALLTHROUGH;
    //
    //   default:
    //     if (mod_key == Ctrl_C) {
    //       // terminal_enter() always sets `mapped_ctrl_c` to avoid `got_int`. 8eeda7169aa4
    //       // But `got_int` may be set elsewhere, e.g. by interrupt() or an autocommand,
    //       // so ensure that it is cleared.
    //       got_int = false;
    //     }
    //     if (mod_key == Ctrl_BSL && !s->got_bsl) {
    //       s->got_bsl = true;
    //       break;
    //     }
    //     if (s->term->closed) {
    //       s->close = true;
    //       return 0;
    //     }
    //
    //     s->got_bsl = false;
    //     terminal_send_key(s->term, key);
    //   }
    //
    //   return 1;
}

pub fn terminal_send(arg_term: [*c]Terminal, arg_data: [*c]const u8, arg_size: usize) callconv(.c) void {
    // TODO: complete rewrite. disgusting.
    var term = arg_term;
    _ = &term;
    var data = arg_data;
    _ = &data;
    var size = arg_size;
    _ = &size;
    if (term.*.closed) {
        return;
    }
    if (term.*.pending.send != null) {
        if (size > @as(usize, @bitCast(@as(c_long, @as(c_int, 0))))) {
            while (true) {
                if (term.*.pending.send.*.capacity < (term.*.pending.send.*.size +% size)) {
                    term.*.pending.send.*.capacity = term.*.pending.send.*.size +% size;
                    _ = blk: {
                        _ = blk_1: {
                            _ = blk_2: {
                                const ref = &term.*.pending.send.*.capacity;
                                ref.* -%= 1;
                                break :blk_2 ref.*;
                            };
                            break :blk_1 blk_2: {
                                _ = blk_3: {
                                    _ = blk_4: {
                                        _ = blk_5: {
                                            term.*.pending.send.*.capacity |= term.*.pending.send.*.capacity >> @intCast(1);
                                            break :blk_5 blk_6: {
                                                const ref = &term.*.pending.send.*.capacity;
                                                ref.* |= term.*.pending.send.*.capacity >> @intCast(2);
                                                break :blk_6 ref.*;
                                            };
                                        };
                                        break :blk_4 blk_5: {
                                            const ref = &term.*.pending.send.*.capacity;
                                            ref.* |= term.*.pending.send.*.capacity >> @intCast(4);
                                            break :blk_5 ref.*;
                                        };
                                    };
                                    break :blk_3 blk_4: {
                                        const ref = &term.*.pending.send.*.capacity;
                                        ref.* |= term.*.pending.send.*.capacity >> @intCast(8);
                                        break :blk_4 ref.*;
                                    };
                                };
                                break :blk_2 blk_3: {
                                    const ref = &term.*.pending.send.*.capacity;
                                    ref.* |= term.*.pending.send.*.capacity >> @intCast(16);
                                    break :blk_3 ref.*;
                                };
                            };
                        };
                        break :blk blk_1: {
                            const ref = &term.*.pending.send.*.capacity;
                            ref.* +%= 1;
                            break :blk_1 ref.*;
                        };
                    };
                    _ = blk: {
                        term.*.pending.send.*.capacity = term.*.pending.send.*.capacity;
                        break :blk blk_1: {
                            const tmp = @as([*c]u8, @ptrCast(@alignCast(xrealloc(@as(?*anyopaque, @ptrCast(term.*.pending.send.*.items)), @sizeOf(u8) *% term.*.pending.send.*.capacity))));
                            term.*.pending.send.*.items = tmp;
                            break :blk_1 tmp;
                        };
                    };
                }
                if (!false) break;
            }
            _ = blk: {
                _ = @sizeOf(c_int);
                break :blk blk_1: {
                    break :blk_1 if (term.*.pending.send.*.items != null) {} else {
                        c.__assert_fail("(*term->pending.send).items", "src/nvim/terminal.c", @as(c_uint, @bitCast(@as(c_int, 1079))), "void terminal_send(Terminal *, const char *, size_t)");
                    };
                };
            };
            _ = memcpy(@as(?*anyopaque, @ptrCast(term.*.pending.send.*.items + term.*.pending.send.*.size)), @as(?*const anyopaque, @ptrCast(data)), @sizeOf(u8) *% size);
            term.*.pending.send.*.size = term.*.pending.send.*.size +% size;
        }
        return;
    }
    term.*.opts.write_cb.?(data, size, term.*.opts.data);
}
pub fn is_filter_char(arg_c: c_int) callconv(.c) bool {
    var ch = arg_c;
    _ = &ch;
    var flag: c_uint = 0;
    _ = &flag;
    while (true) {
        switch (ch) {
            @as(c_int, 8) => {
                flag = @as(c_uint, @bitCast(kOptTpfFlagBS));
                break;
            },
            @as(c_int, 9) => {
                flag = @as(c_uint, @bitCast(kOptTpfFlagHT));
                break;
            },
            @as(c_int, 10), @as(c_int, 13) => break,
            @as(c_int, 12) => {
                flag = @as(c_uint, @bitCast(kOptTpfFlagFF));
                break;
            },
            @as(c_int, 27) => {
                flag = @as(c_uint, @bitCast(kOptTpfFlagESC));
                break;
            },
            @as(c_int, 127) => {
                flag = @as(c_uint, @bitCast(kOptTpfFlagDEL));
                break;
            },
            else => {
                if (ch < @as(c_int, ' ')) {
                    flag = @as(c_uint, @bitCast(kOptTpfFlagC0));
                } else if ((ch >= @as(c_int, 128)) and (ch <= @as(c_int, 159))) {
                    flag = @as(c_uint, @bitCast(kOptTpfFlagC1));
                }
            },
        }
        break;
    }
    return !!((tpf_flags & flag) != 0);
}
pub fn terminal_send_key(arg_term: [*c]Terminal, arg_c: c_int) callconv(.c) void {
    var term = arg_term;
    _ = &term;
    var ch = arg_c;
    _ = &ch;
    var mod: VTermModifier = @as(c_uint, @bitCast(VTERM_MOD_NONE));
    _ = &mod;
    if (ch == -(@as(c_int, 255) + (@as(c_int, 'X') << @intCast(8)))) {
        ch = 0;
    }
    var key: VTermKey = convert_key(&ch, &mod);
    _ = &key;
    if (key != @as(c_uint, @bitCast(VTERM_KEY_NONE))) {
        vterm_keyboard_key(term.*.vt, key, mod);
    } else if (!(ch < @as(c_int, 0))) {
        vterm_keyboard_unichar(term.*.vt, @as(u32, @bitCast(ch)), mod);
    }
}
pub fn get_rgb(arg_state: ?*VTermState, arg_color: VTermColor) callconv(.c) c_int {
    var state = arg_state;
    _ = &state;
    var color = arg_color;
    _ = &color;
    vterm_state_convert_color_to_rgb(state, &color);
    return ((@as(c_int, @bitCast(@as(c_uint, color.rgb.red))) << @intCast(16)) | (@as(c_int, @bitCast(@as(c_uint, color.rgb.green))) << @intCast(8))) | @as(c_int, @bitCast(@as(c_uint, color.rgb.blue)));
}
pub fn get_underline_hl_flag(arg_attrs: VTermScreenCellAttrs) callconv(.c) c_int {
    var attrs = arg_attrs;
    _ = &attrs;
    while (true) {
        switch (attrs.underline) {
            0 => return 0,
            1 => return HL_UNDERLINE,
            2 => return HL_UNDERDOUBLE,
            3 => return HL_UNDERCURL,
        }
        break;
    }
    return 0;
}
pub fn terminal_focus(arg_term: [*c]const Terminal, arg_focus: bool) callconv(.c) void {
    var term = arg_term;
    _ = &term;
    var focus = arg_focus;
    _ = &focus;
    var state: ?*VTermState = vterm_obtain_state(term.*.vt);
    _ = &state;
    if (focus) {
        vterm_state_focus_in(state);
    } else {
        vterm_state_focus_out(state);
    }
}
pub fn term_damage(arg_rect: VTermRect, arg_data: ?*anyopaque) callconv(.c) c_int {
    var rect = arg_rect;
    _ = &rect;
    var data = arg_data;
    _ = &data;
    invalidate_terminal(@as([*c]Terminal, @ptrCast(@alignCast(data))), rect.start_row, rect.end_row);
    return 1;
}
pub fn term_moverect(arg_dest: VTermRect, arg_src: VTermRect, arg_data: ?*anyopaque) callconv(.c) c_int {
    var dest = arg_dest;
    _ = &dest;
    var src = arg_src;
    _ = &src;
    var data = arg_data;
    _ = &data;
    invalidate_terminal(@as([*c]Terminal, @ptrCast(@alignCast(data))), if (dest.start_row < src.start_row) dest.start_row else src.start_row, if (dest.end_row > src.end_row) dest.end_row else src.end_row);
    return 1;
}
pub fn term_movecursor(arg_new_pos: VTermPos, arg_old_pos: VTermPos, arg_visible: c_int, arg_data: ?*anyopaque) callconv(.c) c_int {
    var new_pos = arg_new_pos;
    _ = &new_pos;
    var old_pos = arg_old_pos;
    _ = &old_pos;
    var visible = arg_visible;
    _ = &visible;
    var data = arg_data;
    _ = &data;
    var term: [*c]Terminal = @as([*c]Terminal, @ptrCast(@alignCast(data)));
    _ = &term;
    term.*.cursor.row = new_pos.row;
    term.*.cursor.col = new_pos.col;
    invalidate_terminal(term, -@as(c_int, 1), -@as(c_int, 1));
    return 1;
}
pub fn buf_set_term_title(arg_buf: [*c]buf_T, arg_title: [*c]const u8, arg_len: usize) callconv(.c) void {
    var buf = arg_buf;
    _ = &buf;
    var title = arg_title;
    _ = &title;
    var len = arg_len;
    _ = &len;
    var err: Error = Error{
        .type = kErrorTypeNone,
        .msg = null,
    };
    _ = &err;
    _ = dict_set_var(buf.*.b_vars, String{
        .data = @as([*c]u8, @ptrCast(@constCast(@volatileCast("term_title")))),
        .size = @sizeOf([11]u8) -% @as(c_ulong, @bitCast(@as(c_long, @as(c_int, 1)))),
    }, Object{
        .type = @as(c_uint, @bitCast(kObjectTypeString)),
        .data = .{
            .string = String{
                .data = @as([*c]u8, @ptrCast(@constCast(@volatileCast(title)))),
                .size = len,
            },
        },
    }, @as(c_int, 0) != 0, @as(c_int, 0) != 0, null, &err);
    api_clear_error(&err);
    status_redraw_buf(buf);
}
// src/nvim/terminal.c:1378:25: warning: local variable has opaque type

// src/nvim/terminal.c:1363:12: warning: unable to translate function, demoted to extern
pub extern fn term_settermprop(arg_prop: VTermProp, arg_val: ?*VTermValue, arg_data: ?*anyopaque) callconv(.c) c_int;
pub fn term_bell(arg_data: ?*anyopaque) callconv(.c) c_int {
    var data = arg_data;
    _ = &data;
    vim_beep(@as(c_uint, @bitCast(kOptBoFlagTerm)));
    return 1;
}
pub fn term_theme(arg_dark: [*c]bool, arg_data: ?*anyopaque) callconv(.c) c_int {
    var dark = arg_dark;
    _ = &dark;
    var data = arg_data;
    _ = &data;
    dark.* = @as(c_int, @bitCast(@as(c_uint, p_bg.*))) == @as(c_int, 'd');
    return 1;
}
pub fn term_sb_push(arg_cols: c_int, arg_cells: ?*const VTermScreenCell, arg_data: ?*anyopaque) callconv(.c) c_int {
    var cols = arg_cols;
    _ = &cols;
    var cells = arg_cells;
    _ = &cells;
    var data = arg_data;
    _ = &data;
    var term: [*c]Terminal = @as([*c]Terminal, @ptrCast(@alignCast(data)));
    _ = &term;
    if (!(term.*.sb_size != 0)) {
        return 0;
    }
    // TODO: name
    var ct: usize = @as(usize, @bitCast(@as(c_long, cols)));
    _ = &ct;
    var sbrow: [*c]ScrollbackLine = null;
    _ = &sbrow;
    if (term.*.sb_current == term.*.sb_size) {
        if (term.*.sb_buffer[term.*.sb_current -% @as(usize, @bitCast(@as(c_long, @as(c_int, 1))))].*.cols == ct) {
            sbrow = term.*.sb_buffer[term.*.sb_current -% @as(usize, @bitCast(@as(c_long, @as(c_int, 1))))];
        } else {
            xfree(@as(?*anyopaque, @ptrCast(term.*.sb_buffer[term.*.sb_current -% @as(usize, @bitCast(@as(c_long, @as(c_int, 1))))])));
        }
        term.*.sb_deleted +%= 1;
        _ = memmove(@as(?*anyopaque, @ptrCast(term.*.sb_buffer + @as(usize, @bitCast(@as(isize, @intCast(@as(c_int, 1))))))), @as(?*const anyopaque, @ptrCast(term.*.sb_buffer)), @sizeOf([*c]ScrollbackLine) *% (term.*.sb_current -% @as(usize, @bitCast(@as(c_long, @as(c_int, 1))))));
    } else if (term.*.sb_current > @as(usize, @bitCast(@as(c_long, @as(c_int, 0))))) {
        _ = memmove(@as(?*anyopaque, @ptrCast(term.*.sb_buffer + @as(usize, @bitCast(@as(isize, @intCast(@as(c_int, 1))))))), @as(?*const anyopaque, @ptrCast(term.*.sb_buffer)), @sizeOf([*c]ScrollbackLine) *% term.*.sb_current);
    }
    if (!(sbrow != null)) {
        sbrow = @as([*c]ScrollbackLine, @ptrCast(@alignCast(xmalloc(@sizeOf(ScrollbackLine) +% (ct *% @sizeOf(VTermScreenCell))))));
        sbrow.*.cols = ct;
    }
    term.*.sb_buffer[@as(c_uint, @intCast(@as(c_int, 0)))] = sbrow;
    if (term.*.sb_current < term.*.sb_size) {
        term.*.sb_current +%= 1;
    }
    if (term.*.sb_pending < @as(c_int, @bitCast(@as(c_uint, @truncate(term.*.sb_size))))) {
        term.*.sb_pending += 1;
    }
    _ = memcpy(@as(?*anyopaque, @ptrCast(sbrow.*.cells())), @as(?*const anyopaque, @ptrCast(cells)), @sizeOf(VTermScreenCell) *% ct);
    _ = set_put_ptr_t(&invalidated_terminals, @as(ptr_t, @ptrCast(term)), null);
    return 1;
}
pub fn term_sb_pop(arg_cols: c_int, arg_cells: ?*VTermScreenCell, arg_data: ?*anyopaque) callconv(.c) c_int {
    var cols = arg_cols;
    _ = &cols;
    const cells = @as(?[*]VTermScreenCell, @ptrCast(arg_cells));
    var data = arg_data;
    _ = &data;
    var term: [*c]Terminal = @as([*c]Terminal, @ptrCast(@alignCast(data)));
    _ = &term;
    if (!(term.*.sb_current != 0)) {
        return 0;
    }
    if (term.*.sb_pending != 0) {
        term.*.sb_pending -= 1;
    }
    var sbrow: [*c]ScrollbackLine = term.*.sb_buffer[@as(c_uint, @intCast(@as(c_int, 0)))];
    _ = &sbrow;
    term.*.sb_current -%= 1;
    _ = memmove(@as(?*anyopaque, @ptrCast(term.*.sb_buffer)), @as(?*const anyopaque, @ptrCast(term.*.sb_buffer + @as(usize, @bitCast(@as(isize, @intCast(@as(c_int, 1))))))), @sizeOf([*c]ScrollbackLine) *% term.*.sb_current);
    var cols_to_copy: usize = if (@as(usize, @bitCast(@as(c_long, cols))) < sbrow.*.cols) @as(usize, @bitCast(@as(c_long, cols))) else sbrow.*.cols;
    _ = &cols_to_copy;
    _ = memcpy(@as(?*anyopaque, @ptrCast(cells)), @as(?*const anyopaque, @ptrCast(sbrow.*.cells())), @sizeOf(VTermScreenCell) *% cols_to_copy);
    {
        var col: usize = cols_to_copy;
        _ = &col;
        if (cells) |cs| {
            while (col < @as(usize, @bitCast(@as(c_long, cols)))) : (col +%= 1) {
                cs[col].schar = 0;
                cs[col].width = 1;
            }
        }
    }
    xfree(@as(?*anyopaque, @ptrCast(sbrow)));
    _ = set_put_ptr_t(&invalidated_terminals, @as(ptr_t, @ptrCast(term)), null);
    return 1;
}
pub fn term_clipboard_set(arg_argv: [*c]?*anyopaque) callconv(.c) void {
    var argv = arg_argv;
    _ = &argv;
    var mask: VTermSelectionMask = @as(c_uint, @bitCast(@as(c_int, @truncate(@as(c_long, @intCast(@intFromPtr(argv[@as(c_uint, @intCast(@as(c_int, 0)))])))))));
    _ = &mask;
    var data: [*c]u8 = @as([*c]u8, @ptrCast(@alignCast(argv[@as(c_uint, @intCast(@as(c_int, 1)))])));
    _ = &data;
    var regname: u8 = undefined;
    _ = &regname;
    while (true) {
        switch (mask) {
            @as(c_uint, @bitCast(@as(c_int, 1))) => {
                regname = '+';
                break;
            },
            @as(c_uint, @bitCast(@as(c_int, 2))) => {
                regname = '*';
                break;
            },
            else => {
                regname = '+';
                break;
            },
        }
        break;
    }
    var lines: [*c]list_T = tv_list_alloc(@as(ptrdiff_t, @bitCast(@as(c_long, @as(c_int, 1)))));
    _ = &lines;
    tv_list_append_allocated_string(lines, data);
    var args: [*c]list_T = tv_list_alloc(@as(ptrdiff_t, @bitCast(@as(c_long, @as(c_int, 3)))));
    _ = &args;
    tv_list_append_list(args, lines);
    const regtype: u8 = 'v';
    _ = &regtype;
    tv_list_append_string(args, &regtype, @as(isize, @bitCast(@as(c_long, @as(c_int, 1)))));
    tv_list_append_string(args, &regname, @as(isize, @bitCast(@as(c_long, @as(c_int, 1)))));
    _ = eval_call_provider(@as([*c]u8, @ptrCast(@constCast(@volatileCast("clipboard")))), @as([*c]u8, @ptrCast(@constCast(@volatileCast("set")))), args, @as(c_int, 1) != 0);
}
pub fn term_selection_set(arg_mask: VTermSelectionMask, arg_frag: VTermStringFragment, arg_user: ?*anyopaque) callconv(.c) c_int {
    var mask = arg_mask;
    _ = &mask;
    var frag = arg_frag;
    _ = &frag;
    var user = arg_user;
    _ = &user;
    var term: [*c]Terminal = @as([*c]Terminal, @ptrCast(@alignCast(user)));
    _ = &term;
    if (frag.initial) {
        term.*.selection.size = 0;
    }
    if (frag.len > 0) {
        while (true) {
            if (term.*.selection.capacity < (term.*.selection.size +% frag.len)) {
                term.*.selection.capacity = term.*.selection.size +% frag.len;
                _ = blk: {
                    _ = blk_1: {
                        _ = blk_2: {
                            const ref = &term.*.selection.capacity;
                            ref.* -%= 1;
                            break :blk_2 ref.*;
                        };
                        break :blk_1 blk_2: {
                            _ = blk_3: {
                                _ = blk_4: {
                                    _ = blk_5: {
                                        term.*.selection.capacity |= term.*.selection.capacity >> @intCast(1);
                                        break :blk_5 blk_6: {
                                            const ref = &term.*.selection.capacity;
                                            ref.* |= term.*.selection.capacity >> @intCast(2);
                                            break :blk_6 ref.*;
                                        };
                                    };
                                    break :blk_4 blk_5: {
                                        const ref = &term.*.selection.capacity;
                                        ref.* |= term.*.selection.capacity >> @intCast(4);
                                        break :blk_5 ref.*;
                                    };
                                };
                                break :blk_3 blk_4: {
                                    const ref = &term.*.selection.capacity;
                                    ref.* |= term.*.selection.capacity >> @intCast(8);
                                    break :blk_4 ref.*;
                                };
                            };
                            break :blk_2 blk_3: {
                                const ref = &term.*.selection.capacity;
                                ref.* |= term.*.selection.capacity >> @intCast(16);
                                break :blk_3 ref.*;
                            };
                        };
                    };
                    break :blk blk_1: {
                        const ref = &term.*.selection.capacity;
                        ref.* +%= 1;
                        break :blk_1 ref.*;
                    };
                };
                _ = blk: {
                    term.*.selection.capacity = term.*.selection.capacity;
                    break :blk blk_1: {
                        const tmp = @as([*c]u8, @ptrCast(@alignCast(xrealloc(@as(?*anyopaque, @ptrCast(term.*.selection.items)), @sizeOf(u8) *% term.*.selection.capacity))));
                        term.*.selection.items = tmp;
                        break :blk_1 tmp;
                    };
                };
            }
            if (!false) break;
        }
        _ = blk: {
            _ = @sizeOf(c_int);
            break :blk blk_1: {
                break :blk_1 if (term.*.selection.items != null) {} else {
                    c.__assert_fail("(term->selection).items", "src/nvim/terminal.c", @as(c_uint, @bitCast(@as(c_int, 1577))), "int term_selection_set(VTermSelectionMask, VTermStringFragment, void *)");
                };
            };
        };
        _ = memcpy(
            @as(?*anyopaque, @ptrCast(term.*.selection.items + term.*.selection.size)),
            @as(?*const anyopaque, @ptrCast(frag.str)),
            @sizeOf(u8) *% @as(c_ulong, @intCast(frag.len)),
        );
        term.*.selection.size = term.*.selection.size +% frag.len;
    }
    if (frag.final) {
        var data: [*c]u8 = @as([*c]u8, @ptrCast(@alignCast(xmemdupz(@as(?*const anyopaque, @ptrCast(term.*.selection.items)), term.*.selection.size))));
        _ = &data;
        while (true) {
            multiqueue_put_event(main_loop.events, Event{
                .handler = &term_clipboard_set,
                .argv = [2]?*anyopaque{
                    @as(?*anyopaque, @ptrFromInt(mask)),
                    @as(?*anyopaque, @ptrCast(data)),
                } ++ [1]?*anyopaque{null} ** 8,
            });
            if (!false) break;
        }
    }
    return 1;
}
pub fn convert_modifiers(arg_key: [*c]c_int, arg_statep: [*c]VTermModifier) callconv(.c) void {
    var key = arg_key;
    _ = &key;
    var statep = arg_statep;
    _ = &statep;
    if ((mod_mask & @as(c_int, 2)) != 0) {
        statep.* |= @as(c_uint, @bitCast(VTERM_MOD_SHIFT));
    }
    if ((mod_mask & @as(c_int, 4)) != 0) {
        statep.* |= @as(c_uint, @bitCast(VTERM_MOD_CTRL));
        if ((!((mod_mask & @as(c_int, 2)) != 0) and (key.* >= @as(c_int, 'A'))) and (key.* <= @as(c_int, 'Z'))) {
            key.* += @as(c_int, 'a') - @as(c_int, 'A');
        }
    }
    if ((mod_mask & @as(c_int, 8)) != 0) {
        statep.* |= @as(c_uint, @bitCast(VTERM_MOD_ALT));
    }
    while (true) {
        switch (key.*) {
            @as(c_int, -17003), @as(c_int, -1277), @as(c_int, -1533), @as(c_int, -13347), @as(c_int, -26917), @as(c_int, -12835), @as(c_int, -14122), @as(c_int, -1789), @as(c_int, -2045), @as(c_int, -2301), @as(c_int, -2557), @as(c_int, -2813), @as(c_int, -3069), @as(c_int, -3325), @as(c_int, -3581), @as(c_int, -3837), @as(c_int, -4093), @as(c_int, -4349), @as(c_int, -4605) => {
                statep.* |= @as(c_uint, @bitCast(VTERM_MOD_SHIFT));
                break;
            },
            @as(c_int, -22013), @as(c_int, -22269), @as(c_int, -22525), @as(c_int, -22781) => {
                statep.* |= @as(c_uint, @bitCast(VTERM_MOD_CTRL));
                break;
            },
            else => {},
        }
        break;
    }
}
// src/nvim/macros_defs.h:110:25: warning: TODO implement translation of stmt class AttributedStmtClass

// src/nvim/terminal.c:1638:17: warning: unable to translate function, demoted to extern
pub extern fn convert_key(arg_key: [*c]c_int, arg_statep: [*c]VTermModifier) callconv(.c) VTermKey;
pub fn mouse_action(arg_term: [*c]Terminal, arg_button: c_int, arg_row: c_int, arg_col: c_int, arg_pressed: bool, arg_mod: VTermModifier) callconv(.c) void {
    var term = arg_term;
    _ = &term;
    var button = arg_button;
    _ = &button;
    var row = arg_row;
    _ = &row;
    var col = arg_col;
    _ = &col;
    var pressed = arg_pressed;
    _ = &pressed;
    var mod = arg_mod;
    _ = &mod;
    vterm_mouse_move(term.*.vt, row, col, mod);
    if (button != 0) {
        vterm_mouse_button(term.*.vt, button, pressed, mod);
    }
}
// src/nvim/terminal.c:1926:5: warning: TODO implement translation of stmt class GotoStmtClass

// src/nvim/terminal.c:1919:13: warning: unable to translate function, demoted to extern
pub extern fn send_mouse_event(arg_term: [*c]Terminal, arg_c: c_int) callconv(.c) bool;
// src/nvim/terminal.c:2051:21: warning: local variable has opaque type

// src/nvim/terminal.c:2044:13: warning: unable to translate function, demoted to extern
pub extern fn fetch_row(arg_term: [*c]Terminal, arg_row: c_int, arg_end_col: c_int) callconv(.c) void;
// src/nvim/terminal.c:2071:7: warning: cannot dereference opaque type

// src/nvim/terminal.c:2066:13: warning: unable to translate function, demoted to extern
pub extern fn fetch_cell(arg_term: [*c]Terminal, arg_row: c_int, arg_col: c_int, arg_cell: ?*VTermScreenCell) callconv(.c) bool;
pub fn invalidate_terminal(arg_term: [*c]Terminal, arg_start_row: c_int, arg_end_row: c_int) callconv(.c) void {
    var term = arg_term;
    _ = &term;
    var start_row = arg_start_row;
    _ = &start_row;
    var end_row = arg_end_row;
    _ = &end_row;
    if ((start_row != -@as(c_int, 1)) and (end_row != -@as(c_int, 1))) {
        term.*.invalid_start = if (term.*.invalid_start < start_row) term.*.invalid_start else start_row;
        term.*.invalid_end = if (term.*.invalid_end > end_row) term.*.invalid_end else end_row;
    }
    _ = set_put_ptr_t(&invalidated_terminals, @as(ptr_t, @ptrCast(term)), null);
    if (!refresh_pending) {
        time_watcher_start(term_refresh_timer(), &refresh_timer_cb, @as(u64, @bitCast(@as(c_long, @as(c_int, 10)))), @as(u64, @bitCast(@as(c_long, @as(c_int, 0)))));
        refresh_pending = @as(c_int, 1) != 0;
    }
}
pub fn refresh_terminal(arg_term: [*c]Terminal) callconv(.c) void {
    var term = arg_term;
    _ = &term;
    var buf: [*c]buf_T = @as([*c]buf_T, @ptrCast(@alignCast(map_get_intptr_t(&buffer_handles, term.*.buf_handle))));
    _ = &buf;
    var valid: bool = @as(c_int, 1) != 0;
    _ = &valid;
    if (!(buf != null) or !(blk: {
        const tmp = buf_valid(buf);
        valid = tmp;
        break :blk tmp;
    })) {
        if (!valid) {
            term.*.buf_handle = 0;
        }
        return;
    }
    var ml_before: linenr_T = buf.*.b_ml.ml_line_count;
    _ = &ml_before;
    refresh_size(term, buf);
    refresh_scrollback(term, buf);
    refresh_screen(term, buf);
    var ml_added: c_int = buf.*.b_ml.ml_line_count - ml_before;
    _ = &ml_added;
    adjust_topline_cursor(term, buf, ml_added);
    multiqueue_move_events(main_loop.events, term.*.pending.events);
}
pub fn refresh_cursor(arg_term: [*c]Terminal, arg_cursor_visible: [*c]bool) callconv(.c) void {
    var term = arg_term;
    _ = &term;
    var cursor_visible = arg_cursor_visible;
    _ = &cursor_visible;
    if (!is_focused(term)) {
        return;
    }
    if (@as(c_int, @intFromBool(term.*.cursor.visible)) != @as(c_int, @intFromBool(cursor_visible.*))) {
        cursor_visible.* = term.*.cursor.visible;
        if (cursor_visible.*) {
            ui_busy_stop();
        } else {
            ui_busy_start();
        }
    }
    if (!term.*.pending.cursor) {
        return;
    }
    term.*.pending.cursor = @as(c_int, 0) != 0;
    if (term.*.cursor.blink) {
        shape_table[@as(c_uint, @intCast(SHAPE_IDX_TERM))].blinkon = 500;
        shape_table[@as(c_uint, @intCast(SHAPE_IDX_TERM))].blinkoff = 500;
    } else {
        shape_table[@as(c_uint, @intCast(SHAPE_IDX_TERM))].blinkon = 0;
        shape_table[@as(c_uint, @intCast(SHAPE_IDX_TERM))].blinkoff = 0;
    }
    while (true) {
        switch (term.*.cursor.shape) {
            @as(c_int, 1) => {
                shape_table[@as(c_uint, @intCast(SHAPE_IDX_TERM))].shape = @as(c_uint, @bitCast(SHAPE_BLOCK));
                break;
            },
            @as(c_int, 2) => {
                shape_table[@as(c_uint, @intCast(SHAPE_IDX_TERM))].shape = @as(c_uint, @bitCast(SHAPE_HOR));
                shape_table[@as(c_uint, @intCast(SHAPE_IDX_TERM))].percentage = 20;
                break;
            },
            @as(c_int, 3) => {
                shape_table[@as(c_uint, @intCast(SHAPE_IDX_TERM))].shape = @as(c_uint, @bitCast(SHAPE_VER));
                shape_table[@as(c_uint, @intCast(SHAPE_IDX_TERM))].percentage = 25;
                break;
            },
            else => {},
        }
        break;
    }
    ui_mode_info_set();
}
pub fn refresh_timer_cb(arg_watcher: [*c]TimeWatcher, arg_data: ?*anyopaque) callconv(.c) void {
    var watcher = arg_watcher;
    _ = &watcher;
    var data = arg_data;
    _ = &data;
    refresh_pending = @as(c_int, 0) != 0;
    if (exiting) {
        return;
    }
    var term: [*c]Terminal = undefined;
    _ = &term;
    var stub: ?*anyopaque = undefined;
    _ = &stub;
    _ = &stub;
    block_autocmds();
    {
        var __i: u32 = undefined;
        _ = &__i;
        {
            __i = 0;
            while (__i < (&invalidated_terminals).*.h.n_keys) : (__i +%= 1) {
                term = @as([*c]Terminal, @ptrCast(@alignCast((&invalidated_terminals).*.keys[__i])));
                {
                    refresh_terminal(term);
                }
            }
        }
    }
    mh_clear(&(&invalidated_terminals).*.h);
    unblock_autocmds();
}
pub fn refresh_size(arg_term: [*c]Terminal, arg_buf: [*c]buf_T) callconv(.c) void {
    var term = arg_term;
    _ = &term;
    var buf = arg_buf;
    _ = &buf;
    if (!term.*.pending.resize or (@as(c_int, @intFromBool(term.*.closed)) != 0)) {
        return;
    }
    term.*.pending.resize = @as(c_int, 0) != 0;
    var width: c_int = undefined;
    _ = &width;
    var height: c_int = undefined;
    _ = &height;
    vterm_get_size(term.*.vt, &height, &width);
    term.*.invalid_start = 0;
    term.*.invalid_end = height;
    term.*.opts.resize_cb.?(@as(u16, @bitCast(@as(c_short, @truncate(width)))), @as(u16, @bitCast(@as(c_short, @truncate(height)))), term.*.opts.data);
}
pub fn adjust_scrollback(arg_term: [*c]Terminal, arg_buf: [*c]buf_T) callconv(.c) void {
    var term = arg_term;
    _ = &term;
    var buf = arg_buf;
    _ = &buf;
    if (buf.*.b_p_scbk < @as(OptInt, @bitCast(@as(c_long, @as(c_int, 1))))) {
        buf.*.b_p_scbk = @as(OptInt, @bitCast(@as(c_long, @as(c_int, 1000000))));
    }
    const scbk: usize = @as(usize, @bitCast(buf.*.b_p_scbk));
    _ = &scbk;
    _ = blk: {
        _ = @sizeOf(c_int);
        break :blk blk_1: {
            break :blk_1 if (term.*.sb_current < @as(c_ulong, 18446744073709551615)) {} else {
                c.__assert_fail("term->sb_current < SIZE_MAX", "src/nvim/terminal.c", @as(c_uint, @bitCast(@as(c_int, 2221))), "void adjust_scrollback(Terminal *, buf_T *)");
            };
        };
    };
    if (term.*.sb_pending > @as(c_int, 0)) {
        abort();
    }
    if (scbk < term.*.sb_current) {
        var diff: usize = term.*.sb_current -% scbk;
        _ = &diff;
        {
            var i: usize = 0;
            _ = &i;
            while (i < diff) : (i +%= 1) {
                _ = ml_delete_buf(buf, @as(c_int, 1), @as(c_int, 0) != 0);
                term.*.sb_current -%= 1;
                xfree(@as(?*anyopaque, @ptrCast(term.*.sb_buffer[term.*.sb_current])));
            }
        }
        mark_adjust_buf(buf, @as(c_int, 1), @as(linenr_T, @bitCast(@as(c_uint, @truncate(diff)))), MAXLNUM, -@as(linenr_T, @bitCast(@as(c_uint, @truncate(diff)))), @as(c_int, 1) != 0, @as(c_uint, @bitCast(kMarkAdjustTerm)), @as(c_uint, @bitCast(kExtmarkUndo)));
        deleted_lines_buf(buf, @as(c_int, 1), @as(linenr_T, @bitCast(@as(c_uint, @truncate(diff)))));
    }
    var sb_region: usize = @sizeOf([*c]ScrollbackLine) *% scbk;
    _ = &sb_region;
    if (scbk != term.*.sb_size) {
        term.*.sb_buffer = @as([*c][*c]ScrollbackLine, @ptrCast(@alignCast(xrealloc(@as(?*anyopaque, @ptrCast(term.*.sb_buffer)), sb_region))));
    }
    term.*.sb_size = scbk;
}
pub fn refresh_scrollback(arg_term: [*c]Terminal, arg_buf: [*c]buf_T) callconv(.c) void {
    var term = arg_term;
    _ = &term;
    var buf = arg_buf;
    _ = &buf;
    var deleted: linenr_T = @as(linenr_T, @bitCast(@as(c_uint, @truncate(term.*.sb_deleted -% term.*.sb_deleted_last))));
    _ = &deleted;
    deleted = if (deleted < buf.*.b_ml.ml_line_count) deleted else buf.*.b_ml.ml_line_count;
    mark_adjust_buf(buf, @as(c_int, 1), deleted, MAXLNUM, -deleted, @as(c_int, 1) != 0, @as(c_uint, @bitCast(kMarkAdjustTerm)), @as(c_uint, @bitCast(kExtmarkUndo)));
    term.*.sb_deleted_last = term.*.sb_deleted;
    var width: c_int = undefined;
    _ = &width;
    var height: c_int = undefined;
    _ = &height;
    vterm_get_size(term.*.vt, &height, &width);
    var row_offset: c_int = term.*.sb_pending;
    _ = &row_offset;
    while ((term.*.sb_pending > @as(c_int, 0)) and (buf.*.b_ml.ml_line_count < height)) {
        fetch_row(term, (term.*.sb_pending - row_offset) - @as(c_int, 1), width);
        _ = ml_append_buf(buf, @as(c_int, 0), @as([*c]u8, @ptrCast(@alignCast(&term.*.textbuf[@as(usize, @intCast(0))]))), @as(c_int, 0), @as(c_int, 0) != 0);
        appended_lines_buf(buf, @as(c_int, 0), @as(c_int, 1));
        term.*.sb_pending -= 1;
    }
    row_offset -= term.*.sb_pending;
    while (term.*.sb_pending > @as(c_int, 0)) {
        if ((@as(c_int, @bitCast(buf.*.b_ml.ml_line_count)) - height) >= @as(c_int, @bitCast(@as(c_uint, @truncate(term.*.sb_size))))) {
            _ = ml_delete_buf(buf, @as(c_int, 1), @as(c_int, 0) != 0);
            deleted_lines_buf(buf, @as(c_int, 1), @as(c_int, 1));
        }
        fetch_row(term, -term.*.sb_pending - row_offset, width);
        var buf_index: c_int = @as(c_int, @bitCast(buf.*.b_ml.ml_line_count)) - height;
        _ = &buf_index;
        _ = ml_append_buf(buf, buf_index, @as([*c]u8, @ptrCast(@alignCast(&term.*.textbuf[@as(usize, @intCast(0))]))), @as(c_int, 0), @as(c_int, 0) != 0);
        appended_lines_buf(buf, buf_index, @as(c_int, 1));
        term.*.sb_pending -= 1;
    }
    var max_line_count: c_int = @as(c_int, @bitCast(@as(c_uint, @truncate(term.*.sb_current)))) + height;
    _ = &max_line_count;
    while (buf.*.b_ml.ml_line_count > max_line_count) {
        _ = ml_delete_buf(buf, buf.*.b_ml.ml_line_count, @as(c_int, 0) != 0);
        deleted_lines_buf(buf, buf.*.b_ml.ml_line_count, @as(c_int, 1));
    }
    adjust_scrollback(term, buf);
}
pub fn refresh_screen(arg_term: [*c]Terminal, arg_buf: [*c]buf_T) callconv(.c) void {
    var term = arg_term;
    _ = &term;
    var buf = arg_buf;
    _ = &buf;
    var changed_1: c_int = 0;
    _ = &changed_1;
    var added: c_int = 0;
    _ = &added;
    var height: c_int = undefined;
    _ = &height;
    var width: c_int = undefined;
    _ = &width;
    vterm_get_size(term.*.vt, &height, &width);
    term.*.invalid_end = if (term.*.invalid_end < height) term.*.invalid_end else height;
    if (term.*.invalid_start >= term.*.invalid_end) {
        term.*.invalid_start = 2147483647;
        term.*.invalid_end = -@as(c_int, 1);
        return;
    }
    {
        var r: c_int = term.*.invalid_start;
        _ = &r;
        var linenr: c_int = row_to_linenr(term, r);
        _ = &linenr;
        while (r < term.*.invalid_end) : (_ = blk: {
            r += 1;
            break :blk blk_1: {
                const ref = &linenr;
                const tmp = ref.*;
                ref.* += 1;
                break :blk_1 tmp;
            };
        }) {
            fetch_row(term, r, width);
            if (linenr <= buf.*.b_ml.ml_line_count) {
                _ = ml_replace_buf(buf, linenr, @as([*c]u8, @ptrCast(@alignCast(&term.*.textbuf[@as(usize, @intCast(0))]))), @as(c_int, 1) != 0, @as(c_int, 0) != 0);
                changed_1 += 1;
            } else {
                _ = ml_append_buf(buf, linenr - @as(c_int, 1), @as([*c]u8, @ptrCast(@alignCast(&term.*.textbuf[@as(usize, @intCast(0))]))), @as(c_int, 0), @as(c_int, 0) != 0);
                added += 1;
            }
        }
    }
    var change_start: c_int = row_to_linenr(term, term.*.invalid_start);
    _ = &change_start;
    var change_end: c_int = change_start + changed_1;
    _ = &change_end;
    changed_lines(buf, change_start, @as(c_int, 0), change_end, added, @as(c_int, 1) != 0);
    term.*.invalid_start = 2147483647;
    term.*.invalid_end = -@as(c_int, 1);
}
pub fn adjust_topline_cursor(arg_term: [*c]Terminal, arg_buf: [*c]buf_T, arg_added: c_int) callconv(.c) void {
    var term = arg_term;
    _ = &term;
    var buf = arg_buf;
    _ = &buf;
    var added = arg_added;
    _ = &added;
    var ml_end: linenr_T = buf.*.b_ml.ml_line_count;
    _ = &ml_end;
    {
        var tp: [*c]tabpage_T = first_tabpage;
        _ = &tp;
        while (tp != @as([*c]tabpage_T, @ptrCast(@alignCast(@as(?*anyopaque, @ptrFromInt(@as(c_int, 0))))))) : (tp = tp.*.tp_next) {
            var wp: [*c]win_T = if (tp == curtab) firstwin else tp.*.tp_firstwin;
            _ = &wp;
            while (wp != @as([*c]win_T, @ptrCast(@alignCast(@as(?*anyopaque, @ptrFromInt(@as(c_int, 0))))))) : (wp = wp.*.w_next) {
                if (wp.*.w_buffer == buf) {
                    if ((wp == curwin) and (@as(c_int, @intFromBool(is_focused(term))) != 0)) {
                        terminal_check_cursor();
                        continue;
                    }
                    var following: bool = ml_end == (wp.*.w_cursor.lnum + added);
                    _ = &following;
                    if (following) {
                        wp.*.w_cursor.lnum = ml_end;
                        set_topline(wp, if (((wp.*.w_cursor.lnum - wp.*.w_view_height) + @as(c_int, 1)) > @as(c_int, 1)) (wp.*.w_cursor.lnum - wp.*.w_view_height) + @as(c_int, 1) else @as(c_int, 1));
                    } else {
                        wp.*.w_cursor.lnum = if (wp.*.w_cursor.lnum < ml_end) wp.*.w_cursor.lnum else ml_end;
                    }
                    mb_check_adjust_col(@as(?*anyopaque, @ptrCast(wp)));
                }
            }
        }
    }
    if (ml_end == (buf.*.b_last_cursor.mark.lnum + added)) {
        buf.*.b_last_cursor.mark.lnum = ml_end;
    }
    {
        var i: usize = 0;
        _ = &i;
        while (i < buf.*.b_wininfo.size) : (i +%= 1) {
            var wip: [*c]WinInfo = buf.*.b_wininfo.items[i];
            _ = &wip;
            if (ml_end == (wip.*.wi_mark.mark.lnum + added)) {
                wip.*.wi_mark.mark.lnum = ml_end;
            }
        }
    }
}
pub fn row_to_linenr(arg_term: [*c]Terminal, arg_row: c_int) callconv(.c) c_int {
    var term = arg_term;
    _ = &term;
    var row = arg_row;
    _ = &row;
    return if (row != @as(c_int, 2147483647)) (row + @as(c_int, @bitCast(@as(c_uint, @truncate(term.*.sb_current))))) + @as(c_int, 1) else @as(c_int, 2147483647);
}
pub fn linenr_to_row(arg_term: [*c]Terminal, arg_linenr: c_int) callconv(.c) c_int {
    var term = arg_term;
    _ = &term;
    var linenr = arg_linenr;
    _ = &linenr;
    return (linenr - @as(c_int, @bitCast(@as(c_uint, @truncate(term.*.sb_current))))) - @as(c_int, 1);
}
pub fn is_focused(arg_term: [*c]Terminal) callconv(.c) bool {
    var term = arg_term;
    _ = &term;
    return ((State & MODE_TERMINAL) != 0) and (curbuf.*.terminal == term);
}
pub fn get_config_string(arg_key: [*c]u8) callconv(.c) [*c]u8 {
    var key = arg_key;
    _ = &key;
    var err: Error = Error{
        .type = kErrorTypeNone,
        .msg = null,
    };
    _ = &err;
    var obj: Object = dict_get_value(curbuf.*.b_vars, cstr_as_string(key), null, &err);
    _ = &obj;
    api_clear_error(&err);
    if (obj.type == @as(c_uint, @bitCast(kObjectTypeNil))) {
        obj = dict_get_value(get_globvar_dict(), cstr_as_string(key), null, &err);
        api_clear_error(&err);
    }
    if (obj.type == @as(c_uint, @bitCast(kObjectTypeString))) {
        return obj.data.string.data;
    }
    api_free_object(obj);
    return null;
}
// pub var refresh_timer: TimeWatcher = @import("std").mem.zeroes(TimeWatcher);
pub extern fn term_refresh_timer() callconv(.c) ?*TimeWatcher;
// pub extern var term_refresh_timer: TimeWatcher;
pub var refresh_pending: bool = @as(c_int, 0) != 0;
// pub const ScrollbackLine = extern struct {
//     cols: usize align(8) = @import("std").mem.zeroes(usize),
//     pub fn cells(self: anytype) @import("std").zig.c_translation.FlexibleArrayType(@TypeOf(self), VTermScreenCell) {
//         const Intermediate = @import("std").zig.c_translation.FlexibleArrayType(@TypeOf(self), u8);
//         const ReturnType = @import("std").zig.c_translation.FlexibleArrayType(@TypeOf(self), VTermScreenCell);
//         return @as(ReturnType, @ptrCast(@alignCast(@as(Intermediate, @ptrCast(self)) + 8)));
//     }
// };
pub const ScrollbackLine = c.ScrollbackLine;
pub var vterm_screen_callbacks: VTermScreenCallbacks = VTermScreenCallbacks{
    .damage = &term_damage,
    .moverect = &term_moverect,
    .movecursor = &term_movecursor,
    .settermprop = &term_settermprop,
    .bell = &term_bell,
    .resize = null,
    .theme = &term_theme,
    .sb_pushline = &term_sb_push,
    .sb_popline = &term_sb_pop,
    .sb_clear = null,
};
pub var vterm_selection_callbacks: VTermSelectionCallbacks = VTermSelectionCallbacks{
    .set = &term_selection_set,
    .query = null,
};
pub var invalidated_terminals: Set_ptr_t = Set_ptr_t{
    .h = MapHash{
        .n_buckets = @as(u32, @bitCast(@as(c_int, 0))),
        .size = @as(u32, @bitCast(@as(c_int, 0))),
        .n_occupied = @as(u32, @bitCast(@as(c_int, 0))),
        .upper_bound = @as(u32, @bitCast(@as(c_int, 0))),
        .n_keys = @as(u32, @bitCast(@as(c_int, 0))),
        .keys_capacity = @as(u32, @bitCast(@as(c_int, 0))),
        .hash = null,
    },
    .keys = null,
};
pub var vterm_fallbacks: VTermStateFallbacks = VTermStateFallbacks{
    .control = null,
    .csi = null,
    .osc = &on_osc,
    .dcs = &on_dcs,
    .apc = &on_apc,
    .pm = null,
    .sos = null,
};
