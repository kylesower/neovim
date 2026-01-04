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
const log = @import("../root.zig").log;
const vterm_handler = @import("../root.zig").handler;
const Handler = vterm_handler.Handler;
const Stream = vterm_handler.Stream;

fn test_preserve_exit(e: [*]const u8) noreturn {
    _ = e;
    std.process.exit(1);
}

const builtin = @import("builtin");
// Don't feel like touching main.c so I can access preserve_exit in tests.
const preserve_exit = if (builtin.is_test) test_preserve_exit else c.preserve_exit;
const e_outofmem = c.e_outofmem;
pub const NUL = '\x00';

// // ================================================================================
// // VTERM INTERNAL
// // ================================================================================
// // #define ESC_S "\x1b"
// // #define INTERMED_MAX 16
// // #define CSI_ARGS_MAX 32
// // #define CSI_LEADER_MAX 16
// // #define BUFIDX_PRIMARY   0
// // #define BUFIDX_ALTSCREEN 1
pub const ESC_S = "\x1b";
pub const INTERMED_MAX = 16;
pub const CSI_ARGS_MAX = 32;
pub const CSI_LEADER_MAX = 16;
pub const BUFIDX_PRIMARY = 0;
pub const BUFIDX_ALTSCREEN = 1;
//
// // #define KEY_ENCODING_DISAMBIGUATE 0x1
// // #define KEY_ENCODING_REPORT_EVENTS 0x2
// // #define KEY_ENCODING_REPORT_ALTERNATE 0x4
// // #define KEY_ENCODING_REPORT_ALL_KEYS 0x8
// // #define KEY_ENCODING_REPORT_ASSOCIATED 0x10
// pub const KEY_ENCODING_DISAMBIGUATE = 0x1;
// pub const KEY_ENCODING_REPORT_EVENTS = 0x2;
// pub const KEY_ENCODING_REPORT_ALTERNATE = 0x4;
// pub const KEY_ENCODING_REPORT_ALL_KEYS = 0x8;
// pub const KEY_ENCODING_REPORT_ASSOCIATED = 0x10;
//
// // typedef struct VTermEncoding VTermEncoding;
// // struct VTermEncoding {
// //   void (*init)(VTermEncoding *enc, void *data);
// //   void (*decode)(VTermEncoding *enc, void *data, uint32_t cp[], int *cpi, int cplen,
// //                  const char bytes[], size_t *pos, size_t len);
// // };
// pub const VTermEncoding = extern struct {
//     init: ?*const fn (enc: ?*VTermEncoding, data: ?*anyopaque) callconv(.c) void,
//     decode: ?*const fn (
//         enc: ?*VTermEncoding,
//         data: ?*anyopaque,
//         cp: [*]u32,
//         cpi: *c_int,
//         cplen: c_int,
//         bytes: [*]const u8,
//         pos: *usize,
//         len: usize,
//     ) callconv(.c) void,
// };
//
// // // https://sw.kovidgoyal.net/kitty/keyboard-protocol/#progressive-enhancement
// // typedef struct VTermKeyEncodingFlags VTermKeyEncodingFlags;
// // struct VTermKeyEncodingFlags {
// //   bool disambiguate:1;
// //   bool report_events:1;
// //   bool report_alternate:1;
// //   bool report_all_keys:1;
// //   bool report_associated:1;
// // };
pub const VTermKeyEncodingFlags = packed struct {
    disambiguate: bool,
    report_events: bool,
    report_alternate: bool,
    report_all_keys: bool,
    report_associated: bool,
};
//
// // typedef struct {
// //   VTermEncoding *enc;
// //
// //   // This size should be increased if required by other stateful encodings
// //   char data[4 * sizeof(uint32_t)];
// // } VTermEncodingInstance;
// pub const VTermEncodingInstance = extern struct {
//     enc: ?*VTermEncoding,
//     data: [4 * @sizeOf(u32)]u8,
// };
//
// // struct VTermPen {
// //   VTermColor fg;
// //   VTermColor bg;
// //   int uri;
// //   unsigned bold:1;
// //   unsigned underline:2;
// //   unsigned italic:1;
// //   unsigned blink:1;
// //   unsigned reverse:1;
// //   unsigned conceal:1;
// //   unsigned strike:1;
// //   unsigned font:4;  // To store 0-9
// //   unsigned small:1;
// //   unsigned baseline:2;
// // };
// pub const VTermPen = extern struct {
//     fg: VTermColor,
//     bg: VTermColor,
//     uri: c_int,
//     bold: bool,
//     underline: u8, // was u2
//     italic: bool,
//     blink: bool,
//     reverse: bool,
//     conceal: bool,
//     strike: bool,
//     font: u8, // was u4
//     small: bool,
//     baseline: u8, // was u2
// };
//
// // struct VTermKeyEncodingStack {
// //   VTermKeyEncodingFlags items[16];
// //   uint8_t size;  ///< Number of items in the stack. This is at least 1 and at
// //                  ///< most the length of the "items" array.
// // };
pub const VTermKeyEncodingStack = struct {
    items: [16]VTermKeyEncodingFlags,
    size: u8,
};
//
// // struct VTermState {
// //   VTerm *vt;
// //
// //   const VTermStateCallbacks *callbacks;
// //   void *cbdata;
// //
// //   const VTermStateFallbacks *fallbacks;
// //   void *fbdata;
// //
// //   int rows;
// //   int cols;
// //
// //   // Current cursor position
// //   VTermPos pos;
// //
// //   int at_phantom;  // True if we're on the "81st" phantom column to defer a wraparound
// //
// //   int scrollregion_top;
// //   int scrollregion_bottom;  // -1 means unbounded
// // #define SCROLLREGION_BOTTOM(state) ((state)->scrollregion_bottom > \
// //                                     -1 ? (state)->scrollregion_bottom : (state)->rows)
// //   int scrollregion_left;
// // #define SCROLLREGION_LEFT(state)  ((state)->mode.leftrightmargin ? (state)->scrollregion_left : 0)
// //   int scrollregion_right;  // -1 means unbounded
// // #define SCROLLREGION_RIGHT(state) ((state)->mode.leftrightmargin \
// //                                    && (state)->scrollregion_right > \
// //                                    -1 ? (state)->scrollregion_right : (state)->cols)
// //
// //   // Bitvector of tab stops
// //   uint8_t *tabstops;
// //
// //   // Primary and Altscreen; lineinfos[1] is lazily allocated as needed
// //   VTermLineInfo *lineinfos[2];
// //
// //   // lineinfo will == lineinfos[0] or lineinfos[1], depending on altscreen
// //   VTermLineInfo *lineinfo;
// // #define ROWWIDTH(state, \
// //                  row) ((state)->lineinfo[(row)].doublewidth ? ((state)->cols / 2) : (state)->cols)
// // #define THISROWWIDTH(state) ROWWIDTH(state, (state)->pos.row)
// //
// //   // Mouse state
// //   int mouse_col, mouse_row;
// //   int mouse_buttons;
// //   int mouse_flags;
// // #define MOUSE_WANT_CLICK 0x01
// // #define MOUSE_WANT_DRAG  0x02
// // #define MOUSE_WANT_MOVE  0x04
// //
// //   enum { MOUSE_X10, MOUSE_UTF8, MOUSE_SGR, MOUSE_RXVT, } mouse_protocol;
// //
// // // Last glyph output, for Unicode recombining purposes
// //   char grapheme_buf[MAX_SCHAR_SIZE];
// //   size_t grapheme_len;
// //   uint32_t grapheme_last;  // last added UTF-32 char
// //   GraphemeState grapheme_state;
// //   int combine_width;  // The width of the glyph above
// //   VTermPos combine_pos;   // Position before movement
// //
// //   struct {
// //     unsigned keypad:1;
// //     unsigned cursor:1;
// //     unsigned autowrap:1;
// //     unsigned insert:1;
// //     unsigned newline:1;
// //     unsigned cursor_visible:1;
// //     unsigned cursor_blink:1;
// //     unsigned cursor_shape:2;
// //     unsigned alt_screen:1;
// //     unsigned origin:1;
// //     unsigned screen:1;
// //     unsigned leftrightmargin:1;
// //     unsigned bracketpaste:1;
// //     unsigned report_focus:1;
// //     unsigned theme_updates:1;
// //   } mode;
// //
// //   VTermEncodingInstance encoding[4], encoding_utf8;
// //   int gl_set, gr_set, gsingle_set;
// //
// //   struct VTermPen pen;
// //
// //   VTermColor default_fg;
// //   VTermColor default_bg;
// //   VTermColor colors[16];  // Store the 8 ANSI and the 8 ANSI high-brights only
// //
// //   int bold_is_highbright;
// //
// //   unsigned protected_cell : 1;
// //
// // // Saved state under DEC mode 1048/1049
// //   struct {
// //     VTermPos pos;
// //     struct VTermPen pen;
// //
// //     struct {
// //       unsigned cursor_visible:1;
// //       unsigned cursor_blink:1;
// //       unsigned cursor_shape:2;
// //     } mode;
// //   } saved;
// //
// // // Temporary state for DECRQSS parsing
// //   union {
// //     char decrqss[4];
// //     struct {
// //       uint16_t mask;
// //       enum {
// //         SELECTION_INITIAL,
// //         SELECTION_SELECTED,
// //         SELECTION_QUERY,
// //         SELECTION_SET_INITIAL,
// //         SELECTION_SET,
// //         SELECTION_INVALID,
// //       } state : 8;
// //       uint32_t recvpartial;
// //       uint32_t sendpartial;
// //     } selection;
// //   } tmp;
// //
// //   struct {
// //     const VTermSelectionCallbacks *callbacks;
// //     void *user;
// //     char *buffer;
// //     size_t buflen;
// //   } selection;
// //
// //   // Maintain two stacks, one for primary screen and one for altscreen
// //   struct VTermKeyEncodingStack key_encoding_stacks[2];
// // };
// pub const VTermSelectionState = enum(u8) {
//     initial,
//     selected,
//     query,
//     set_initial,
//     set,
//     invalid,
// };
// pub const MOUSE_WANT_CLICK = 0x01;
// pub const MOUSE_WANT_DRAG = 0x02;
// pub const MOUSE_WANT_MOVE = 0x04;
// pub const VTermState = extern struct {
//     vt: *VTerm,
//     //   VTerm *vt;
//     //
//     //   const VTermStateCallbacks *callbacks;
//     //   void *cbdata;
//     //
//     //   const VTermStateFallbacks *fallbacks;
//     //   void *fbdata;
//     callbacks: ?*VTermStateCallbacks,
//     cbdata: ?*anyopaque,
//     fallbacks: ?*VTermStateFallbacks,
//     fbdata: ?*anyopaque,
//     //
//     //   int rows;
//     //   int cols;
//     rows: c_int,
//     cols: c_int,
//     //
//     //   // Current cursor position
//     //   VTermPos pos;
//     pos: VTermPos,
//     //
//     //   int at_phantom;  // True if we're on the "81st" phantom column to defer a wraparound
//     at_phantom: c_int,
//     //
//     //   int scrollregion_top;
//     //   int scrollregion_bottom;  // -1 means unbounded
//     // #define SCROLLREGION_BOTTOM(state) ((state)->scrollregion_bottom > \
//     //                                     -1 ? (state)->scrollregion_bottom : (state)->rows)
//     //   int scrollregion_left;
//     //   int scrollregion_right;  // -1 means unbounded
//     // #define SCROLLREGION_LEFT(state)  ((state)->mode.leftrightmargin ? (state)->scrollregion_left : 0)
//     // #define SCROLLREGION_RIGHT(state) ((state)->mode.leftrightmargin \
//     //                                    && (state)->scrollregion_right > \
//     //                                    -1 ? (state)->scrollregion_right : (state)->cols)
//     scrollregion_top: c_int,
//     scrollregion_bottom: c_int,
//     scrollregion_left: c_int,
//     scrollregion_right: c_int,
//     //
//     //   // Bitvector of tab stops
//     //   uint8_t *tabstops;
//     tabstops: [*]u8,
//     //
//     //   // Primary and Altscreen; lineinfos[1] is lazily allocated as needed
//     //   VTermLineInfo *lineinfos[2];
//     //
//     //   // lineinfo will == lineinfos[0] or lineinfos[1], depending on altscreen
//     //   VTermLineInfo *lineinfo;
//
//     // TODO: type, make sure this is right
//     lineinfos: [2]?*VTermLineInfo,
//     lineinfo: ?*VTermLineInfo,
//
//     // #define ROWWIDTH(state, \
//     //                  row) ((state)->lineinfo[(row)].doublewidth ? ((state)->cols / 2) : (state)->cols)
//     // #define THISROWWIDTH(state) ROWWIDTH(state, (state)->pos.row)
//     //
//     mouse_col: c_int,
//     mouse_row: c_int,
//     mouse_buttons: c_int,
//     mouse_flags: c_int,
//     // TODO: enum size,
//     mouse_protocol: enum(u8) {
//         x10,
//         utf8,
//         sgr,
//         rxvt,
//     },
//     // TODO: var
//     // grapheme_buf: [MAX_SCHAR_SIZE]u8,
//     grapheme_len: usize,
//     grapheme_last: u32,
//     // TODO: type
//     // grapheme_state: GraphemeState,
//     combine_width: c_int,
//     combine_pos: VTermPos,
//     mode: extern struct {
//         keypad: bool,
//         cursor: bool,
//         autowrap: bool,
//         insert: bool,
//         newline: bool,
//         cursor_visible: bool,
//         cursor_blink: bool,
//         cursor_shape: u8, // was u2
//         alt_screen: bool,
//         origin: bool,
//         screen: bool,
//         leftrightmargin: bool,
//         bracketpaste: bool,
//         report_focus: bool,
//         theme_updates: bool,
//     },
//     encoding: [4]VTermEncodingInstance,
//     encoding_utf8: VTermEncodingInstance,
//     gl_set: c_int,
//     gr_set: c_int,
//     gsingle_set: c_int,
//     pen: VTermPen,
//     default_fg: VTermColor,
//     default_bg: VTermColor,
//     colors: [16]VTermColor,
//     bold_is_highbright: c_int,
//     protected_cell: bool,
//     saved: extern struct {
//         pos: VTermPos,
//         pen: VTermPen,
//         mode: extern struct {
//             cursor_visible: bool,
//             cursor_blink: bool,
//             cursor_shape: u8, // was u2
//         },
//     },
//     tmp: extern union { decrqss: [4]u8, selection: extern struct {
//         mask: u16,
//         state: VTermSelectionState,
//         recvpartial: u32,
//         sendpartial: u32,
//     } },
//     selection: extern struct {
//         callbacks: ?*VTermSelectionCallbacks,
//         user: ?*anyopaque,
//         buffer: [*]u8,
//         buflen: usize,
//     },
//     key_encoding_stacks: [2]VTermKeyEncodingStack,
// };
//
// // struct VTerm {
// //   const VTermAllocatorFunctions *allocator;
// //   void *allocdata;
// //
// //   int rows;
// //   int cols;
// //
// //   struct {
// //     unsigned utf8:1;
// //     unsigned ctrl8bit:1;
// //   } mode;
// //
// //   struct {
// //     enum VTermParserState {
// //       NORMAL,
// //       CSI_LEADER,
// //       CSI_ARGS,
// //       CSI_INTERMED,
// //       DCS_COMMAND,
// //       // below here are the "string states"
// //       OSC_COMMAND,
// //       OSC,
// //       DCS_VTERM,
// //       APC,
// //       PM,
// //       SOS,
// //     } state;
// //
// //     bool in_esc : 1;
// //
// //     int intermedlen;
// //     char intermed[INTERMED_MAX];
// //
// //     union {
// //       struct {
// //         int leaderlen;
// //         char leader[CSI_LEADER_MAX];
// //
// //         int argi;
// //         long args[CSI_ARGS_MAX];
// //       } csi;
// //       struct {
// //         int command;
// //       } osc;
// //       struct {
// //         int commandlen;
// //         char command[CSI_LEADER_MAX];
// //       } dcs;
// //     } v;
// //
// //     const VTermParserCallbacks *callbacks;
// //     void *cbdata;
// //
// //     bool string_initial;
// //
// //     bool emit_nul;
// //   } parser;
// //
// //   // len == malloc()ed size; cur == number of valid bytes
// //
// //   VTermOutputCallback *outfunc;
// //   void *outdata;
// //
// //   char *outbuffer;
// //   size_t outbuffer_len;
// //   size_t outbuffer_cur;
// //
// //   char *tmpbuffer;
// //   size_t tmpbuffer_len;
// //
// //   VTermState *state;
// //   VTermScreen *screen;
// // };
// pub const VTermParserState = enum(u8) {
//     normal,
//     csi_leader,
//     csi_args,
//     csi_intermed,
//     dcs_command,
//     // below here are the "string states"
//     osc_command,
//     osc,
//     dcs_vterm,
//     apc,
//     pm,
//     sos,
// };
// pub const VTerm = extern struct {
//     allocator: *const VTermAllocatorFunctions,
//     allocdata: ?*anyopaque, // useless field
//     rows: c_int,
//     cols: c_int,
//     mode: extern struct {
//         utf8: bool,
//         ctrl8bit: bool,
//     },
//     parser: extern struct {
//         state: VTermParserState,
//         in_esc: bool,
//         intermedlen: c_int,
//         intermed: [INTERMED_MAX]u8,
//         //     union {
//         //       struct {
//         //         int leaderlen;
//         //         char leader[CSI_LEADER_MAX];
//         //
//         //         int argi;
//         //         long args[CSI_ARGS_MAX];
//         //       } csi;
//         //       struct {
//         //         int command;
//         //       } osc;
//         //       struct {
//         //         int commandlen;
//         //         char command[CSI_LEADER_MAX];
//         //       } dcs;
//         //     } v;
//         v: extern union {
//             csi: extern struct {
//                 leaderlen: c_int,
//                 leader: [CSI_LEADER_MAX]u8,
//                 argi: c_int,
//                 args: [CSI_ARGS_MAX]c_long,
//             },
//             osc: extern struct {
//                 command: c_int,
//             },
//             dcs: extern struct {
//                 commandlen: c_int,
//                 command: [CSI_LEADER_MAX]u8,
//             },
//         },
//         callbacks: ?*VTermParserCallbacks,
//         cbdata: ?*anyopaque,
//         string_initial: bool,
//         emit_nul: bool,
//     },
//
//     //   // len == malloc()ed size; cur == number of valid bytes
//     //
//     //   VTermOutputCallback *outfunc;
//     //   void *outdata;
//     //   char *outbuffer;
//     //   size_t outbuffer_len;
//     //   size_t outbuffer_cur;
//     outfunc: ?VTermOutputCallback,
//     outdata: ?*anyopaque,
//     outbuffer: [*]u8,
//     outbuffer_len: usize,
//     outbuffer_cur: usize,
//     //
//     //   char *tmpbuffer;
//     tmpbuffer: [*]u8,
//     //   size_t tmpbuffer_len;
//     tmpbuffer_len: usize,
//     //
//     //   VTermState *state;
//     //   VTermScreen *screen;
//     state: ?*VTermState,
//     screen: ?*VTermScreen,
// };
// //
// // struct VTermEncoding {
// //   void (*init)(VTermEncoding *enc, void *data);
// //   void (*decode)(VTermEncoding *enc, void *data, uint32_t cp[], int *cpi, int cplen,
// //                  const char bytes[], size_t *pos, size_t len);
// // };
// //
// // typedef enum {
// //   ENC_UTF8,
// //   ENC_SINGLE_94,
// // } VTermEncodingType;
// //
// // enum {
// //   C1_SS3 = 0x8f,
// //   C1_DCS = 0x90,
// //   C1_CSI = 0x9b,
// //   C1_ST  = 0x9c,
// //   C1_OSC = 0x9d,
// // };
pub const C1 = enum(u8) {
    ss3 = 0x8f,
    dcs = 0x90,
    csi = 0x9b,
    st = 0x9c,
    osc = 0x9d,
};
// // ================================================================================
// // END VTERM INTERNAL
// // ================================================================================
//
// // ================================================================================
// // VTERM DEFS
// // ================================================================================
// // typedef struct {
// //   int row;
// //   int col;
// // } VTermPos;
pub const VTermPos = extern struct {
    row: c_int,
    col: c_int,
};
//
// // // some small utility functions; we can just keep these static here
// //
// // typedef struct {
// //   int start_row;
// //   int end_row;
// //   int start_col;
// //   int end_col;
// // } VTermRect;
// pub const VTermRect = extern struct {
//     start_row: c_int,
//     end_row: c_int,
//     start_col: c_int,
//     end_col: c_int,
// };
// //
// // // Tagged union storing either an RGB color or an index into a colour palette. In order to convert
// // // indexed colours to RGB, you may use the vterm_state_convert_color_to_rgb() or
// // // vterm_screen_convert_color_to_rgb() functions which lookup the RGB colour from the palette
// // // maintained by a VTermState or VTermScreen instance.
// // typedef union {
// //   // Tag indicating which union member is actually valid. This variable coincides with the `type`
// //   // member of the `rgb` and the `indexed` struct in memory. Please use the `VTERM_COLOR_IS_*` test
// //   // macros to check whether a particular type flag is set.
// //   uint8_t type;
// //
// //   // Valid if `VTERM_COLOR_IS_RGB(type)` is true. Holds the RGB colour values.
// //   struct {
// //     // Same as the top-level `type` member stored in VTermColor.
// //     uint8_t type;
// //
// //     // The actual 8-bit red, green, blue colour values.
// //     uint8_t red, green, blue;
// //   } rgb;
// //
// //   // If `VTERM_COLOR_IS_INDEXED(type)` is true, this member holds the index into the colour palette.
// //   struct {
// //     // Same as the top-level `type` member stored in VTermColor.
// //     uint8_t type;
// //
// //     // Index into the colour map.
// //     uint8_t idx;
// //   } indexed;
// // } VTermColor;
pub const VTermColor = extern union {
    type: u8,
    rgb: extern struct {
        type: u8,
        red: u8 = 0,
        green: u8 = 0,
        blue: u8 = 0,
    },
    indexed: extern struct {
        type: u8,
        idx: u8,
    },
};

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
pub const VTermScreenCellAttrs = extern struct {
    bold: bool = false,
    underline: u8 = 0,
    italic: bool = false,
    blink: bool = false,
    reverse: bool = false,
    conceal: bool = false,
    strike: bool = false,
    font: u8 = 0, // 0 to 9.
    dwl: bool = false, // On a DECDWL or DECDHL line
    dhl: u8 = 0, // On a DECDHL line (1=top 2=bottom). was u2
    small: bool = false,
    baseline: u8 = 0, // was u2
};

// // typedef struct {
// //   schar_T schar;
// //   char width;
// //   VTermScreenCellAttrs attrs;
// //   VTermColor fg, bg;
// //   int uri;
// // } VTermScreenCell;
pub const VTermScreenCell = extern struct {
    schar: u32 = 0,
    width: u8 = 0,
    attrs: VTermScreenCellAttrs = .{},
    fg: VTermColor = .{ .type = 0 },
    bg: VTermColor = .{ .type = 0 },
    uri: c_int = 0,
};
//
// // typedef enum {
// //   // VTERM_PROP_NONE = 0
// //   VTERM_PROP_CURSORVISIBLE = 1,  // bool
// //   VTERM_PROP_CURSORBLINK,       // bool
// //   VTERM_PROP_ALTSCREEN,         // bool
// //   VTERM_PROP_TITLE,             // string
// //   VTERM_PROP_ICONNAME,          // string
// //   VTERM_PROP_REVERSE,           // bool
// //   VTERM_PROP_CURSORSHAPE,       // number
// //   VTERM_PROP_MOUSE,             // number
// //   VTERM_PROP_FOCUSREPORT,       // bool
// //   VTERM_PROP_THEMEUPDATES,      // bool
// //
// //   VTERM_N_PROPS,
// // } VTermProp;
pub const VTermProp = enum(u8) {
    // VTERM_PROP_NONE = 0
    cursorvisible = 1, // bool
    cursorblink, // bool
    altscreen, // bool
    title, // string
    iconname, // string
    reverse, // bool
    cursorshape, // number
    mouse, // number
    focusreport, // bool
    themeupdates, // bool
};
//
// // typedef enum {
// //   VTERM_TERMINATOR_BEL,  // \x07
// //   VTERM_TERMINATOR_ST,  // \x1b\x5c
// // } VTermTerminator;
pub const VTermTerminator = enum(u8) {
    bel,
    st,
};
//
// // typedef struct {
// //   const char *str;
// //   size_t len : 30;
// //   bool initial : 1;
// //   bool final : 1;
// //   VTermTerminator terminator;
// // } VTermStringFragment;
// // Sorry, this struct isn't packed nicely...
pub const VTermStringFragment = extern struct {
    str: [*]u8,
    len: u32,
    initial: bool,
    final: bool,
    terminator: VTermTerminator,
};
//
// // typedef union {
// //   int boolean;
// //   int number;
// //   VTermStringFragment string;
// //   VTermColor color;
// // } VTermValue;
pub const VTermValue = extern union {
    boolean: c_int,
    number: c_int,
    string: VTermStringFragment,
    color: VTermColor,
};
// //
// // typedef struct {
// //   int (*damage)(VTermRect rect, void *user);
// //   int (*moverect)(VTermRect dest, VTermRect src, void *user);
// //   int (*movecursor)(VTermPos pos, VTermPos oldpos, int visible, void *user);
// //   int (*settermprop)(VTermProp prop, VTermValue *val, void *user);
// //   int (*bell)(void *user);
// //   int (*resize)(int rows, int cols, void *user);
// //   int (*theme)(bool *dark, void *user);
// //   int (*sb_pushline)(int cols, const VTermScreenCell *cells, void *user);
// //   int (*sb_popline)(int cols, VTermScreenCell *cells, void *user);
// //   int (*sb_clear)(void *user);
// // } VTermScreenCallbacks;
// pub const VTermScreenCallbacks = extern struct {
//     damage: ?*const fn (rect: VTermRect, user: *anyopaque) callconv(.c) c_int,
//     moverect: ?*const fn (dest: VTermRect, src: VTermRect, user: *anyopaque) callconv(.c) c_int,
//     movecursor: ?*const fn (
//         pos: VTermPos,
//         oldpos: VTermPos,
//         visible: c_int,
//         user: *anyopaque,
//     ) callconv(.c) c_int,
//     settermprop: ?*const fn (
//         prop: VTermProp,
//         val: *VTermValue,
//         user: *anyopaque,
//     ) callconv(.c) c_int,
//     bell: ?*const fn (user: *anyopaque) callconv(.c) c_int,
//     resize: ?*const fn (rows: c_int, cols: c_int, user: *anyopaque) callconv(.c) c_int,
//     theme: ?*const fn (dark: *bool, user: *anyopaque) callconv(.c) c_int,
//     sb_pushline: ?*const fn (
//         cols: c_int,
//         cells: [*]const VTermScreenCell,
//         user: *anyopaque,
//     ) callconv(.c) c_int,
//     sb_popline: ?*const fn (
//         cols: c_int,
//         cells: [*]VTermScreenCell,
//         user: *anyopaque,
//     ) callconv(.c) c_int,
//     sb_clear: ?*const fn (user: *anyopaque) callconv(.c) c_int,
// };
//
// // typedef struct {
// //   int (*control)(uint8_t control, void *user);
// //   int (*csi)(const char *leader, const long args[], int argcount, const char *intermed,
// //              char command, void *user);
// //   int (*osc)(int command, VTermStringFragment frag, void *user);
// //   int (*dcs)(const char *command, size_t commandlen, VTermStringFragment frag, void *user);
// //   int (*apc)(VTermStringFragment frag, void *user);
// //   int (*pm)(VTermStringFragment frag, void *user);
// //   int (*sos)(VTermStringFragment frag, void *user);
// // } VTermStateFallbacks;
// pub const VTermStateFallbacks = extern struct {
//     control: *const fn (control: u8, user: *anyopaque) callconv(.c) c_int,
//     csi: *const fn (
//         leader: [*]const u8,
//         args: [*]const c_long,
//         argcount: c_int,
//         intermed: [*]const u8,
//         command: u8,
//         user: *anyopaque,
//     ) callconv(.c) c_int,
//     osc: *const fn (
//         command: c_int,
//         frag: VTermStringFragment,
//         user: *anyopaque,
//     ) callconv(.c) c_int,
//     dcs: *const fn (
//         command: [*]const u8,
//         commandlen: usize,
//         frag: VTermStringFragment,
//         user: *anyopaque,
//     ) callconv(.c) c_int,
//     apc: *const fn (frag: VTermStringFragment, user: *anyopaque) callconv(.c) c_int,
//     pm: *const fn (frag: VTermStringFragment, user: *anyopaque) callconv(.c) c_int,
//     sos: *const fn (frag: VTermStringFragment, user: *anyopaque) callconv(.c) c_int,
// };
// //
// // typedef enum {
// //   VTERM_DAMAGE_CELL,    // every cell
// //   VTERM_DAMAGE_ROW,     // entire rows
// //   VTERM_DAMAGE_SCREEN,  // entire screen
// //   VTERM_DAMAGE_SCROLL,  // entire screen + scrollrect
// //
// //   VTERM_N_DAMAGES,
// // } VTermDamageSize;
// pub const VTermDamageSize = enum(u8) {
//     cell, // every cell
//     row, // entire rows
//     screen, // entire screen
//     scroll, // entire screen + scrollrect
// };
// //
// // typedef enum {
// //   VTERM_ATTR_BOLD_MASK       = 1 << 0,
// //   VTERM_ATTR_UNDERLINE_MASK  = 1 << 1,
// //   VTERM_ATTR_ITALIC_MASK     = 1 << 2,
// //   VTERM_ATTR_BLINK_MASK      = 1 << 3,
// //   VTERM_ATTR_REVERSE_MASK    = 1 << 4,
// //   VTERM_ATTR_STRIKE_MASK     = 1 << 5,
// //   VTERM_ATTR_FONT_MASK       = 1 << 6,
// //   VTERM_ATTR_FOREGROUND_MASK = 1 << 7,
// //   VTERM_ATTR_BACKGROUND_MASK = 1 << 8,
// //   VTERM_ATTR_CONCEAL_MASK    = 1 << 9,
// //   VTERM_ATTR_SMALL_MASK      = 1 << 10,
// //   VTERM_ATTR_BASELINE_MASK   = 1 << 11,
// //   VTERM_ATTR_URI_MASK        = 1 << 12,
// //
// //   VTERM_ALL_ATTRS_MASK = (1 << 13) - 1,
// // } VTermAttrMask;
// //
// // typedef enum {
// //   // VTERM_VALUETYPE_NONE = 0
// //   VTERM_VALUETYPE_BOOL = 1,
// //   VTERM_VALUETYPE_INT,
// //   VTERM_VALUETYPE_STRING,
// //   VTERM_VALUETYPE_COLOR,
// //
// //   VTERM_N_VALUETYPES,
// // } VTermValueType;
// //
// // typedef enum {
// //   // VTERM_ATTR_NONE = 0
// //   VTERM_ATTR_BOLD = 1,   // bool:   1, 22
// //   VTERM_ATTR_UNDERLINE,  // number: 4, 21, 24
// //   VTERM_ATTR_ITALIC,     // bool:   3, 23
// //   VTERM_ATTR_BLINK,      // bool:   5, 25
// //   VTERM_ATTR_REVERSE,    // bool:   7, 27
// //   VTERM_ATTR_CONCEAL,    // bool:   8, 28
// //   VTERM_ATTR_STRIKE,     // bool:   9, 29
// //   VTERM_ATTR_FONT,       // number: 10-19
// //   VTERM_ATTR_FOREGROUND,  // color:  30-39 90-97
// //   VTERM_ATTR_BACKGROUND,  // color:  40-49 100-107
// //   VTERM_ATTR_SMALL,      // bool:   73, 74, 75
// //   VTERM_ATTR_BASELINE,   // number: 73, 74, 75
// //   VTERM_ATTR_URI,        // number
// //
// //   VTERM_N_ATTRS,
// // } VTermAttr;
// pub const VTermAttr = enum(u8) {
//     // VTERM_ATTR_NONE = 0
//     bold = 1, // bool:   1, 22
//     underline, // number: 4, 21, 24
//     italic, // bool:   3, 23
//     blink, // bool:   5, 25
//     reverse, // bool:   7, 27
//     conceal, // bool:   8, 28
//     strike, // bool:   9, 29
//     font, // number: 10-19
//     foreground, // color:  30-39 90-97
//     background, // color:  40-49 100-107
//     small, // bool:   73, 74, 75
//     baseline, // number: 73, 74, 75
//     uri, // number
// };
// //
// // enum {
// //   VTERM_PROP_CURSORSHAPE_BLOCK = 1,
// //   VTERM_PROP_CURSORSHAPE_UNDERLINE,
// //   VTERM_PROP_CURSORSHAPE_BAR_LEFT,
// //
// //   VTERM_N_PROP_CURSORSHAPES,
// // };
// //
// // enum {
// //   VTERM_PROP_MOUSE_NONE = 0,
// //   VTERM_PROP_MOUSE_CLICK,
// //   VTERM_PROP_MOUSE_DRAG,
// //   VTERM_PROP_MOUSE_MOVE,
// //
// //   VTERM_N_PROP_MOUSES,
// // };
// //
// // typedef enum {
// //   VTERM_SELECTION_CLIPBOARD = (1<<0),
// //   VTERM_SELECTION_PRIMARY   = (1<<1),
// //   VTERM_SELECTION_SECONDARY = (1<<2),
// //   VTERM_SELECTION_SELECT    = (1<<3),
// //   VTERM_SELECTION_CUT0      = (1<<4),  // also CUT1 .. CUT7 by bitshifting
// // } VTermSelectionMask;
// pub const VTermSelectionMask = u8;
// pub const VTERM_SELECTION_CLIPBOARD: VTermSelectionMask = (1 << 0);
// pub const VTERM_SELECTION_PRIMARY: VTermSelectionMask = (1 << 1);
// pub const VTERM_SELECTION_SECONDARY: VTermSelectionMask = (1 << 2);
// pub const VTERM_SELECTION_SELECT: VTermSelectionMask = (1 << 3);
// pub const VTERM_SELECTION_CUT0: VTermSelectionMask = (1 << 4); // also CUT1 .. CUT7 by bitshifting
//
// // typedef struct {
// //   schar_T schar;
// //   int width;
// //   unsigned protected_cell:1;  // DECSCA-protected against DECSEL/DECSED
// //   unsigned dwl:1;             // DECDWL or DECDHL double-width line
// //   unsigned dhl:2;             // DECDHL double-height line (1=top 2=bottom)
// // } VTermGlyphInfo;
// pub const VTermGlyphInfo = extern struct {
//     schar: u32,
//     width: c_int,
//     protected_cell: bool,
//     dwl: bool,
//     dhl: u8, // was u2
// };
//
// // typedef struct {
// //   unsigned doublewidth:1;     // DECDWL or DECDHL line
// //   unsigned doubleheight:2;    // DECDHL line (1=top 2=bottom)
// //   unsigned continuation:1;    // Line is a flow continuation of the previous
// // } VTermLineInfo;
// pub const VTermLineInfo = extern struct {
//     doublewidth: bool,
//     doubleheight: u8, // was u2
//     continuation: bool,
// };
//
// // // Copies of VTermState fields that the 'resize' callback might have reason to edit. 'resize'
// // // callback gets total control of these fields and may free-and-reallocate them if required. They
// // // will be copied back from the struct after the callback has returned.
// // typedef struct {
// //   VTermPos pos;                // current cursor position
// //   VTermLineInfo *lineinfos[2];  // [1] may be NULL
// // } VTermStateFields;
// pub const VTermStateFields = extern struct {
//     pos: VTermPos,
//     lineinfos: [2]?*VTermLineInfo,
// };
//
// // typedef struct {
// //   // libvterm relies on this memory to be zeroed out before it is returned by the allocator.
// //   void *(*malloc)(size_t size, void *allocdata);
// //   void (*free)(void *ptr, void *allocdata);
// // } VTermAllocatorFunctions;
// pub const VTermAllocatorFunctions = extern struct {
//     malloc: *const fn (size: usize, allocdata: ?*anyopaque) callconv(.c) *anyopaque,
//     free: *const fn (ptr: *anyopaque, allocdata: ?*anyopaque) callconv(.c) void,
// };
//
// // // Setting output callback will override the buffer logic
// // typedef void VTermOutputCallback(const char *s, size_t len, void *user);
const VTermOutputCallback = *const fn (s: [*]const u8, len: usize, user: ?*anyopaque) callconv(.c) void;
// //
// // struct VTermBuilder {
// //   int ver;  // currently unused but reserved for some sort of ABI version flag
// //
// //   int rows, cols;
// //
// //   const VTermAllocatorFunctions *allocator;
// //   void *allocdata;
// //
// //   // Override default sizes for various structures
// //   size_t outbuffer_len;  // default: 4096
// //   size_t tmpbuffer_len;  // default: 4096
// // };
// pub const VTermBuilder = extern struct {
//     ver: c_int = 0,
//     rows: c_int,
//     cols: c_int,
//     allocator: ?*const VTermAllocatorFunctions = null,
//     allocdata: ?*anyopaque = null,
//     outbuffer_len: usize = 4096,
//     tmpbuffer_len: usize = 4096,
// };
//
// // typedef struct {
// //   int (*putglyph)(VTermGlyphInfo *info, VTermPos pos, void *user);
// //   int (*movecursor)(VTermPos pos, VTermPos oldpos, int visible, void *user);
// //   int (*scrollrect)(VTermRect rect, int downward, int rightward, void *user);
// //   int (*moverect)(VTermRect dest, VTermRect src, void *user);
// //   int (*erase)(VTermRect rect, int selective, void *user);
// //   int (*initpen)(void *user);
// //   int (*setpenattr)(VTermAttr attr, VTermValue *val, void *user);
// //   int (*settermprop)(VTermProp prop, VTermValue *val, void *user);
// //   int (*bell)(void *user);
// //   int (*resize)(int rows, int cols, VTermStateFields *fields, void *user);
// //   int (*theme)(bool *dark, void *user);
// //   int (*setlineinfo)(int row, const VTermLineInfo *newinfo, const VTermLineInfo *oldinfo,
// //                      void *user);
// //   int (*sb_clear)(void *user);
// // } VTermStateCallbacks;
// pub const VTermStateCallbacks = extern struct {
//     //   int (*putglyph)(VTermGlyphInfo *info, VTermPos pos, void *user);
//     putglyph: *const fn (info: *VTermGlyphInfo, pos: VTermPos, user: *anyopaque) callconv(.c) c_int,
//     //   int (*movecursor)(VTermPos pos, VTermPos oldpos, int visible, void *user);
//     movecursor: *const fn (
//         pos: VTermPos,
//         oldpos: VTermPos,
//         visible: c_int,
//         user: *anyopaque,
//     ) callconv(.c) c_int,
//     //   int (*scrollrect)(VTermRect rect, int downward, int rightward, void *user);
//     scrollrect: *const fn (
//         rect: VTermRect,
//         downward: c_int,
//         rightward: c_int,
//         user: *anyopaque,
//     ) callconv(.c) c_int,
//     //   int (*moverect)(VTermRect dest, VTermRect src, void *user);
//     moverect: *const fn (dest: VTermRect, src: VTermRect, user: *anyopaque) callconv(.c) c_int,
//     //   int (*erase)(VTermRect rect, int selective, void *user);
//     erase: *const fn (rect: VTermRect, selective: c_int, user: *anyopaque) callconv(.c) c_int,
//     //   int (*initpen)(void *user);
//     initpen: *const fn (user: *anyopaque) callconv(.c) c_int,
//     //   int (*setpenattr)(VTermAttr attr, VTermValue *val, void *user);
//     setpenattr: *const fn (attr: VTermAttr, val: *VTermValue, user: *anyopaque) callconv(.c) c_int,
//     //   int (*settermprop)(VTermProp prop, VTermValue *val, void *user);
//     settermprop: *const fn (prop: VTermProp, val: *VTermValue, user: *anyopaque) callconv(.c) c_int,
//     //   int (*bell)(void *user);
//     bell: *const fn (user: *anyopaque) callconv(.c) c_int,
//     //   int (*resize)(int rows, int cols, VTermStateFields *fields, void *user);
//     resize: *const fn (
//         rows: c_int,
//         cols: c_int,
//         fields: *VTermStateFields,
//         user: *anyopaque,
//     ) callconv(.c) c_int,
//     //   int (*theme)(bool *dark, void *user);
//     theme: *const fn (dark: *bool, user: *anyopaque) callconv(.c) c_int,
//     //   int (*setlineinfo)(int row, const VTermLineInfo *newinfo, const VTermLineInfo *oldinfo c_int,
//     //                      void *user);
//     setlineinfo: *const fn (
//         row: c_int,
//         newinfo: *VTermLineInfo,
//         oldinfo: *VTermLineInfo,
//         user: *anyopaque,
//     ) callconv(.c) c_int,
//     //   int (*sb_clear)(void *user);
//     sb_clear: *const fn (user: *anyopaque) callconv(.c) c_int,
// };
//
// // typedef struct {
// //   int (*set)(VTermSelectionMask mask, VTermStringFragment frag, void *user);
// //   int (*query)(VTermSelectionMask mask, void *user);
// // } VTermSelectionCallbacks;
// pub const VTermSelectionCallbacks = extern struct {
//     set: ?*const fn (mask: VTermSelectionMask, frag: VTermStringFragment, user: *anyopaque) c_int,
//     query: ?*const fn (mask: VTermSelectionMask, user: *anyopaque) c_int,
// };
//
// // typedef struct {
// //   int (*text)(const char *bytes, size_t len, void *user);
// //   int (*control)(uint8_t control, void *user);
// //   int (*escape)(const char *bytes, size_t len, void *user);
// //   int (*csi)(const char *leader, const long args[], int argcount, const char *intermed,
// //              char command, void *user);
// //   int (*osc)(int command, VTermStringFragment frag, void *user);
// //   int (*dcs)(const char *command, size_t commandlen, VTermStringFragment frag, void *user);
// //   int (*apc)(VTermStringFragment frag, void *user);
// //   int (*pm)(VTermStringFragment frag, void *user);
// //   int (*sos)(VTermStringFragment frag, void *user);
// //   int (*resize)(int rows, int cols, void *user);
// // } VTermParserCallbacks;
// pub const VTermParserCallbacks = extern struct {
//     //   int (*text)(const char *bytes, size_t len, void *user);
//     text: ?*const fn (bytes: [*]const u8, len: usize, user: *anyopaque) callconv(.c) c_int,
//     //   int (*control)(uint8_t control, void *user);
//     control: ?*const fn (control: u8, user: *anyopaque) callconv(.c) c_int,
//     //   int (*escape)(const char *bytes, size_t len, void *user);
//     escape: ?*const fn (bytes: [*]const u8, len: usize, user: *anyopaque) callconv(.c) c_int,
//     //   int (*csi)(const char *leader, const long args[], int argcount, const char *intermed,
//     //              char command, void *user);
//     csi: ?*const fn (
//         leader: [*]const u8,
//         args: [*]const c_long,
//         argcount: c_int,
//         intermed: [*]const u8,
//         command: u8,
//         user: *anyopaque,
//     ) callconv(.c) c_int,
//     //   int (*osc)(int command, VTermStringFragment frag, void *user);
//     osc: ?*const fn (
//         command: c_int,
//         frag: VTermStringFragment,
//         user: *anyopaque,
//     ) callconv(.c) c_int,
//     //   int (*dcs)(const char *command, size_t commandlen, VTermStringFragment frag, void *user);
//     dcs: ?*const fn (
//         command: [*]const u8,
//         commandlen: usize,
//         frag: VTermStringFragment,
//         user: *anyopaque,
//     ) callconv(.c) c_int,
//     //   int (*apc)(VTermStringFragment frag, void *user);
//     apc: ?*const fn (
//         frag: VTermStringFragment,
//         user: *anyopaque,
//     ) callconv(.c) c_int,
//     //   int (*pm)(VTermStringFragment frag, void *user);
//     pm: ?*const fn (
//         frag: VTermStringFragment,
//         user: *anyopaque,
//     ) callconv(.c) c_int,
//     //   int (*sos)(VTermStringFragment frag, void *user);
//     sos: ?*const fn (
//         frag: VTermStringFragment,
//         user: *anyopaque,
//     ) callconv(.c) c_int,
//     //   int (*resize)(int rows, int cols, void *user);
//     resize: ?*const fn (rows: c_int, cols: c_int, user: *anyopaque) callconv(.c) c_int,
// };
//
// // // State of the pen at some moment in time, also used in a cell
// // typedef struct {
// //   // After the bitfield
// //   VTermColor fg, bg;
// //
// //   // Opaque ID that maps to a URI in a set
// //   int uri;
// //
// //   unsigned bold      : 1;
// //   unsigned underline : 2;
// //   unsigned italic    : 1;
// //   unsigned blink     : 1;
// //   unsigned reverse   : 1;
// //   unsigned conceal   : 1;
// //   unsigned strike    : 1;
// //   unsigned font      : 4;  // 0 to 9
// //   unsigned small     : 1;
// //   unsigned baseline  : 2;
// //
// //   // Extra state storage that isn't strictly pen-related
// //   unsigned protected_cell : 1;
// //   unsigned dwl            : 1;  // on a DECDWL or DECDHL line
// //   unsigned dhl            : 2;  // on a DECDHL line (1=top 2=bottom)
// // } ScreenPen;
// pub const ScreenPen = extern struct {
//     //   // After the bitfield
//     //   VTermColor fg, bg;
//     fg: VTermColor,
//     bg: VTermColor,
//     //
//     //   // Opaque ID that maps to a URI in a set
//     //   int uri;
//     uri: c_int,
//     //
//     bold: bool,
//     underline: u8, // was u2
//     italic: bool,
//     blink: bool,
//     reverse: bool,
//     conceal: bool,
//     strike: bool,
//     font: u8, // 0 to 9. was u4
//     small: bool,
//     baseline: u8, // was u2
//
//     // Extra state storage that isn't strictly pen-related
//     protected_cell: bool,
//     dwl: bool, // on a DECDWL or DECDHL line
//     dhl: u8, // on a DECDHL line (1=top 2=bottom). was u2
// };
//
// // // Internal representation of a screen cell
// // typedef struct {
// //   schar_T schar;
// //   ScreenPen pen;
// // } ScreenCell;
// pub const ScreenCell = extern struct {
//     schar: u32,
//     pen: ScreenPen,
// };
// // ================================================================================
// // END VTERM DEFS
// // ================================================================================
//
// // // move a rect
// // static inline void vterm_rect_move(VTermRect *rect, int row_delta, int col_delta)
// // {
// //   rect->start_row += row_delta; rect->end_row += row_delta;
// //   rect->start_col += col_delta; rect->end_col += col_delta;
// // }
// //
// // // Bit-field describing the content of the tagged union `VTermColor`.
// // typedef enum {
// //   // If the lower bit of `type` is not set, the colour is 24-bit RGB.
// //   VTERM_COLOR_RGB = 0x00,
// //
// //   // The colour is an index into a palette of 256 colours.
// //   VTERM_COLOR_INDEXED = 0x01,
// //
// //   // Mask that can be used to extract the RGB/Indexed bit.
// //   VTERM_COLOR_TYPE_MASK = 0x01,
// //
// //   // If set, indicates that this colour should be the default foreground color, i.e. there was no
// //   // SGR request for another colour. When rendering this colour it is possible to ignore "idx" and
// //   // just use a colour that is not in the palette.
// //   VTERM_COLOR_DEFAULT_FG = 0x02,
// //
// //   // If set, indicates that this colour should be the default background color, i.e. there was no
// //   // SGR request for another colour. A common option when rendering this colour is to not render a
// //   // background at all, for example by rendering the window transparently at this spot.
// //   VTERM_COLOR_DEFAULT_BG = 0x04,
// //
// //   // Mask that can be used to extract the default foreground/background bit.
// //   VTERM_COLOR_DEFAULT_MASK = 0x06,
// // } VTermColorType;
// //
// // // Returns true if the VTERM_COLOR_RGB `type` flag is set, indicating that the given VTermColor
// // // instance is an indexed colour.
// // #define VTERM_COLOR_IS_INDEXED(col) \
// //   (((col)->type & VTERM_COLOR_TYPE_MASK) == VTERM_COLOR_INDEXED)
// //
// // // Returns true if the VTERM_COLOR_INDEXED `type` flag is set, indicating that the given VTermColor
// // // instance is an rgb colour.
// // #define VTERM_COLOR_IS_RGB(col) \
// //   (((col)->type & VTERM_COLOR_TYPE_MASK) == VTERM_COLOR_RGB)
// //
// // // Returns true if the VTERM_COLOR_DEFAULT_FG `type` flag is set, indicating that the given
// // // VTermColor instance corresponds to the default foreground color.
// // #define VTERM_COLOR_IS_DEFAULT_FG(col) \
// //   (!!((col)->type & VTERM_COLOR_DEFAULT_FG))
// //
// // // Returns true if the VTERM_COLOR_DEFAULT_BG `type` flag is set, indicating that the given
// // // VTermColor instance corresponds to the default background color.
// // #define VTERM_COLOR_IS_DEFAULT_BG(col) \
// //   (!!((col)->type & VTERM_COLOR_DEFAULT_BG))
// //
// // // Constructs a new VTermColor instance representing the given RGB values.
// // static inline void vterm_color_rgb(VTermColor *col, uint8_t red, uint8_t green, uint8_t blue)
// // {
// //   col->type = VTERM_COLOR_RGB;
// //   col->rgb.red = red;
// //   col->rgb.green = green;
// //   col->rgb.blue = blue;
// // }
// //
// // // Construct a new VTermColor instance representing an indexed color with the given index.
// // static inline void vterm_color_indexed(VTermColor *col, uint8_t idx)
// // {
// //   col->type = VTERM_COLOR_INDEXED;
// //   col->indexed.idx = idx;
// // }
// //
// // // ------------
// // // Parser layer
// // // ------------
// //
// // /// Flag to indicate non-final subparameters in a single CSI parameter.
// // /// Consider
// // ///   CSI 1;2:3:4;5a
// // /// 1 4 and 5 are final.
// // /// 2 and 3 are non-final and will have this bit set
// // ///
// // /// Don't confuse this with the final byte of the CSI escape; 'a' in this case.
// // #define CSI_ARG_FLAG_MORE (1U << 31)
// // #define CSI_ARG_MASK      (~(1U << 31))
// //
// // #define CSI_ARG_HAS_MORE(a) ((a)& CSI_ARG_FLAG_MORE)
// // #define CSI_ARG(a)          ((a)& CSI_ARG_MASK)
// //
// // // Can't use -1 to indicate a missing argument; use this instead
// // #define CSI_ARG_MISSING ((1UL<<31) - 1)
// //
// // #define CSI_ARG_IS_MISSING(a) (CSI_ARG(a) == CSI_ARG_MISSING)
// // #define CSI_ARG_OR(a, def)     (CSI_ARG(a) == CSI_ARG_MISSING ? (def) : CSI_ARG(a))
// // #define CSI_ARG_COUNT(a)      (CSI_ARG(a) == CSI_ARG_MISSING || CSI_ARG(a) == 0 ? 1 : CSI_ARG(a))
// //
// // enum {
// //   VTERM_UNDERLINE_OFF,
// //   VTERM_UNDERLINE_SINGLE,
// //   VTERM_UNDERLINE_DOUBLE,
// //   VTERM_UNDERLINE_CURLY,
// // };
// //
// // enum {
// //   VTERM_BASELINE_NORMAL,
// //   VTERM_BASELINE_RAISE,
// //   VTERM_BASELINE_LOWER,
// // };
// //
// // // Back-compat alias for the brief time it was in 0.3-RC1
// // #define vterm_screen_set_reflow  vterm_screen_enable_reflow
// //
// // void vterm_scroll_rect(VTermRect rect, int downward, int rightward,
// //                        int (*moverect)(VTermRect src, VTermRect dest, void *user),
// //                        int (*eraserect)(VTermRect rect, int selective, void *user), void *user);
//
// // struct VTermScreen {
// //   VTerm *vt;
// //   VTermState *state;
// //
// //   const VTermScreenCallbacks *callbacks;
// //   void *cbdata;
// //
// //   VTermDamageSize damage_merge;
// //   // start_row == -1 => no damage
// //   VTermRect damaged;
// //   VTermRect pending_scrollrect;
// //   int pending_scroll_downward, pending_scroll_rightward;
// //
// //   int rows;
// //   int cols;
// //
// //   unsigned global_reverse : 1;
// //   unsigned reflow : 1;
// //
// //   // Primary and Altscreen. buffers[1] is lazily allocated as needed
// //   ScreenCell *buffers[2];
// //
// //   // buffer will == buffers[0] or buffers[1], depending on altscreen
// //   ScreenCell *buffer;
// //
// //   // buffer for a single screen row used in scrollback storage callbacks
// //   VTermScreenCell *sb_buffer;
// //
// //   ScreenPen pen;
// // };
// pub const VTermScreen = extern struct {
//     vt: *VTerm,
//     state: *VTermState,
//     callbacks: ?*const VTermScreenCallbacks,
//     cbdata: ?*anyopaque,
//     damage_merge: VTermDamageSize,
//     // // start_row == -1 => no damage
//     damaged: VTermRect,
//     pending_scrollrect: VTermRect,
//     pending_scroll_downward: c_int,
//     pending_scroll_rightward: c_int,
//     rows: c_int,
//     cols: c_int,
//     global_reverse: bool,
//     reflow: bool,
//     // // Primary and Altscreen. buffers[1] is lazily allocated as needed
//     // ScreenCell *buffers[2];
//     buffers: [2]?*ScreenCell,
//     // // buffer will == buffers[0] or buffers[1], depending on altscreen
//     buffer: ?*ScreenCell,
//     // // buffer for a single screen row used in scrollback storage callbacks
//     sb_buffer: *VTermScreenCell,
//     pen: ScreenPen,
// };
//
// // static void *default_malloc(size_t size, void *allocdata)
// // {
// //   void *ptr = xmalloc(size);
// //   if (ptr) {
// //     memset(ptr, 0, size);
// //   }
// //   return ptr;
// // }
// pub fn default_malloc(size: usize, allocdata: ?*anyopaque) callconv(.c) *anyopaque {
//     _ = allocdata;
//     // xmalloc never returns NULL
//     const ptr = c.xmalloc(size);
//     _ = c.memset(ptr.?, 0, size);
//     return ptr.?;
// }
//
// // static void default_free(void *ptr, void *allocdata)
// // {
// //   xfree(ptr);
// // }
// pub fn default_free(ptr: *anyopaque, allocdata: ?*anyopaque) callconv(.c) void {
//     _ = allocdata;
//     c.xfree(ptr);
// }
//
// // static VTermAllocatorFunctions default_allocator = {
// //   .malloc = &default_malloc,
// //   .free = &default_free,
// // };
// pub const default_allocator: VTermAllocatorFunctions = .{
//     .malloc = default_malloc,
//     .free = default_free,
// };

// /// Convenient shortcut for default cases
// VTerm *vterm_new(int rows, int cols)
// {
//   return vterm_build(&(const struct VTermBuilder){
//     .rows = rows,
//     .cols = cols,
//   });
// }
//
//
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
pub const VTermModifier = c_int;
pub const VTERM_MOD_NONE: VTermModifier = 0x00;
pub const VTERM_MOD_SHIFT: VTermModifier = 0x01;
pub const VTERM_MOD_ALT: VTermModifier = 0x02;
pub const VTERM_MOD_CTRL: VTermModifier = 0x04;

pub const VTERM_ALL_MODS_MASK: VTermModifier = 0x07;

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
    outfunc: VTermOutputCallback,
    outdata: *anyopaque,

    pub fn send(self: *const VTermMsgWriter, msg: []const u8) void {
        self.outfunc(msg.ptr, msg.len, self.outdata);
    }
};

pub const VTerm = struct {
    t: *ghostty_vt.Terminal,
    rs: ghostty_vt.RenderState,
    s: Stream,
    msg_writer: ?VTermMsgWriter,
    allocator: std.mem.Allocator,
    // One for primary and one for alternate screen
    key_encoding_stack: struct {
        primary: VTermKeyEncodingStack,
        alternate: VTermKeyEncodingStack,
    },
    // TODO: I don't think we even need 64 bytes for this. libvterm had 4096 bytes for
    // outbuffer, but I don't think it was fully used because it was all
    // handled by outfunc. Maybe I'm missing something, though.
    keyout_buffer: [VTERM_BUF_DEFAULT_SIZE]u8,
    keyout_buffer_w: std.Io.Writer,
    // tmpbuffer: [VTERM_BUF_DEFAULT_SIZE]u8,
    // apc_buf: std.ArrayList(u8),
    //
    // const Self = @This();
    // pub fn reset_apc_buf(self: *Self) void {
    //     if (self.apc_buf.items.len > VTERM_BUF_DEFAULT_SIZE) {
    //         self.apc_buf.shrinkAndFree(self.allocator, VTERM_BUF_DEFAULT_SIZE);
    //     }
    //     self.apc_buf.items.len = 0;
    // }
    //
    pub fn term_send(self: *VTerm, msg: []const u8) void {
        if (self.msg_writer) |w| w.send(msg);
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
pub export fn vtermz_new(rows: c_int, cols: c_int) callconv(.c) *VTerm {
    const alloc = gpa_alloc;
    const t = alloc.create(ghostty_vt.Terminal) catch preserve_exit(e_outofmem);
    t.* = ghostty_vt.Terminal.init(alloc, .{
        .rows = @intCast(rows),
        .cols = @intCast(cols),
        // .colors = .{
        // .foreground = .init(
        //     .{
        //         .r = 0xfa,
        //         .g = 0xfa,
        //         .b = 0xfa,
        //     },
        // ),
        // .background = .init(
        //     .{
        //         .r = 0x10,
        //         .g = 0x10,
        //         .b = 0x10,
        //     },
        // ),
        // .cursor = .init(
        //     .{
        //         .r = 0xfa,
        //         .g = 0xfa,
        //         .b = 0xfa,
        //     },
        // ),
        // .palette = .default,
        // },
    }) catch preserve_exit(e_outofmem);

    const rs: ghostty_vt.RenderState = .empty;

    const handler = vterm_handler.Handler.init(t, alloc);
    const stream = vterm_handler.Stream.initAlloc(alloc, handler);

    var vt = alloc.create(VTerm) catch preserve_exit(e_outofmem);
    vt.t = t;
    vt.rs = rs;
    vt.s = stream;
    vt.keyout_buffer_w = std.Io.Writer.fixed(&vt.keyout_buffer);
    vt.allocator = alloc;
    return vt;
}

// DONE
pub export fn vtermz_free(vt: *VTerm) callconv(.c) void {
    vt.t.deinit(vt.allocator);
    vt.rs.deinit(vt.allocator);
    vt.s.deinit();
    vt.allocator.destroy(vt.t);
    vt.allocator.destroy(vt);
    if (builtin.is_test) {
        vtermz_teardown();
    }
}

pub export fn vtermz_refresh(vt: *VTerm) callconv(.c) void {
    vt.rs.update(vt.allocator, vt.t) catch preserve_exit(e_outofmem);
}

pub export fn vtermz_teardown() callconv(.c) void {
    _ = gpa.deinit();
}

// fn bytes_hex_leak(vt: *VTerm, bytes: []const u8) []u8 {
//     var buf = vt.allocator.alloc(u8, bytes.len * 3) catch @panic("oom");
//     var idx: usize = 0;
//     for (bytes) |b| {
//         const digits = std.fmt.hex(b);
//         buf[idx] = digits[0];
//         buf[idx + 1] = digits[1];
//         buf[idx + 2] = ' ';
//         idx += 3;
//     }
//
//     return buf[0 .. @max(1, idx) - 1];
// }

pub export fn vtermz_input_write(vt: *VTerm, bytes: [*]const u8, len: usize) callconv(.c) usize {
    // TODO: handle errors
    // log.warn(@src(), "writing input to term: {s}", .{bytes_hex_leak(vt, bytes[0..len])});
    vt.s.nextSlice(bytes[0..len]) catch {};
    return 0;
}

pub export fn vtermz_output_set_callback(
    vt: *VTerm,
    func: VTermOutputCallback,
    user: *anyopaque,
) callconv(.c) void {
    const msg_writer: VTermMsgWriter = .{
        .outfunc = func,
        .outdata = user,
    };
    vt.msg_writer = msg_writer;
    vt.s.handler.msg_writer = msg_writer;
}

pub export fn vtermz_screen_set_callbacks(vt: *VTerm, callbacks: *const vterm_handler.VTermZCallbacks, user: *anyopaque) callconv(.c) void {
    vt.s.handler.callbacks = callbacks.*;
    vt.s.handler.cbdata = user;
}

// void vterm_push_output_bytes(VTerm *vt, const char *bytes, size_t len)
// {
//   if (vt->outfunc) {
//     (vt->outfunc)(bytes, len, vt->outdata);
//     return;
//   }
//
//   if (len > vt->outbuffer_len - vt->outbuffer_cur) {
//     return;
//   }
//
//   memcpy(vt->outbuffer + vt->outbuffer_cur, bytes, len);
//   vt->outbuffer_cur += len;
// }
// pub fn vtermz_push_output_bytes(vt: *VTerm, bytes: []const u8, len: usize) void {
//     //   if (vt->outfunc) {
//     //     (vt->outfunc)(bytes, len, vt->outdata);
//     //     return;
//     //   }
//     if (vt.outfunc) |outfunc| {
//         outfunc(bytes.ptr, len, vt.outdata);
//         return;
//     }
//
//     //   if (len > vt->outbuffer_len - vt->outbuffer_cur) {
//     //     return;
//     //   }
//     if (len > vt.keyoutbuffer.len - vt.outbuffer_cur) {
//         return;
//     }
//     // memcpy(vt->outbuffer + vt->outbuffer_cur, bytes, len);
//     @memcpy(vt.keyoutbuffer[vt.outbuffer_cur .. vt.outbuffer_cur + len], bytes[0..len]);
//     //   vt->outbuffer_cur += len;
//     vt.outbuffer_cur += len;
// }

// void vterm_push_output_sprintf(VTerm *vt, const char *format, ...)
//   FUNC_ATTR_PRINTF(2, 3)
// {
//   va_list args;
//   va_start(args, format);
//   size_t len = (size_t)vsnprintf(vt->tmpbuffer, vt->tmpbuffer_len, format, args);
//   vterm_push_output_bytes(vt, vt->tmpbuffer, len);
//   va_end(args);
// }
// pub fn vtermz_push_output_sprintf(vt: *VTerm, comptime format: []const u8, args: anytype) void {
//     // TODO: handle failure, but this should probably never fail.
//     const buf = std.fmt.bufPrint(&vt.tmpbuffer, format, args) catch return;
//     vtermz_push_output_bytes(vt, buf, buf.len);
// }

// void vterm_push_output_sprintf_ctrl(VTerm *vt, uint8_t ctrl, const char *fmt, ...)
//   FUNC_ATTR_PRINTF(3, 4)
// {
//   size_t cur;
//
//   if (ctrl >= 0x80 && !vt->mode.ctrl8bit) {
//     cur = (size_t)snprintf(vt->tmpbuffer, vt->tmpbuffer_len, ESC_S "%c", ctrl - 0x40);
//   } else {
//     cur = (size_t)snprintf(vt->tmpbuffer, vt->tmpbuffer_len, "%c", ctrl);
//   }
//
//   if (cur >= vt->tmpbuffer_len) {
//     return;
//   }
//
//   va_list args;
//   va_start(args, fmt);
//   cur += (size_t)vsnprintf(vt->tmpbuffer + cur, vt->tmpbuffer_len - cur, fmt, args);
//   va_end(args);
//
//   if (cur >= vt->tmpbuffer_len) {
//     return;
//   }
//
//   vterm_push_output_bytes(vt, vt->tmpbuffer, cur);
// }
// fn vterm_push_output_sprintf_ctrl(vt: *VTerm, ctrl: u8, fmt: []const u8, args: anytype) void {
//     //   size_t cur;
//     //
//     //   if (ctrl >= 0x80 && !vt->mode.ctrl8bit) {
//     //     cur = (size_t)snprintf(vt->tmpbuffer, vt->tmpbuffer_len, ESC_S "%c", ctrl - 0x40);
//     //   } else {
//     //     cur = (size_t)snprintf(vt->tmpbuffer, vt->tmpbuffer_len, "%c", ctrl);
//     //   }
//     //
//     //   if (cur >= vt->tmpbuffer_len) {
//     //     return;
//     //   }
//     // vt.t.modes.get()
//     // if (ctrl >= 0x80 and !vt.t.)
//     //
//     //   va_list args;
//     //   va_start(args, fmt);
//     //   cur += (size_t)vsnprintf(vt->tmpbuffer + cur, vt->tmpbuffer_len - cur, fmt, args);
//     //   va_end(args);
//     //
//     //   if (cur >= vt->tmpbuffer_len) {
//     //     return;
//     //   }
//     //
//     //   vterm_push_output_bytes(vt, vt->tmpbuffer, cur);
//     // var s = vt.t.vtStream();
//     var s = try ghostty_vt.Stream(u8).initAlloc(vt.allocator7);
//     // vt.t.vtHandler()
//     s.next();
// }

//
// void vterm_push_output_sprintf_str(VTerm *vt, uint8_t ctrl, bool term, const char *fmt, ...)
//   FUNC_ATTR_PRINTF(4, 5)
// {
//   size_t cur = 0;
//
//   if (ctrl) {
//     if (ctrl >= 0x80 && !vt->mode.ctrl8bit) {
//       cur = (size_t)snprintf(vt->tmpbuffer, vt->tmpbuffer_len, ESC_S "%c", ctrl - 0x40);
//     } else {
//       cur = (size_t)snprintf(vt->tmpbuffer, vt->tmpbuffer_len, "%c", ctrl);
//     }
//
//     if (cur >= vt->tmpbuffer_len) {
//       return;
//     }
//   }
//
//   va_list args;
//   va_start(args, fmt);
//   cur += (size_t)vsnprintf(vt->tmpbuffer + cur, vt->tmpbuffer_len - cur, fmt, args);
//   va_end(args);
//
//   if (cur >= vt->tmpbuffer_len) {
//     return;
//   }
//
//   if (term) {
//     cur += (size_t)snprintf(vt->tmpbuffer + cur, vt->tmpbuffer_len - cur,
//                             vt->mode.ctrl8bit ? "\x9C" : ESC_S "\\");  // ST
//
//     if (cur >= vt->tmpbuffer_len) {
//       return;
//     }
//   }
//
//   vterm_push_output_bytes(vt, vt->tmpbuffer, cur);
// }

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

inline fn vterm_mod_to_ghostty_mod(vmod: VTermModifier) ghostty_vt.input.KeyMods {
    return .{
        .alt = vmod & VTERM_MOD_ALT > 0,
        .ctrl = vmod & VTERM_MOD_CTRL > 0,
        .shift = vmod & VTERM_MOD_SHIFT > 0,
    };
}

pub export fn vtermz_keyboard_key(vt: *VTerm, vkey: VTermKey, vmod: VTermModifier) callconv(.c) void {
    const key = vterm_key_to_ghostty_key(vkey) orelse return;
    const mods = vterm_mod_to_ghostty_mod(vmod);
    const evt: ghostty_vt.input.KeyEvent = .{
        .key = key,
        .mods = mods,
        .action = .press,
    };
    // TODO: handle error
    ghostty_vt.input.encodeKey(&vt.keyout_buffer_w, evt, .{}) catch return;
    vt.term_send(vt.keyout_buffer_w.buffered());
    _ = vt.keyout_buffer_w.consumeAll();
}

pub export fn vtermz_keyboard_unichar(vt: *VTerm, ch: u32, vmod: VTermModifier) callconv(.c) void {
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
        passthru = vmod == VTERM_MOD_NONE;
    } else {
        passthru = (vmod & (~VTERM_MOD_SHIFT)) == 0;
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
        vt.term_send(vt.keyout_buffer[0..len]);
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
    vt.term_send(vt.keyout_buffer_w.buffered());
    _ = vt.keyout_buffer_w.consumeAll();
}

// TODO: make this not horrible
fn vcell_fg_bg_from_cell(vt: *VTerm, cell: ghostty_vt.RenderState.Cell) struct { VTermColor, VTermColor } {
    const cell_style: ghostty_vt.Style = if (cell.raw.style_id != 0) cell.style else .{};
    var res: struct { VTermColor, VTermColor } = .{
        .{ .rgb = .{ .type = c.VTERM_COLOR_DEFAULT_FG } },
        .{ .rgb = .{ .type = c.VTERM_COLOR_DEFAULT_BG } },
    };
    if (cell.raw.style_id == 0) {
        res[0].type = c.VTERM_COLOR_DEFAULT_FG;
        res[1].type = c.VTERM_COLOR_DEFAULT_BG;
    } else {
        if (cell_style.fg_color == .palette) {
            res[0] = .{
                .indexed = .{
                    .type = c.VTERM_COLOR_INDEXED,
                    .idx = cell_style.fg_color.palette,
                },
            };
        } else {
            const fg = cell_style.fg(.{
                .default = vt.rs.colors.foreground,
                .palette = &vt.rs.colors.palette,
                .bold = null,
            });
            res[0] = .{
                .rgb = .{
                    .type = 0,
                    .red = fg.r,
                    .green = fg.g,
                    .blue = fg.b,
                },
            };
        }
        if (cell_style.bg_color == .palette) {
            res[1] = .{
                .indexed = .{
                    .type = c.VTERM_COLOR_INDEXED,
                    .idx = cell_style.bg_color.palette,
                },
            };
        } else if (cell_style.bg(&cell.raw, &vt.rs.colors.palette)) |bg| {
            res[1] = .{
                .rgb = .{
                    .type = 0,
                    .red = bg.r,
                    .green = bg.g,
                    .blue = bg.b,
                },
            };
        } else {
            res[1].type = c.VTERM_COLOR_DEFAULT_BG;
        }
    }

    return res;
}

pub export fn vtermz_screen_get_cell(vt: *VTerm, pos: VTermPos, ret: *anyopaque) callconv(.c) c_int {
    //   ScreenCell *intcell = getcell(screen, pos.row, pos.col);
    //   if (!intcell) {
    //     return 0;
    //   }
    // TODO: refactor caller so we can actually make use of MultiArrayLists
    if (pos.row < 0 or pos.row >= vt.rs.row_data.len) return 0;
    const cell_row: ghostty_vt.RenderState.Row = vt.rs.row_data.get(@intCast(pos.row));

    if (pos.col < 0 or pos.col >= cell_row.cells.len) return 0;

    var vcell: VTermScreenCell = .{};
    const cell = cell_row.cells.get(@intCast(pos.col));

    const cell_style: ghostty_vt.Style = if (cell.raw.style_id != 0) cell.style else .{};
    if (cell.raw.hyperlink) {
        std.debug.print("got a hyperlink!", .{});
        // var link_buf: [512]u8 = undefined;
        // var idx: usize = 0;
        // for (cell.grapheme) |g| {
        //     idx += std.unicode.utf8Encode(g, link_buf[idx..]) catch return 0;
        // }
        // std.debug.print("hyperlink: {s}", .{link_buf});
    }

    //   cell->schar = (intcell->schar == (uint32_t)-1) ? 0 : intcell->schar;
    switch (cell.raw.content_tag) {
        .codepoint => {
            const codepoint = cell.raw.content.codepoint;
            // log.warn(@src(), "starting to process single codepoint", .{});
            // if (len > 1) {
            var buf: [4]u8 = undefined;
            const len = std.unicode.utf8Encode(codepoint, &buf) catch return 0;
            // vcell.schar = std.mem.bytesToValue(u32, &buf[0..len]);
            vcell.schar = c.schar_from_buf(&buf, len);
            // log.warn(@src(), "vcell grapheme u21: {s}, vcell grapheme: {s}, width: {}", .{ bytes_hex_leak(vt, buf[0..len]), buf[0..len], cell.raw.gridWidth() });
            // } else {
            //     @branchHint(.likely);
            //     vcell.schar = codepoint;
            //     if (codepoint == 0x00) {
            //         log.warn(@src(), "got null codepoint. skipping.", .{});
            //     } else {
            //         log.warn(@src(), "vcell single grapheme: {c}, width: {}", .{ @as(u8, @intCast(codepoint)), cell.raw.gridWidth() });
            //     }
            // }
            // log.warn(@src(), "finished processing single codepoint", .{});
        },
        .codepoint_grapheme => {
            // TODO: handle links.
            var buf: [c.MAX_SCHAR_SIZE]u8 = undefined;
            var idx: usize = 0;
            // log.warn(@src(), "starting to process grapheme cluster of len {d}", .{cell.grapheme.len});
            // cell.raw.content.codepoint is the first codepoint in the cluster. The
            // remainder are stored in cell.grapheme.
            idx += std.unicode.utf8Encode(cell.raw.content.codepoint, &buf) catch return 0;
            for (cell.grapheme) |g| {
                // log.warn(@src(), "processing grapheme: {d}", .{g});
                // if (g == 8205) log.warn(@src(), "got ZWJ in graheme cluster.", .{});
                idx += std.unicode.utf8Encode(g, buf[idx..]) catch return 0;
            }
            // log.warn(@src(), "vcell grapheme raw: {s}, vcell grapheme: {s}, width: {}", .{ bytes_hex_leak(vt, buf[0..idx]), buf[0..idx], cell.raw.gridWidth() });
            // log.warn(@src(), "finished processing grapheme cluster", .{});
            vcell.schar = c.schar_from_buf(&buf, idx);
        },
        .bg_color_palette, .bg_color_rgb => {
            // vcell.bg = .{
            //     .type = c.VTERM_COLOR_DEFAULT_BG,
            // };
            vcell.schar = 0;
        },
    }

    //   cell->attrs.bold = intcell->pen.bold;
    vcell.attrs.bold = cell_style.flags.bold;
    //   cell->attrs.underline = intcell->pen.underline;
    // underlines: enum {
    //     VTERM_UNDERLINE_OFF,
    //     VTERM_UNDERLINE_SINGLE,
    //     VTERM_UNDERLINE_DOUBLE,
    //     VTERM_UNDERLINE_CURLY,
    // }
    const underline = cell_style.flags.underline.cval();
    if (underline < 4) {
        vcell.attrs.underline = @intCast(underline);
    }
    //   cell->attrs.italic = intcell->pen.italic;
    vcell.attrs.italic = cell_style.flags.italic;
    //   cell->attrs.blink = intcell->pen.blink;
    vcell.attrs.blink = cell_style.flags.blink;
    //   TODO: make sure this is okay
    //   cell->attrs.reverse = intcell->pen.reverse ^ screen->global_reverse;
    vcell.attrs.reverse = cell_style.flags.inverse;
    // TODO: make sure this is right
    //   cell->attrs.conceal = intcell->pen.conceal;
    vcell.attrs.conceal = cell_style.flags.faint;
    //   cell->attrs.strike = intcell->pen.strike;
    vcell.attrs.strike = cell_style.flags.strikethrough;
    //   TODO: no idea what the deal is with font. Are multiple fonts actually supported?
    //   cell->attrs.font = intcell->pen.font;
    //   TODO: no idea what the deal is with small
    //   cell->attrs.small = intcell->pen.small;
    //   TODO: no idea what the deal is with baseline
    //   cell->attrs.baseline = intcell->pen.baseline;
    //   TODO: not sure what these double width things are
    //   cell->attrs.dwl = intcell->pen.dwl;
    //   cell->attrs.dhl = intcell->pen.dhl;
    vcell.attrs.dwl = false;
    vcell.attrs.dhl = 0;

    vcell.width = cell.raw.gridWidth();

    //   cell->fg = intcell->pen.fg;
    //   cell->bg = intcell->pen.bg;
    const fg, const bg = vcell_fg_bg_from_cell(vt, cell);
    vcell.fg = fg;
    vcell.bg = bg;

    // if (vcell.schar == ' ') {
    //   std.debug.print("vcellfg: {}, vcellbg: {}", .{vcell.fg, vcell.bg});
    // }

    // const raw_value: u32 = std.math.maxInt(u32);
    // vcell.attrs = @bitCast(raw_value);

    // TODO: figure out what the deal is with this.
    //   cell->uri = intcell->pen.uri;
    //
    // vcell.width = 1;
    // TODO: figure out what the deal is with this.
    //   if (pos.col < (screen->cols - 1)
    //       && getcell(screen, pos.row, pos.col + 1)->schar == (uint32_t)-1) {
    //     cell->width = 2;
    //   } else {
    //     cell->width = 1;
    //   }
    // if (pos.col < vt.t.cols - 1) {
    //     const adj = cell_row.cells.get(@intCast(pos.col + 1));
    //     _ = adj;
    //     // if (adj.raw.content_tag == .codepoint and adj.raw.content.codepoint == '\\') {
    //     //     vcell.width = 2;
    //     // }
    // }
    // TODO: figure out why cells with spaces don't have the same colors as libvterm.
    // This typically sets them to have the default fg/bg, whereas libvterm seems to use rgb
    // colors.
    // if (vcell.schar == 0 and (vcell.fg.type != c.VTERM_COLOR_DEFAULT_FG or vcell.bg.type != c.VTERM_COLOR_DEFAULT_BG)) {
    //     @panic("empty schar has wrong colors");
    //     // std.debug.print("empty schar has wrong colors. fg type: {}, bg type: {}", .{vcell.fg.type, vcell.bg.type});
    // }
    // if (vcell.schar == '~') {
    //     const adj = cell_row.cells.get(@intCast(pos.col + 10));
    //     // std.debug.print("adjacent style ID: {}", .{adj.raw.style_id});
    //     const adj_fg, const adj_bg = vcell_fg_bg_from_cell(vt, adj);
    //     std.debug.print("adj fg type: {}, adj_bg type: {}\n", .{ adj_fg.type, adj_bg.type });
    //     if (adj.raw.content_tag == .codepoint) {
    //       std.debug.print("adj codepoint: {}\n", .{adj.raw.content.codepoint});
    //     }
    //     if (adj_fg.type & 1 > 0) {
    //         std.debug.print("adj fg ind: {}\n", .{adj_fg.indexed.idx});
    //     }
    //     if (adj_bg.type & 1 > 0) {
    //         std.debug.print("adj bg ind: {}\n", .{adj_bg.indexed.idx});
    //     }
    // }

    c.vterm_screen_cell_setz(&vcell, ret);

    //
    //   return 1;
    return 1;
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

pub export fn vtermz_update(vt: *VTerm) callconv(.c) void {
    vt.rs.update(vt.allocator, vt.t) catch preserve_exit(e_outofmem);
}

pub export fn vtermz_get_size(vt: *const VTerm, rowsp: ?*c_int, colsp: ?*c_int) callconv(.c) void {
    if (rowsp) |row| {
        row.* = vt.t.rows;
    }
    if (colsp) |col| {
        col.* = vt.t.cols;
    }
}

pub export fn vtermz_set_size(vt: *VTerm, rows: c_int, cols: c_int) callconv(.c) void {
    if (rows < 1 or cols < 1) {
        return;
    }

    // TODO: is there even anything we can do if it errors?
    vt.t.resize(vt.allocator, @intCast(cols), @intCast(rows)) catch return;

    // TODO: figure out if we need parser callbacks. Probably not.
    // const callbacks = vt.parser.callbacks orelse return;
    // const resize = callbacks.resize orelse return;
    // const cbdata = vt.parser.cbdata orelse return;
    // _ = resize(rows, cols, cbdata);
}

// DONE
pub export fn vtermz_set_utf8(vt: *VTerm, is_utf8: bool) callconv(.c) void {
    vt.t.configureCharset(.G0, if (is_utf8) .utf8 else .ascii);
    // vt.t.configureCharset(.G1, if (is_utf8) .utf8 else .ascii);
    // vt.t.configureCharset(.G2, if (is_utf8) .utf8 else .ascii);
    // vt.t.configureCharset(.G3, if (is_utf8) .utf8 else .ascii);
}

// DONE
pub export fn vtermz_state_set_palette_color(vt: *VTerm, index: c_int, col: *const VTermColor) callconv(.c) void {
    if (index >= 0 and index < 16) vt.t.colors.palette.set(@intCast(index), .{
        .r = col.rgb.red,
        .g = col.rgb.green,
        .b = col.rgb.blue,
    });
}

// // 263:        VTERM_TERMINATOR_BEL ? STATIC_CSTR_AS_OBJ("\x07") : STATIC_CSTR_AS_OBJ("\x1b\\"));
// // 354:        VTermState *state = vterm_obtain_state(term->vt);
// // 356:        vterm_state_set_penattr(state, VTERM_ATTR_URI, VTERM_VALUETYPE_INT, &value);
// // 465:  VTermState *state = vterm_obtain_state(term->vt);
// // 467:  term->vts = vterm_obtain_screen(term->vt);
// // 468:  vterm_screen_enable_altscreen(term->vts, true);
// // 469:  vterm_screen_enable_reflow(term->vts, true);
// // 471:  vterm_screen_set_callbacks(term->vts, &vterm_screen_callbacks, term);
// // 472:  vterm_screen_set_unrecognised_fallbacks(term->vts, &vterm_fallbacks, term);
// // 473:  vterm_screen_set_damage_merge(term->vts, VTERM_DAMAGE_SCROLL);
// // 474:  vterm_screen_reset(term->vts, 1);
// // 478:  vterm_state_set_selection_callbacks(state, &vterm_selection_callbacks, term,
// // 493:  vterm_state_set_termprop(state, VTERM_PROP_CURSORSHAPE, &cursor_shape);
// // 501:  vterm_state_set_termprop(state, VTERM_PROP_CURSORBLINK, &cursor_blink);
// // 563:        vterm_color_rgb(&color,
// // 567:        vterm_state_set_palette_color(state, i, &color);
// // 687:  vterm_screen_flush_damage(term->vts);
// // 1122:  vterm_keyboard_start_paste(curbuf->terminal->vt);
// // 1156:  vterm_keyboard_end_paste(curbuf->terminal->vt);
// // 1171:    vterm_keyboard_key(term->vt, key, mod);
// // 1173:    vterm_keyboard_unichar(term->vt, (uint32_t)c, mod);
// // 1193:    vterm_input_write(term->vt, crlf_data.items, kv_size(crlf_data));
// // 1196:    vterm_input_write(term->vt, data, len);
// // 1198:  vterm_screen_flush_damage(term->vts);
// // 1203:  vterm_state_convert_color_to_rgb(state, &color);
// // 1227:  VTermState *state = vterm_obtain_state(term->vt);
// // 1240:    bool fg_default = !color_valid || VTERM_COLOR_IS_DEFAULT_FG(&cell.fg);
// // 1241:    bool bg_default = !color_valid || VTERM_COLOR_IS_DEFAULT_BG(&cell.bg);
// // 1247:    bool fg_indexed = VTERM_COLOR_IS_INDEXED(&cell.fg);
// // 1248:    bool bg_indexed = VTERM_COLOR_IS_INDEXED(&cell.bg);
// // 1315:  VTermState *state = vterm_obtain_state(term->vt);
// // 1317:    vterm_state_focus_in(state);
// // 1319:    vterm_state_focus_out(state);
// // 1911:  vterm_mouse_move(term->vt, row, col, mod);
// // 1913:    vterm_mouse_button(term->vt, button, pressed, mod);
// // 2081:    vterm_screen_get_cell(term->vts, (VTermPos){ .row = row, .col = col },

// VTermValueType vterm_get_attr_type(VTermAttr attr)
// {
//   switch (attr) {
//   case VTERM_ATTR_BOLD:
//     return VTERM_VALUETYPE_BOOL;
//   case VTERM_ATTR_UNDERLINE:
//     return VTERM_VALUETYPE_INT;
//   case VTERM_ATTR_ITALIC:
//     return VTERM_VALUETYPE_BOOL;
//   case VTERM_ATTR_BLINK:
//     return VTERM_VALUETYPE_BOOL;
//   case VTERM_ATTR_REVERSE:
//     return VTERM_VALUETYPE_BOOL;
//   case VTERM_ATTR_CONCEAL:
//     return VTERM_VALUETYPE_BOOL;
//   case VTERM_ATTR_STRIKE:
//     return VTERM_VALUETYPE_BOOL;
//   case VTERM_ATTR_FONT:
//     return VTERM_VALUETYPE_INT;
//   case VTERM_ATTR_FOREGROUND:
//     return VTERM_VALUETYPE_COLOR;
//   case VTERM_ATTR_BACKGROUND:
//     return VTERM_VALUETYPE_COLOR;
//   case VTERM_ATTR_SMALL:
//     return VTERM_VALUETYPE_BOOL;
//   case VTERM_ATTR_BASELINE:
//     return VTERM_VALUETYPE_INT;
//   case VTERM_ATTR_URI:
//     return VTERM_VALUETYPE_INT;
//
//   case VTERM_N_ATTRS:
//     return 0;
//   }
//   return 0;  // UNREACHABLE
// }
