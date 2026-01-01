// #pragma once
//
// #include <stdarg.h>
//
// #include "nvim/mbyte_defs.h"
// #include "nvim/vterm/vterm_defs.h"
//
// #ifdef DEBUG
// # define DEBUG_LOG(...) fprintf(stderr, __VA_ARGS__)
// #else
// # define DEBUG_LOG(...)
// #endif

const vterm = @import("vterm.zig");
const vterm_defs = @import("vterm_defs.zig");
const VTermScreen = vterm.VTermScreen;
const VTermColor = vterm_defs.VTermColor;
const VTermPos = vterm_defs.VTermPos;
const VTermStateCallbacks = vterm_defs.VTermStateCallbacks;
const VTermStateFallbacks = vterm_defs.VTermStateFallbacks;
const VTermSelectionCallbacks = vterm_defs.VTermSelectionCallbacks;

// #define ESC_S "\x1b"
// #define INTERMED_MAX 16
// #define CSI_ARGS_MAX 32
// #define CSI_LEADER_MAX 16
// #define BUFIDX_PRIMARY   0
// #define BUFIDX_ALTSCREEN 1
pub const ESC_S = "\x1b";
pub const INTERMED_MAX = 16;
pub const CSI_ARGS_MAX = 32;
pub const CSI_LEADER_MAX = 16;
pub const BUFIDX_PRIMARY = 0;
pub const BUFIDX_ALTSCREEN = 1;

// #define KEY_ENCODING_DISAMBIGUATE 0x1
// #define KEY_ENCODING_REPORT_EVENTS 0x2
// #define KEY_ENCODING_REPORT_ALTERNATE 0x4
// #define KEY_ENCODING_REPORT_ALL_KEYS 0x8
// #define KEY_ENCODING_REPORT_ASSOCIATED 0x10
pub const KEY_ENCODING_DISAMBIGUATE = 0x1;
pub const KEY_ENCODING_REPORT_EVENTS = 0x2;
pub const KEY_ENCODING_REPORT_ALTERNATE = 0x4;
pub const KEY_ENCODING_REPORT_ALL_KEYS = 0x8;
pub const KEY_ENCODING_REPORT_ASSOCIATED = 0x10;

// typedef struct VTermEncoding VTermEncoding;
// struct VTermEncoding {
//   void (*init)(VTermEncoding *enc, void *data);
//   void (*decode)(VTermEncoding *enc, void *data, uint32_t cp[], int *cpi, int cplen,
//                  const char bytes[], size_t *pos, size_t len);
// };
pub const VTermEncoding = extern struct {
    init: ?*const fn (enc: ?*VTermEncoding, data: ?*anyopaque) callconv(.c) void,
    decode: ?*const fn (
        enc: ?*VTermEncoding,
        data: ?*anyopaque,
        cp: [*]u32,
        cpi: *c_int,
        cplen: c_int,
        bytes: [*]const u8,
        pos: *usize,
        len: usize,
    ) callconv(.c) void,
};

// // https://sw.kovidgoyal.net/kitty/keyboard-protocol/#progressive-enhancement
// typedef struct VTermKeyEncodingFlags VTermKeyEncodingFlags;
// struct VTermKeyEncodingFlags {
//   bool disambiguate:1;
//   bool report_events:1;
//   bool report_alternate:1;
//   bool report_all_keys:1;
//   bool report_associated:1;
// };
pub const VTermKeyEncodingFlags = extern struct {
    disambiguate: bool,
    report_events: bool,
    report_alternate: bool,
    report_all_keys: bool,
    report_associated: bool,
};

// typedef struct {
//   VTermEncoding *enc;
//
//   // This size should be increased if required by other stateful encodings
//   char data[4 * sizeof(uint32_t)];
// } VTermEncodingInstance;
pub const VTermEncodingInstance = extern struct {
    enc: ?*VTermEncoding,
    data: [4 * @sizeOf(u32)]u8,
};

// struct VTermPen {
//   VTermColor fg;
//   VTermColor bg;
//   int uri;
//   unsigned bold:1;
//   unsigned underline:2;
//   unsigned italic:1;
//   unsigned blink:1;
//   unsigned reverse:1;
//   unsigned conceal:1;
//   unsigned strike:1;
//   unsigned font:4;  // To store 0-9
//   unsigned small:1;
//   unsigned baseline:2;
// };
pub const VTermPen = extern struct {
    fg: VTermColor,
    bg: VTermColor,
    uri: c_int,
    bold: bool,
    underline: u2,
    italic: bool,
    blink: bool,
    reverse: bool,
    conceal: bool,
    strike: bool,
    font: u4,
    small: bool,
    baseline: u2,
};

// struct VTermKeyEncodingStack {
//   VTermKeyEncodingFlags items[16];
//   uint8_t size;  ///< Number of items in the stack. This is at least 1 and at
//                  ///< most the length of the "items" array.
// };
pub const VTermKeyEncodingStack = extern struct {
    items: [16]VTermKeyEncodingFlags,
    size: u8,
};

// struct VTermState {
//   VTerm *vt;
//
//   const VTermStateCallbacks *callbacks;
//   void *cbdata;
//
//   const VTermStateFallbacks *fallbacks;
//   void *fbdata;
//
//   int rows;
//   int cols;
//
//   // Current cursor position
//   VTermPos pos;
//
//   int at_phantom;  // True if we're on the "81st" phantom column to defer a wraparound
//
//   int scrollregion_top;
//   int scrollregion_bottom;  // -1 means unbounded
// #define SCROLLREGION_BOTTOM(state) ((state)->scrollregion_bottom > \
//                                     -1 ? (state)->scrollregion_bottom : (state)->rows)
//   int scrollregion_left;
// #define SCROLLREGION_LEFT(state)  ((state)->mode.leftrightmargin ? (state)->scrollregion_left : 0)
//   int scrollregion_right;  // -1 means unbounded
// #define SCROLLREGION_RIGHT(state) ((state)->mode.leftrightmargin \
//                                    && (state)->scrollregion_right > \
//                                    -1 ? (state)->scrollregion_right : (state)->cols)
//
//   // Bitvector of tab stops
//   uint8_t *tabstops;
//
//   // Primary and Altscreen; lineinfos[1] is lazily allocated as needed
//   VTermLineInfo *lineinfos[2];
//
//   // lineinfo will == lineinfos[0] or lineinfos[1], depending on altscreen
//   VTermLineInfo *lineinfo;
// #define ROWWIDTH(state, \
//                  row) ((state)->lineinfo[(row)].doublewidth ? ((state)->cols / 2) : (state)->cols)
// #define THISROWWIDTH(state) ROWWIDTH(state, (state)->pos.row)
//
//   // Mouse state
//   int mouse_col, mouse_row;
//   int mouse_buttons;
//   int mouse_flags;
// #define MOUSE_WANT_CLICK 0x01
// #define MOUSE_WANT_DRAG  0x02
// #define MOUSE_WANT_MOVE  0x04
//
//   enum { MOUSE_X10, MOUSE_UTF8, MOUSE_SGR, MOUSE_RXVT, } mouse_protocol;
//
// // Last glyph output, for Unicode recombining purposes
//   char grapheme_buf[MAX_SCHAR_SIZE];
//   size_t grapheme_len;
//   uint32_t grapheme_last;  // last added UTF-32 char
//   GraphemeState grapheme_state;
//   int combine_width;  // The width of the glyph above
//   VTermPos combine_pos;   // Position before movement
//
//   struct {
//     unsigned keypad:1;
//     unsigned cursor:1;
//     unsigned autowrap:1;
//     unsigned insert:1;
//     unsigned newline:1;
//     unsigned cursor_visible:1;
//     unsigned cursor_blink:1;
//     unsigned cursor_shape:2;
//     unsigned alt_screen:1;
//     unsigned origin:1;
//     unsigned screen:1;
//     unsigned leftrightmargin:1;
//     unsigned bracketpaste:1;
//     unsigned report_focus:1;
//     unsigned theme_updates:1;
//   } mode;
//
//   VTermEncodingInstance encoding[4], encoding_utf8;
//   int gl_set, gr_set, gsingle_set;
//
//   struct VTermPen pen;
//
//   VTermColor default_fg;
//   VTermColor default_bg;
//   VTermColor colors[16];  // Store the 8 ANSI and the 8 ANSI high-brights only
//
//   int bold_is_highbright;
//
//   unsigned protected_cell : 1;
//
// // Saved state under DEC mode 1048/1049
//   struct {
//     VTermPos pos;
//     struct VTermPen pen;
//
//     struct {
//       unsigned cursor_visible:1;
//       unsigned cursor_blink:1;
//       unsigned cursor_shape:2;
//     } mode;
//   } saved;
//
// // Temporary state for DECRQSS parsing
//   union {
//     char decrqss[4];
//     struct {
//       uint16_t mask;
//       enum {
//         SELECTION_INITIAL,
//         SELECTION_SELECTED,
//         SELECTION_QUERY,
//         SELECTION_SET_INITIAL,
//         SELECTION_SET,
//         SELECTION_INVALID,
//       } state : 8;
//       uint32_t recvpartial;
//       uint32_t sendpartial;
//     } selection;
//   } tmp;
//
//   struct {
//     const VTermSelectionCallbacks *callbacks;
//     void *user;
//     char *buffer;
//     size_t buflen;
//   } selection;
//
//   // Maintain two stacks, one for primary screen and one for altscreen
//   struct VTermKeyEncodingStack key_encoding_stacks[2];
// };
pub const VTermSelectionState = enum(u8) {
    initial,
    selected,
    query,
    set_initial,
    set,
    invalid,
};
pub const MOUSE_WANT_CLICK = 0x01;
pub const MOUSE_WANT_DRAG = 0x02;
pub const MOUSE_WANT_MOVE = 0x04;
pub const VTermState = extern struct {
    //   VTerm *vt;
    //
    //   const VTermStateCallbacks *callbacks;
    //   void *cbdata;
    //
    //   const VTermStateFallbacks *fallbacks;
    //   void *fbdata;
    callbacks: ?*VTermStateCallbacks,
    cbdata: ?*anyopaque,
    fallbacks: ?*VTermStateFallbacks,
    fbdata: ?*anyopaque,
    //
    //   int rows;
    //   int cols;
    rows: c_int,
    cols: c_int,
    //
    //   // Current cursor position
    //   VTermPos pos;
    pos: VTermPos,
    //
    //   int at_phantom;  // True if we're on the "81st" phantom column to defer a wraparound
    at_phantom: c_int,
    //
    //   int scrollregion_top;
    //   int scrollregion_bottom;  // -1 means unbounded
    // #define SCROLLREGION_BOTTOM(state) ((state)->scrollregion_bottom > \
    //                                     -1 ? (state)->scrollregion_bottom : (state)->rows)
    //   int scrollregion_left;
    //   int scrollregion_right;  // -1 means unbounded
    // #define SCROLLREGION_LEFT(state)  ((state)->mode.leftrightmargin ? (state)->scrollregion_left : 0)
    // #define SCROLLREGION_RIGHT(state) ((state)->mode.leftrightmargin \
    //                                    && (state)->scrollregion_right > \
    //                                    -1 ? (state)->scrollregion_right : (state)->cols)
    scrollregion_top: c_int,
    scrollregion_bottom: c_int,
    scrollregion_left: c_int,
    scrollregion_right: c_int,
    //
    //   // Bitvector of tab stops
    //   uint8_t *tabstops;
    tabstops: u8,
    //
    //   // Primary and Altscreen; lineinfos[1] is lazily allocated as needed
    //   VTermLineInfo *lineinfos[2];
    //
    //   // lineinfo will == lineinfos[0] or lineinfos[1], depending on altscreen
    //   VTermLineInfo *lineinfo;

    // TODO: type, make sure this is right
    // lineinfos: [2]?*VTermLineInfo,
    // lineinfo: ?*VTermLineInfo,

    // #define ROWWIDTH(state, \
    //                  row) ((state)->lineinfo[(row)].doublewidth ? ((state)->cols / 2) : (state)->cols)
    // #define THISROWWIDTH(state) ROWWIDTH(state, (state)->pos.row)
    //
    mouse_col: c_int,
    mouse_row: c_int,
    mouse_buttons: c_int,
    mouse_flags: c_int,
    // TODO: enum size,
    mouse_protocol: enum(u32) {
        x10,
        utf8,
        sgr,
        rxvt,
    },
    // TODO: var
    // grapheme_buf: [MAX_SCHAR_SIZE]u8,
    grapheme_len: usize,
    grapheme_last: u32,
    // TODO: type
    // grapheme_state: GraphemeState,
    combine_width: c_int,
    combine_pos: VTermPos,
    mode: extern struct {
        keypad: bool,
        cursor: bool,
        autowrap: bool,
        insert: bool,
        newline: bool,
        cursor_visible: bool,
        cursor_blink: bool,
        cursor_shape: u2,
        alt_screen: bool,
        origin: bool,
        screen: bool,
        leftrightmargin: bool,
        bracketpaste: bool,
        report_focus: bool,
        theme_updates: bool,
    },
    encoding: [4]VTermEncodingInstance,
    encoding_utf8: VTermEncodingInstance,
    gl_set: c_int,
    gr_set: c_int,
    gsingle_set: c_int,
    pen: VTermPen,
    default_fg: VTermColor,
    default_bg: VTermColor,
    colors: [16]VTermColor,
    bold_is_highbright: c_int,
    protected_cell: bool,
    saved: extern struct {
        pos: VTermPos,
        pen: VTermPen,
        mode: extern struct {
            cursor_visible: bool,
            cursor_blink: bool,
            cursor_shape: u2,
        },
    },
    tmp: extern union { decrqss: [4]u8, selection: extern struct {
        mask: u16,
        state: VTermSelectionState,
        recvpartial: u32,
        sendpartial: u32,
    } },
    selection: extern struct {
        callbacks: ?*VTermSelectionCallbacks,
        user: ?*anyopaque,
        buffer: [*]u8,
        buflen: usize,
    },
    key_encoding_stacks: [2]VTermKeyEncodingStack,
};

// struct VTerm {
//   const VTermAllocatorFunctions *allocator;
//   void *allocdata;
//
//   int rows;
//   int cols;
//
//   struct {
//     unsigned utf8:1;
//     unsigned ctrl8bit:1;
//   } mode;
//
//   struct {
//     enum VTermParserState {
//       NORMAL,
//       CSI_LEADER,
//       CSI_ARGS,
//       CSI_INTERMED,
//       DCS_COMMAND,
//       // below here are the "string states"
//       OSC_COMMAND,
//       OSC,
//       DCS_VTERM,
//       APC,
//       PM,
//       SOS,
//     } state;
//
//     bool in_esc : 1;
//
//     int intermedlen;
//     char intermed[INTERMED_MAX];
//
//     union {
//       struct {
//         int leaderlen;
//         char leader[CSI_LEADER_MAX];
//
//         int argi;
//         long args[CSI_ARGS_MAX];
//       } csi;
//       struct {
//         int command;
//       } osc;
//       struct {
//         int commandlen;
//         char command[CSI_LEADER_MAX];
//       } dcs;
//     } v;
//
//     const VTermParserCallbacks *callbacks;
//     void *cbdata;
//
//     bool string_initial;
//
//     bool emit_nul;
//   } parser;
//
//   // len == malloc()ed size; cur == number of valid bytes
//
//   VTermOutputCallback *outfunc;
//   void *outdata;
//
//   char *outbuffer;
//   size_t outbuffer_len;
//   size_t outbuffer_cur;
//
//   char *tmpbuffer;
//   size_t tmpbuffer_len;
//
//   VTermState *state;
//   VTermScreen *screen;
// };
pub const VTerm = extern struct {
//   const VTermAllocatorFunctions *allocator;
//   void *allocdata;
//
//   int rows;
//   int cols;
//
//   struct {
//     unsigned utf8:1;
//     unsigned ctrl8bit:1;
//   } mode;
//
//   struct {
//     enum VTermParserState {
//       NORMAL,
//       CSI_LEADER,
//       CSI_ARGS,
//       CSI_INTERMED,
//       DCS_COMMAND,
//       // below here are the "string states"
//       OSC_COMMAND,
//       OSC,
//       DCS_VTERM,
//       APC,
//       PM,
//       SOS,
//     } state;
//
//     bool in_esc : 1;
//
//     int intermedlen;
//     char intermed[INTERMED_MAX];
//
//     union {
//       struct {
//         int leaderlen;
//         char leader[CSI_LEADER_MAX];
//
//         int argi;
//         long args[CSI_ARGS_MAX];
//       } csi;
//       struct {
//         int command;
//       } osc;
//       struct {
//         int commandlen;
//         char command[CSI_LEADER_MAX];
//       } dcs;
//     } v;
//
//     const VTermParserCallbacks *callbacks;
//     void *cbdata;
//
//     bool string_initial;
//
//     bool emit_nul;
//   } parser;
//
//   // len == malloc()ed size; cur == number of valid bytes
//
//   VTermOutputCallback *outfunc;
//   void *outdata;
//
//   char *outbuffer;
//   size_t outbuffer_len;
//   size_t outbuffer_cur;
//
//   char *tmpbuffer;
//   size_t tmpbuffer_len;
//
//   VTermState *state;
//   VTermScreen *screen;
  state: *VTermState,
  screen: *VTermScreen,
};
//
// struct VTermEncoding {
//   void (*init)(VTermEncoding *enc, void *data);
//   void (*decode)(VTermEncoding *enc, void *data, uint32_t cp[], int *cpi, int cplen,
//                  const char bytes[], size_t *pos, size_t len);
// };
//
// typedef enum {
//   ENC_UTF8,
//   ENC_SINGLE_94,
// } VTermEncodingType;
//
// enum {
//   C1_SS3 = 0x8f,
//   C1_DCS = 0x90,
//   C1_CSI = 0x9b,
//   C1_ST  = 0x9c,
//   C1_OSC = 0x9d,
// };
