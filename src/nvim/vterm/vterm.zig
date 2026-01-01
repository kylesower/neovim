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
const c = @cImport({
    @cInclude("stdarg.h");
    @cInclude("stdio.h");
    @cInclude("stdlib.h");
    @cInclude("string.h");
    @cInclude("auto/config.h");
    @cInclude("nvim/main.h");
    @cInclude("nvim/memory.h");
    @cInclude("nvim/errors.h");
    @cInclude("nvim/vterm/screen.h");
    @cInclude("nvim/vterm/state.h");
});
const std = @import("std");
const ghostty_vt = @import("ghostty-vt");
// TODO: set logFn to log to nvim log file

fn test_preserve_exit(e: [*c]const u8) noreturn {
    _ = e;
    std.process.exit(1);
}

const preserve_exit = if (@import("builtin").is_test) test_preserve_exit else c.preserve_exit;
const e_outofmem = if (@import("builtin").is_test) "ERROR: out of memory" else c.e_outofmem;
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
// pub const VTermPos = extern struct {
//     row: c_int,
//     col: c_int,
// };
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
        red: u8,
        green: u8,
        blue: u8,
    },
    indexed: extern struct {
        type: u8,
        idx: u8,
    },
};
//
// // typedef struct {
// //   unsigned bold      : 1;
// //   unsigned underline : 2;
// //   unsigned italic    : 1;
// //   unsigned blink     : 1;
// //   unsigned reverse   : 1;
// //   unsigned conceal   : 1;
// //   unsigned strike    : 1;
// //   unsigned font      : 4;  // 0 to 9
// //   unsigned dwl       : 1;  // On a DECDWL or DECDHL line
// //   unsigned dhl       : 2;  // On a DECDHL line (1=top 2=bottom)
// //   unsigned small     : 1;
// //   unsigned baseline  : 2;
// // } VTermScreenCellAttrs;
// pub const VTermScreenCellAttrs = extern struct {
//     bold: bool,
//     underline: u8, // was u2
//     italic: bool,
//     blink: bool,
//     reverse: bool,
//     conceal: bool,
//     strike: bool,
//     font: u8, // 0 to 9. was u2
//     dwl: bool, // On a DECDWL or DECDHL line
//     dhl: u8, // On a DECDHL line (1=top 2=bottom). was u2
//     small: bool,
//     baseline: u8, // was u2
// };
//
// // typedef struct {
// //   schar_T schar;
// //   char width;
// //   VTermScreenCellAttrs attrs;
// //   VTermColor fg, bg;
// //   int uri;
// // } VTermScreenCell;
// pub const VTermScreenCell = extern struct {
//     schar: u32,
//     width: u8,
//     attrs: VTermScreenCellAttrs,
//     fg: VTermColor,
//     bg: VTermColor,
//     uri: c_int,
// };
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
// pub const VTermProp = enum(u8) {
//     // VTERM_PROP_NONE = 0
//     cursorvisible = 1, // bool
//     cursorblink, // bool
//     altscreen, // bool
//     title, // string
//     iconname, // string
//     reverse, // bool
//     cursorshape, // number
//     mouse, // number
//     focusreport, // bool
//     themeupdates, // bool
// };
//
// // typedef enum {
// //   VTERM_TERMINATOR_BEL,  // \x07
// //   VTERM_TERMINATOR_ST,  // \x1b\x5c
// // } VTermTerminator;
// pub const VTermTerminator = enum(u8) {
//     bel,
//     st,
// };
//
// // typedef struct {
// //   const char *str;
// //   size_t len : 30;
// //   bool initial : 1;
// //   bool final : 1;
// //   VTermTerminator terminator;
// // } VTermStringFragment;
// // Sorry, this struct isn't packed nicely...
// pub const VTermStringFragment = extern struct {
//     str: [*]u8,
//     len: u32,
//     initial: bool,
//     final: bool,
//     terminator: VTermTerminator,
// };
//
// // typedef union {
// //   int boolean;
// //   int number;
// //   VTermStringFragment string;
// //   VTermColor color;
// // } VTermValue;
// pub const VTermValue = extern union {
//     boolean: c_int,
//     number: c_int,
//     string: VTermStringFragment,
//     color: VTermColor,
// };
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
//     damage: *const fn (rect: VTermRect, user: *anyopaque) callconv(.c) c_int,
//     moverect: *const fn (dest: VTermRect, src: VTermRect, user: *anyopaque) callconv(.c) c_int,
//     movecursor: *const fn (
//         pos: VTermPos,
//         oldpos: VTermPos,
//         visible: c_int,
//         user: *anyopaque,
//     ) callconv(.c) c_int,
//     settermprop: *const fn (
//         prop: VTermProp,
//         val: *VTermValue,
//         user: *anyopaque,
//     ) callconv(.c) c_int,
//     bell: *const fn (user: *anyopaque) callconv(.c) c_int,
//     resize: *const fn (rows: c_int, cols: c_int, user: *anyopaque) callconv(.c) c_int,
//     theme: *const fn (dark: *bool, user: *anyopaque) callconv(.c) c_int,
//     sb_pushline: *const fn (
//         cols: c_int,
//         cells: [*]const VTermScreenCell,
//         user: *anyopaque,
//     ) callconv(.c) c_int,
//     sb_popline: *const fn (
//         cols: c_int,
//         cells: [*]VTermScreenCell,
//         user: *anyopaque,
//     ) callconv(.c) c_int,
//     sb_clear: *const fn (user: *anyopaque) callconv(.c) c_int,
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
const VTermOutputCallback = *const fn (s: [*]const u8, len: usize, user: *anyopaque) callconv(.c) void;
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
pub const APC_BUF_DEFAULT_SIZE = 4096;
const Terminal = ghostty_vt.Terminal;
pub const VTerm = struct {
    t: ghostty_vt.Terminal,
    rs: ghostty_vt.RenderState,
    parser: ghostty_vt.Parser,
    outfunc: ?VTermOutputCallback,
    outdata: ?*anyopaque,
    allocator: std.mem.Allocator,
    // One for primary and one for alternate screen
    key_encoding_stack: struct {
        primary: VTermKeyEncodingStack,
        alternate: VTermKeyEncodingStack,
    },
    apc_buf: std.ArrayList(u8),

    const Self = @This();
    pub fn reset_apc_buf(self: *Self) void {
        if (self.apc_buf.items.len > APC_BUF_DEFAULT_SIZE) {
            self.apc_buf.shrinkAndFree(self.allocator, APC_BUF_DEFAULT_SIZE);
        }
        self.apc_buf.items.len = 0;
    }
};

// DONE
pub export fn vtermz_new(rows: c_int, cols: c_int) callconv(.c) *VTerm {
    var gpa: std.heap.DebugAllocator(.{}) = .init;
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();

    const t: ghostty_vt.Terminal = ghostty_vt.Terminal.init(alloc, .{
        .rows = @intCast(rows),
        .cols = @intCast(cols),
    }) catch preserve_exit(e_outofmem);
    const rs: ghostty_vt.RenderState = .empty;

    var vt = alloc.create(VTerm) catch preserve_exit(e_outofmem);
    vt.t = t;
    vt.rs = rs;
    vt.parser = ghostty_vt.Parser.init();
    vt.parser.osc_parser.alloc = vt.allocator;
    vt.apc_buf = std.ArrayList(u8).initCapacity(alloc, APC_BUF_DEFAULT_SIZE) catch preserve_exit(e_outofmem);
    vt.allocator = alloc;
    return vt;
}

// DONE
pub export fn vtermz_free(vt: *VTerm) callconv(.c) void {
    vt.t.deinit(vt.allocator);
    vt.rs.deinit(vt.allocator);
    vt.parser.deinit();
    vt.allocator.destroy(vt);
}

// void vterm_keyboard_unichar(VTerm *vt, uint32_t c, VTermModifier mod)
// void vterm_keyboard_key(VTerm *vt, VTermKey key, VTermModifier mod)
// size_t vterm_input_write(VTerm *vt, const char *bytes, size_t len)
pub export fn vtermz_input_write(vt: *VTerm, bytes: [*]const u8, len: usize) callconv(.c) usize {
    // const input = "\x1b]4;1;?\x1b\\";
    var osc_last_terminator: ghostty_vt.osc.Terminator = .bel;
    var last_action: ghostty_vt.Parser.Action = .apc_start;
    // TODO: figure out a good tmp buffer size. We use this buffer so we can appendSlice
    // rather than append one byte at a time.
    const TMP_APC_BUF_LEN = 256;
    var tmp_apc_buf: [TMP_APC_BUF_LEN]u8 = .{0} ** TMP_APC_BUF_LEN;
    var tmp_apc_buf_len: usize = 0;
    for (0..len) |i| {
        const b = bytes[i];
        // std.debug.print("parsing byte: {x}\n", .{b});
        for (vt.parser.next(b)) |action| if (action) |a| {
            switch (a) {
                .print => |ch| {
                    // std.debug.print("WAT: got ch {x}\n", .{ch});
                    vt.t.print(ch) catch {};
                    // _ = ch;
                    // TODO: dunno what to do with error
                    // vt.t.print(ch) catch continue;
                    // std.debug.print("got ch: {}\n", .{ch});

                },
                .csi_dispatch => |csi| {
                    // TODO: yeah, this will suck
                    // std.debug.print("WAT: got csi dispatch\n", .{});
                    _ = csi;
                },
                .apc_start => {
                    // std.debug.print("WAT: got apc start\n", .{});
                },
                .apc_put => |ch| {
                    tmp_apc_buf[tmp_apc_buf_len] = ch;
                    tmp_apc_buf_len += 1;
                    if (tmp_apc_buf_len == TMP_APC_BUF_LEN) {
                        vt.apc_buf.appendSlice(
                            vt.allocator,
                            &tmp_apc_buf,
                        ) catch preserve_exit(e_outofmem);
                        tmp_apc_buf_len = 0;
                    }
                },
                .apc_end => {
                    vt.apc_buf.appendSlice(
                        vt.allocator,
                        tmp_apc_buf[0..tmp_apc_buf_len],
                    ) catch preserve_exit(e_outofmem);
                    // std.debug.print("got apc command: {s}\n", .{vt.apc_buf.items});
                    // TODO: call callback for APC
                    vt.reset_apc_buf();
                },
                .dcs_hook => {
                    // std.debug.print("WAT: got dcs hook\n", .{});
                },
                .dcs_put => {
                    // std.debug.print("WAT: got dcs put\n", .{});
                },
                .dcs_unhook => {
                    // std.debug.print("WAT: got dcs unhook\n", .{});
                },
                .esc_dispatch => |esc| {
                    // // When using the ST rather than BEL, osc_dispatch executes on \x1b, and
                    // // when we parse the following \x5c, it generates an esc_dispatch with \x5c.
                    // std.debug.print("esc dispatch intermed len: {}\n", .{esc.intermediates.len});
                    // if (last_action == .osc_dispatch and osc_last_terminator == .st and esc.intermediates.len == 0 and esc.final == '\\') {
                    //     std.debug.print("SKIPPING: got esc_dispatch: {f}\n", .{esc});
                    //     continue;
                    // }
                    if (esc.intermediates.len == 0 and esc.final == '\\') continue;
                    if (esc.intermediates.len == 0) switch (esc.final) {
                        // TODO: get rid of duplication with the .execute branch.
                        'D' => vt.t.cursorDown(1),
                        'E' => {
                            vt.t.carriageReturn();
                            vt.t.linefeed() catch {};
                        },
                        'H' => vt.t.tabSet(),
                        else => {
                            // std.debug.print("unimplemented esc.final: {x}", .{esc.final});
                        },
                    } else {
                        // Ignore charset stuff for now.
                        // const slot: ghostty_vt.CharsetSlot = switch (esc.intermediates[0]) {
                        //     '(' => .G0,
                        //     ')' => .G1,
                        //     '*' => .G2,
                        //     '+' => .G3,
                        //     // TODO: buffer and rendering controls, ANSI conformance levels?
                        //     else => @panic("unimplemented intermediate"),
                        // };
                        // switch (esc.final) {
                        //     'B' => vt.t.configureCharset(slot, .ascii),
                        //     '0' => vt.t.configureCharset(slot, .dec_special),
                        //     'A' => vt.t.configureCharset(slot, .british),
                        //     else => @panic("unimplemented charset"),
                        // }
                    }
                },
                .execute => |exe| {
                    // C0 or C1 function
                    // TODO: change slot controls with vt.t.invokeCharset. i.e. SI and SO controls.
                    switch (exe) {
                        0x07 => {}, // TODO: BEL
                        0x08 => vt.t.backspace(),
                        0x09 => vt.t.horizontalTab() catch {},
                        0x0A => vt.t.linefeed() catch {},
                        0x0D => vt.t.carriageReturn(),
                        0x84 => vt.t.cursorDown(1), // ESC D (IND/index)
                        0x85 => { // ESC E (NEL/next line/CRLF)
                            vt.t.carriageReturn();
                            // TODO: do anything with error?
                            vt.t.linefeed() catch {};
                        },
                        0x88 => vt.t.tabSet(), // ESC H (HTS/set horizontal tab stop)
                        else => {},
                        // 0x90 => @panic("C1 dcs inducer"),
                        // 0x9B => @panic("C1 execute csi"),
                        // 0x9D => @panic("C1 execute osc command"),
                        // 0x9C => @panic("C1 ST"),
                        // else => @panic("unimplemented C0 or C1"),
                    }
                },
                .osc_dispatch => |osc| {
                    _ = osc;
                    osc_last_terminator = if (b == '\x1b') .st else .bel;
                    // std.debug.print("last byte: {x}, osc last terminator: {any}\n", .{ b, osc_last_terminator });
                    // if (osc.color_operation.terminator)
                    // std.debug.print("osc: {}\n", .{osc});
                },
            }
            last_action = a;
            // std.debug.print("last action now: {any}\n", .{last_action});
        };
    }
    return 0;
}

// DONE
pub export fn vtermz_output_set_callback(
    vt: *VTerm,
    func: VTermOutputCallback,
    user: *anyopaque,
) callconv(.c) void {
    vt.outfunc = func;
    vt.outdata = user;
}

// static VTermKeyEncodingFlags vterm_state_get_key_encoding_flags(const VTermState *state)
// {
//   int screen = state->mode.alt_screen ? BUFIDX_ALTSCREEN : BUFIDX_PRIMARY;
//   const struct VTermKeyEncodingStack *stack = &state->key_encoding_stacks[screen];
//   assert(stack->size > 0);
//   return stack->items[stack->size - 1];
// }
pub fn vtermz_state_get_key_encoding_flags(vt: *const VTerm) VTermKeyEncodingFlags {
    const stack = switch (vt.t.screens.active_key) {
        .primary => vt.key_encoding_stack.primary,
        .alternate => vt.key_encoding_stack.alternate,
    };
    std.debug.assert(stack.size > 0);
    return stack.items[stack.size - 1];
}

pub export fn vtermz_keyboard_key(vt: *VTerm, key: VTermKey, mod: VTermModifier) callconv(.c) void {
    if (key == .none) {
        return;
    }

    // VTermKeyEncodingFlags flags = vterm_state_get_key_encoding_flags(vt->state);
    var flags = vtermz_state_get_key_encoding_flags(vt);
    // keycodes_s k;
    var k: KeyCodes = undefined;
    // if (key < VTERM_KEY_FUNCTION_0) {
    //   if (key >= sizeof(keycodes)/sizeof(keycodes[0])) {
    //     return;
    //   }
    //   k = keycodes[key];
    if (@intFromEnum(key) < @intFromEnum(VTermKey.function_0)) {
        if (@intFromEnum(key) >= keycodes.len) {
            return;
        }
        k = keycodes[@intCast(@intFromEnum(key))];
        // } else if (key >= VTERM_KEY_FUNCTION_0 && key <= VTERM_KEY_FUNCTION_MAX) {
        //   if ((key - VTERM_KEY_FUNCTION_0) >= sizeof(keycodes_fn)/sizeof(keycodes_fn[0])) {
        //     return;
        //   }
        //   k = keycodes_fn[key - VTERM_KEY_FUNCTION_0];
    } else if (@intFromEnum(key) >= @intFromEnum(VTermKey.function_0) and @intFromEnum(key) <= @intFromEnum(VTermKey.function_max)) {
        if ((@intFromEnum(key) - @intFromEnum(VTermKey.function_0)) >= keycodes_fn.len) {
            return;
        }
        k = keycodes_fn[@intCast(@intFromEnum(key) - @intFromEnum(VTermKey.function_0))];
        // } else if (key >= VTERM_KEY_KP_0) {
        //   if ((key - VTERM_KEY_KP_0) >= sizeof(keycodes_kp)/sizeof(keycodes_kp[0])) {
        //     return;
        //   }
        //   if (flags.disambiguate) {
        //     k = keycodes_kp_csiu[key - VTERM_KEY_KP_0];
        //   } else {
        //     k = keycodes_kp[key - VTERM_KEY_KP_0];
        //   }
    } else if (@intFromEnum(key) >= @intFromEnum(VTermKey.kp_0)) {
        if ((@intFromEnum(key) - @intFromEnum(VTermKey.kp_0)) >= keycodes_kp.len) {
            return;
        }
        const idx: usize = @intCast(@intFromEnum(key) - @intFromEnum(VTermKey.kp_0));
        if (flags.disambiguate) {
            k = keycodes_kp_csiu[idx];
        } else {
            k = keycodes_kp[idx];
        }
    }
    // }

    sw: switch (k.type) {
        // case KEYCODE_NONE:
        //   break;
        .none => {},
        // case KEYCODE_TAB:
        //   // Shift-Tab is CSI Z but plain Tab is 0x09
        //   if (flags.disambiguate) {
        //     goto case_LITERAL;
        //   } else if (mod == VTERM_MOD_SHIFT) {
        //     vterm_push_output_sprintf_ctrl(vt, C1_CSI, "Z");
        //   } else if (mod & VTERM_MOD_SHIFT) {
        //     vterm_push_output_sprintf_ctrl(vt, C1_CSI, "1;%dZ", mod + 1);
        //   } else {
        //     goto case_LITERAL;
        //   }
        //   break;
        .tab => {
            if (flags.disambiguate) {
                continue :sw .literal;
            } else if (mod == VTERM_MOD_SHIFT) {
                // TODO:
                // vterm_push_output_sprintf_ctrl(vt, C1_CSI, "Z");
            } else if ((mod & VTERM_MOD_SHIFT) == VTERM_MOD_SHIFT) {
                // TODO:
                // vterm_push_output_sprintf_ctrl(vt, C1_CSI, "1;%dZ", mod + 1);
            } else {
                continue :sw .literal;
            }
        },
        // case KEYCODE_ENTER:
        //   // Enter is CRLF in newline mode, but just LF in linefeed
        //   if (vt->state->mode.newline) {
        //     vterm_push_output_sprintf(vt, "\r\n");
        //   } else {
        //     goto case_LITERAL;
        //   }
        //   break;
        .enter => {
            // TODO:
            // if (vt.state->mode.newline) {
            if (false) {
                // vterm_push_output_sprintf(vt, "\r\n");
            } else {
                continue :sw .literal;
            }
        },
        // case KEYCODE_LITERAL:
        //                       case_LITERAL:
        //   if (flags.disambiguate) {
        //     switch (key) {
        //     case VTERM_KEY_TAB:
        //     case VTERM_KEY_ENTER:
        //     case VTERM_KEY_BACKSPACE:
        //       // If there are no mods then leave these as-is
        //       flags.disambiguate = mod != VTERM_MOD_NONE;
        //       break;
        //     default:
        //       break;
        //     }
        //   }
        //
        //   if (flags.disambiguate) {
        //     vterm_push_output_sprintf_ctrl(vt, C1_CSI, "%d;%du", k.literal, mod + 1);
        //   } else {
        //     vterm_push_output_sprintf(vt, mod & VTERM_MOD_ALT ? ESC_S "%c" : "%c", k.literal);
        //   }
        //   break;
        .literal => {
            if (flags.disambiguate) {
                switch (key) {
                    .tab, .enter, .backspace => flags.disambiguate = mod != VTERM_MOD_NONE,
                    else => {},
                }
            }

            //   TODO:
            //   if (flags.disambiguate) {
            //     vterm_push_output_sprintf_ctrl(vt, C1_CSI, "%d;%du", k.literal, mod + 1);
            //   } else {
            //     vterm_push_output_sprintf(vt, mod & VTERM_MOD_ALT ? ESC_S "%c" : "%c", k.literal);
            //   }
        },
        // case KEYCODE_SS3:
        //                   case_SS3:
        //   if (mod == 0) {
        //     vterm_push_output_sprintf_ctrl(vt, C1_SS3, "%c", k.literal);
        //   } else {
        //     goto case_CSI;
        //   }
        //   break;
        .ss3 => {
            if (mod == 0) {
                // TODO:
                // vterm_push_output_sprintf_ctrl(vt, C1_SS3, "%c", k.literal);
            } else {
                continue :sw .csi;
            }
        },
        // case KEYCODE_CSI:
        //                   case_CSI:
        //   if (mod == 0) {
        //     vterm_push_output_sprintf_ctrl(vt, C1_CSI, "%c", k.literal);
        //   } else {
        //     vterm_push_output_sprintf_ctrl(vt, C1_CSI, "1;%d%c", mod + 1, k.literal);
        //   }
        //   break;
        .csi => {
            if (mod == 0) {
                // TODO:
                // vterm_push_output_sprintf_ctrl(vt, C1_CSI, "%c", k.literal);
            } else {
                // TODO:
                // vterm_push_output_sprintf_ctrl(vt, C1_CSI, "1;%d%c", mod + 1, k.literal);
            }
        },
        // case KEYCODE_CSINUM:
        //   if (mod == 0) {
        //     vterm_push_output_sprintf_ctrl(vt, C1_CSI, "%d%c", k.csinum, k.literal);
        //   } else {
        //     vterm_push_output_sprintf_ctrl(vt, C1_CSI, "%d;%d%c", k.csinum, mod + 1, k.literal);
        //   }
        //   break;
        .csinum => {
            if (mod == 0) {
                // TODO:
                // vterm_push_output_sprintf_ctrl(vt, C1_CSI, "%d%c", k.csinum, k.literal);
            } else {
                // TODO:
                // vterm_push_output_sprintf_ctrl(vt, C1_CSI, "%d;%d%c", k.csinum, mod + 1, k.literal);
            }
        },
        // case KEYCODE_CSI_CURSOR:
        //   if (vt->state->mode.cursor) {
        //     goto case_SS3;
        //   } else {
        //     goto case_CSI;
        //   }
        .csi_cursor => {
            // TODO:
            // if (vt->state->mode.cursor) {
            if (false) {
                continue :sw .ss3;
            } else {
                continue :sw .csi;
            }
        },
        // case KEYCODE_KEYPAD:
        //   if (vt->state->mode.keypad) {
        //     k.literal = k.csinum;
        //     goto case_SS3;
        //   } else {
        //     goto case_LITERAL;
        //   }
        // }
        .keypad => {
            // TODO:
            // if (vt->state->mode.keypad) {
            if (false) {
                k.literal = k.csinum;
                continue :sw .ss3;
            } else {
                continue :sw .literal;
            }
        },
    }
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
    try std.testing.expectEqual(res, 1);
}

pub export fn vtermz_update(vt: *VTerm) callconv(.c) void {
    vt.rs.update(vt.allocator, &vt.t) catch preserve_exit(e_outofmem);
}

// // #define DEFAULT(v, def)  ((v) ? (v) : (def))
// pub export fn vterm_build(builder: *const VTermBuilder) *VTerm {
//     //   const VTermAllocatorFunctions *allocator = DEFAULT(builder->allocator, &default_allocator);
//     const allocator = if (builder.allocator) |a| a else &default_allocator;
//     //   // Need to bootstrap using the allocator function directly
//     //   VTerm *vt = (*allocator->malloc)(sizeof(VTerm), builder->allocdata);
//     var vt: *VTerm = @ptrCast(@alignCast(allocator.malloc(@sizeOf(VTerm), builder.allocdata)));
//     //   vt->allocator = allocator;
//     vt.allocator = allocator;
//     //   vt->allocdata = builder->allocdata;
//     vt.allocdata = builder.allocdata;
//     //   vt->rows = builder->rows;
//     vt.rows = builder.rows;
//     //   vt->cols = builder->cols;
//     vt.cols = builder.cols;
//     //   vt->parser.state = NORMAL;
//     vt.parser.state = .normal;
//
//     //   vt->parser.callbacks = NULL;
//     vt.parser.callbacks = null;
//     //   vt->parser.cbdata = NULL;
//     vt.parser.cbdata = null;
//     //   vt->parser.emit_nul = false;
//     vt.parser.emit_nul = false;
//     //   vt->outfunc = NULL;
//     vt.outfunc = null;
//     //   vt->outdata = NULL;
//     vt.outdata = null;
//     //   vt->outbuffer_len = DEFAULT(builder->outbuffer_len, 4096);
//     vt.outbuffer_len = builder.outbuffer_len;
//     //   vt->outbuffer_cur = 0;
//     vt.outbuffer_cur = 0;
//     //   vt->outbuffer = vterm_allocator_malloc(vt, vt->outbuffer_len);
//     vt.outbuffer = @ptrCast(vterm_allocator_malloc(vt, vt.outbuffer_len));
//     //   vt->tmpbuffer_len = DEFAULT(builder->tmpbuffer_len, 4096);
//     vt.tmpbuffer_len = builder.tmpbuffer_len;
//     //   vt->tmpbuffer = vterm_allocator_malloc(vt, vt->tmpbuffer_len);
//     vt.tmpbuffer = @ptrCast(vterm_allocator_malloc(vt, vt.tmpbuffer_len));
//
//     return vt;
// }
//
// const screen = @import("screen.zig");
// const state = @import("state.zig");
// pub export fn vterm_free(vt: *VTerm) callconv(.c) void {
//     if (vt.screen) |s| {
//         screen.vterm_screen_free(s);
//     }
//
//     if (vt.state) |s| {
//         state.vterm_state_free(s);
//     }
//
//     vterm_allocator_free(vt, vt.outbuffer);
//     vterm_allocator_free(vt, vt.tmpbuffer);
//
//     vterm_allocator_free(vt, vt);
// }
//
// pub export fn vterm_allocator_malloc(vt: *VTerm, size: usize) callconv(.c) *anyopaque {
//     return vt.allocator.malloc(size, vt.allocdata);
// }
//
// pub export fn vterm_allocator_free(vt: *VTerm, ptr: *anyopaque) callconv(.c) void {
//     vt.allocator.free(ptr, vt.allocdata);
// }

// DONE
pub export fn vtermz_get_size(vt: *const VTerm, rowsp: ?*c_int, colsp: ?*c_int) callconv(.c) void {
    if (rowsp) |row| {
        row.* = vt.t.rows;
    }
    if (colsp) |col| {
        col.* = vt.t.cols;
    }
}

// DONE
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
}

// DONE
pub export fn vtermz_state_set_palette_color(vt: *VTerm, index: c_int, col: *const VTermColor) callconv(.c) void {
    vt.t.colors.palette.set(@intCast(index), .{
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
// // 1754:    return VTERM_KEY_FUNCTION(1);
// // 1758:    return VTERM_KEY_FUNCTION(2);
// // 1762:    return VTERM_KEY_FUNCTION(3);
// // 1766:    return VTERM_KEY_FUNCTION(4);
// // 1770:    return VTERM_KEY_FUNCTION(5);
// // 1774:    return VTERM_KEY_FUNCTION(6);
// // 1778:    return VTERM_KEY_FUNCTION(7);
// // 1782:    return VTERM_KEY_FUNCTION(8);
// // 1786:    return VTERM_KEY_FUNCTION(9);
// // 1790:    return VTERM_KEY_FUNCTION(10);
// // 1794:    return VTERM_KEY_FUNCTION(11);
// // 1798:    return VTERM_KEY_FUNCTION(12);
// // 1801:    return VTERM_KEY_FUNCTION(13);
// // 1803:    return VTERM_KEY_FUNCTION(14);
// // 1805:    return VTERM_KEY_FUNCTION(15);
// // 1807:    return VTERM_KEY_FUNCTION(16);
// // 1809:    return VTERM_KEY_FUNCTION(17);
// // 1811:    return VTERM_KEY_FUNCTION(18);
// // 1813:    return VTERM_KEY_FUNCTION(19);
// // 1815:    return VTERM_KEY_FUNCTION(20);
// // 1817:    return VTERM_KEY_FUNCTION(21);
// // 1819:    return VTERM_KEY_FUNCTION(22);
// // 1821:    return VTERM_KEY_FUNCTION(23);
// // 1823:    return VTERM_KEY_FUNCTION(24);
// // 1825:    return VTERM_KEY_FUNCTION(25);
// // 1827:    return VTERM_KEY_FUNCTION(26);
// // 1829:    return VTERM_KEY_FUNCTION(27);
// // 1831:    return VTERM_KEY_FUNCTION(28);
// // 1833:    return VTERM_KEY_FUNCTION(29);
// // 1835:    return VTERM_KEY_FUNCTION(30);
// // 1837:    return VTERM_KEY_FUNCTION(31);
// // 1839:    return VTERM_KEY_FUNCTION(32);
// // 1841:    return VTERM_KEY_FUNCTION(33);
// // 1843:    return VTERM_KEY_FUNCTION(34);
// // 1845:    return VTERM_KEY_FUNCTION(35);
// // 1847:    return VTERM_KEY_FUNCTION(36);
// // 1849:    return VTERM_KEY_FUNCTION(37);
// // 1851:    return VTERM_KEY_FUNCTION(38);
// // 1853:    return VTERM_KEY_FUNCTION(39);
// // 1855:    return VTERM_KEY_FUNCTION(40);
// // 1857:    return VTERM_KEY_FUNCTION(41);
// // 1859:    return VTERM_KEY_FUNCTION(42);
// // 1861:    return VTERM_KEY_FUNCTION(43);
// // 1863:    return VTERM_KEY_FUNCTION(44);
// // 1865:    return VTERM_KEY_FUNCTION(45);
// // 1867:    return VTERM_KEY_FUNCTION(46);
// // 1869:    return VTERM_KEY_FUNCTION(47);
// // 1871:    return VTERM_KEY_FUNCTION(48);
// // 1873:    return VTERM_KEY_FUNCTION(49);
// // 1875:    return VTERM_KEY_FUNCTION(50);
// // 1877:    return VTERM_KEY_FUNCTION(51);
// // 1879:    return VTERM_KEY_FUNCTION(52);
// // 1881:    return VTERM_KEY_FUNCTION(53);
// // 1883:    return VTERM_KEY_FUNCTION(54);
// // 1885:    return VTERM_KEY_FUNCTION(55);
// // 1887:    return VTERM_KEY_FUNCTION(56);
// // 1889:    return VTERM_KEY_FUNCTION(57);
// // 1891:    return VTERM_KEY_FUNCTION(58);
// // 1893:    return VTERM_KEY_FUNCTION(59);
// // 1895:    return VTERM_KEY_FUNCTION(60);
// // 1897:    return VTERM_KEY_FUNCTION(61);
// // 1899:    return VTERM_KEY_FUNCTION(62);
// // 1901:    return VTERM_KEY_FUNCTION(63);
// // 1911:  vterm_mouse_move(term->vt, row, col, mod);
// // 1913:    vterm_mouse_button(term->vt, button, pressed, mod);
// // 2081:    vterm_screen_get_cell(term->vts, (VTermPos){ .row = row, .col = col },

//
// pub export fn vterm_output_set_callback(vt: *VTerm, func: VTermOutputCallback, user: *anyopaque) callconv(.c) void {
//     vt.outfunc = func;
//     vt.outdata = user;
// }
//
// pub export fn vterm_main_thing() void {
//     // Use a debug allocator so we get leak checking. You probably want
//     // to replace this for release builds.
//     var gpa: std.heap.DebugAllocator(.{}) = .init;
//     defer _ = gpa.deinit();
//     const alloc = gpa.allocator();
//
//     // Initialize a terminal.
//     var t: ghostty_vt.Terminal = ghostty_vt.Terminal.init(alloc, .{
//         .cols = 6,
//         .rows = 40,
//     }) catch return;
//     defer t.deinit(alloc);
//
//     // Write some text. It'll wrap because this is too long for our
//     // columns size above (6).
//     t.printString("Hello, World!") catch return;
//
//     // Get the plain string view of the terminal screen.
//     const str = t.plainString(alloc) catch return;
//     defer alloc.free(str);
//     std.debug.print("{s}\n", .{str});
// }

//
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
//
// void vterm_push_output_sprintf(VTerm *vt, const char *format, ...)
//   FUNC_ATTR_PRINTF(2, 3)
// {
//   va_list args;
//   va_start(args, format);
//   size_t len = (size_t)vsnprintf(vt->tmpbuffer, vt->tmpbuffer_len, format, args);
//   vterm_push_output_bytes(vt, vt->tmpbuffer, len);
//   va_end(args);
// }
//
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
//
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
//
// void vterm_scroll_rect(VTermRect rect, int downward, int rightward,
//                        int (*moverect)(VTermRect src, VTermRect dest, void *user),
//                        int (*eraserect)(VTermRect rect, int selective, void *user), void *user)
// {
//   VTermRect src;
//   VTermRect dest;
//
//   if (abs(downward) >= rect.end_row - rect.start_row
//       || abs(rightward) >= rect.end_col - rect.start_col) {
//     // Scroll more than area; just erase the lot
//     (*eraserect)(rect, 0, user);
//     return;
//   }
//
//   if (rightward >= 0) {
//     // rect: [XXX................]
//     // src:     [----------------]
//     // dest: [----------------]
//     dest.start_col = rect.start_col;
//     dest.end_col = rect.end_col - rightward;
//     src.start_col = rect.start_col + rightward;
//     src.end_col = rect.end_col;
//   } else {
//     // rect: [................XXX]
//     // src:  [----------------]
//     // dest:    [----------------]
//     int leftward = -rightward;
//     dest.start_col = rect.start_col + leftward;
//     dest.end_col = rect.end_col;
//     src.start_col = rect.start_col;
//     src.end_col = rect.end_col - leftward;
//   }
//
//   if (downward >= 0) {
//     dest.start_row = rect.start_row;
//     dest.end_row = rect.end_row - downward;
//     src.start_row = rect.start_row + downward;
//     src.end_row = rect.end_row;
//   } else {
//     int upward = -downward;
//     dest.start_row = rect.start_row + upward;
//     dest.end_row = rect.end_row;
//     src.start_row = rect.start_row;
//     src.end_row = rect.end_row - upward;
//   }
//
//   if (moverect) {
//     (*moverect)(dest, src, user);
//   }
//
//   if (downward > 0) {
//     rect.start_row = rect.end_row - downward;
//   } else if (downward < 0) {
//     rect.end_row = rect.start_row - downward;
//   }
//
//   if (rightward > 0) {
//     rect.start_col = rect.end_col - rightward;
//   } else if (rightward < 0) {
//     rect.end_col = rect.start_col - rightward;
//   }
//
//   (*eraserect)(rect, 0, user);
// }
