// #pragma once
// #include <stdbool.h>
// #include <stddef.h>
// #include <stdint.h>
//
// #include "nvim/types_defs.h"
//
// typedef struct VTerm VTerm;
// typedef struct VTermState VTermState;
// typedef struct VTermScreen VTermScreen;
//
// typedef struct {
//   int row;
//   int col;
// } VTermPos;
pub const VTermPos = extern struct {
    row: c_int,
    col: c_int,
};

// // some small utility functions; we can just keep these static here
//
// typedef struct {
//   int start_row;
//   int end_row;
//   int start_col;
//   int end_col;
// } VTermRect;
pub const VTermRect = extern struct {
    start_row: c_int,
    end_row: c_int,
    start_col: c_int,
    end_col: c_int,
};
//
// // Tagged union storing either an RGB color or an index into a colour palette. In order to convert
// // indexed colours to RGB, you may use the vterm_state_convert_color_to_rgb() or
// // vterm_screen_convert_color_to_rgb() functions which lookup the RGB colour from the palette
// // maintained by a VTermState or VTermScreen instance.
// typedef union {
//   // Tag indicating which union member is actually valid. This variable coincides with the `type`
//   // member of the `rgb` and the `indexed` struct in memory. Please use the `VTERM_COLOR_IS_*` test
//   // macros to check whether a particular type flag is set.
//   uint8_t type;
//
//   // Valid if `VTERM_COLOR_IS_RGB(type)` is true. Holds the RGB colour values.
//   struct {
//     // Same as the top-level `type` member stored in VTermColor.
//     uint8_t type;
//
//     // The actual 8-bit red, green, blue colour values.
//     uint8_t red, green, blue;
//   } rgb;
//
//   // If `VTERM_COLOR_IS_INDEXED(type)` is true, this member holds the index into the colour palette.
//   struct {
//     // Same as the top-level `type` member stored in VTermColor.
//     uint8_t type;
//
//     // Index into the colour map.
//     uint8_t idx;
//   } indexed;
// } VTermColor;
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
    bold: bool,
    underline: u2,
    italic: bool,
    blink: bool,
    reverse: bool,
    conceal: bool,
    strike: bool,
    font: u4, // 0 to 9
    dwl: bool, // On a DECDWL or DECDHL line
    dhl: u2, // On a DECDHL line (1=top 2=bottom)
    small: bool,
    baseline: u2,
};

// typedef struct {
//   schar_T schar;
//   char width;
//   VTermScreenCellAttrs attrs;
//   VTermColor fg, bg;
//   int uri;
// } VTermScreenCell;
pub const VTermScreenCell = extern struct {
    schar: u32,
    width: u8,
    attrs: VTermScreenCellAttrs,
    fg: VTermColor,
    bg: VTermColor,
    uri: c_int,
};

// typedef enum {
//   // VTERM_PROP_NONE = 0
//   VTERM_PROP_CURSORVISIBLE = 1,  // bool
//   VTERM_PROP_CURSORBLINK,       // bool
//   VTERM_PROP_ALTSCREEN,         // bool
//   VTERM_PROP_TITLE,             // string
//   VTERM_PROP_ICONNAME,          // string
//   VTERM_PROP_REVERSE,           // bool
//   VTERM_PROP_CURSORSHAPE,       // number
//   VTERM_PROP_MOUSE,             // number
//   VTERM_PROP_FOCUSREPORT,       // bool
//   VTERM_PROP_THEMEUPDATES,      // bool
//
//   VTERM_N_PROPS,
// } VTermProp;
pub const VTermProp = enum(u32) {
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

// typedef enum {
//   VTERM_TERMINATOR_BEL,  // \x07
//   VTERM_TERMINATOR_ST,  // \x1b\x5c
// } VTermTerminator;
pub const VTermTerminator = enum(u32) {
    bel,
    st,
};

// typedef struct {
//   const char *str;
//   size_t len : 30;
//   bool initial : 1;
//   bool final : 1;
//   VTermTerminator terminator;
// } VTermStringFragment;
// Sorry, this struct isn't packed nicely...
pub const VTermStringFragment = extern struct {
    str: [*]u8,
    len: u32,
    initial: bool,
    final: bool,
    terminator: VTermTerminator,
};

// typedef union {
//   int boolean;
//   int number;
//   VTermStringFragment string;
//   VTermColor color;
// } VTermValue;
pub const VTermValue = extern union {
    boolean: c_int,
    number: c_int,
    string: VTermStringFragment,
    color: VTermColor,
};
//
// typedef struct {
//   int (*damage)(VTermRect rect, void *user);
//   int (*moverect)(VTermRect dest, VTermRect src, void *user);
//   int (*movecursor)(VTermPos pos, VTermPos oldpos, int visible, void *user);
//   int (*settermprop)(VTermProp prop, VTermValue *val, void *user);
//   int (*bell)(void *user);
//   int (*resize)(int rows, int cols, void *user);
//   int (*theme)(bool *dark, void *user);
//   int (*sb_pushline)(int cols, const VTermScreenCell *cells, void *user);
//   int (*sb_popline)(int cols, VTermScreenCell *cells, void *user);
//   int (*sb_clear)(void *user);
// } VTermScreenCallbacks;
pub const VTermScreenCallbacks = extern struct {
    damage: *const fn (rect: VTermRect, user: *anyopaque) callconv(.c) c_int,
    moverect: *const fn (dest: VTermRect, src: VTermRect, user: *anyopaque) callconv(.c) c_int,
    movecursor: *const fn (
        pos: VTermPos,
        oldpos: VTermPos,
        visible: c_int,
        user: *anyopaque,
    ) callconv(.c) c_int,
    settermprop: *const fn (
        prop: VTermProp,
        val: *VTermValue,
        user: *anyopaque,
    ) callconv(.c) c_int,
    bell: *const fn (user: *anyopaque) callconv(.c) c_int,
    resize: *const fn (rows: c_int, cols: c_int, user: *anyopaque) callconv(.c) c_int,
    theme: *const fn (dark: *bool, user: *anyopaque) callconv(.c) c_int,
    sb_pushline: *const fn (
        cols: c_int,
        cells: [*]const VTermScreenCell,
        user: *anyopaque,
    ) callconv(.c) c_int,
    sb_popline: *const fn (
        cols: c_int,
        cells: [*]VTermScreenCell,
        user: *anyopaque,
    ) callconv(.c) c_int,
    sb_clear: *const fn (user: *anyopaque) callconv(.c) c_int,
};

// typedef struct {
//   int (*control)(uint8_t control, void *user);
//   int (*csi)(const char *leader, const long args[], int argcount, const char *intermed,
//              char command, void *user);
//   int (*osc)(int command, VTermStringFragment frag, void *user);
//   int (*dcs)(const char *command, size_t commandlen, VTermStringFragment frag, void *user);
//   int (*apc)(VTermStringFragment frag, void *user);
//   int (*pm)(VTermStringFragment frag, void *user);
//   int (*sos)(VTermStringFragment frag, void *user);
// } VTermStateFallbacks;
pub const VTermStateFallbacks = extern struct {
    control: *const fn (control: u8, user: *anyopaque) callconv(.c) c_int,
    csi: *const fn (
        leader: [*]const u8,
        args: [*]const c_long,
        argcount: c_int,
        intermed: [*]const u8,
        command: u8,
        user: *anyopaque,
    ) callconv(.c) c_int,
    osc: *const fn (
        command: c_int,
        frag: VTermStringFragment,
        user: *anyopaque,
    ) callconv(.c) c_int,
    dcs: *const fn (
        command: [*]const u8,
        commandlen: usize,
        frag: VTermStringFragment,
        user: *anyopaque,
    ) callconv(.c) c_int,
    apc: *const fn (frag: VTermStringFragment, user: *anyopaque) callconv(.c) c_int,
    pm: *const fn (frag: VTermStringFragment, user: *anyopaque) callconv(.c) c_int,
    sos: *const fn (frag: VTermStringFragment, user: *anyopaque) callconv(.c) c_int,
};
//
// typedef enum {
//   VTERM_DAMAGE_CELL,    // every cell
//   VTERM_DAMAGE_ROW,     // entire rows
//   VTERM_DAMAGE_SCREEN,  // entire screen
//   VTERM_DAMAGE_SCROLL,  // entire screen + scrollrect
//
//   VTERM_N_DAMAGES,
// } VTermDamageSize;
//
// typedef enum {
//   VTERM_ATTR_BOLD_MASK       = 1 << 0,
//   VTERM_ATTR_UNDERLINE_MASK  = 1 << 1,
//   VTERM_ATTR_ITALIC_MASK     = 1 << 2,
//   VTERM_ATTR_BLINK_MASK      = 1 << 3,
//   VTERM_ATTR_REVERSE_MASK    = 1 << 4,
//   VTERM_ATTR_STRIKE_MASK     = 1 << 5,
//   VTERM_ATTR_FONT_MASK       = 1 << 6,
//   VTERM_ATTR_FOREGROUND_MASK = 1 << 7,
//   VTERM_ATTR_BACKGROUND_MASK = 1 << 8,
//   VTERM_ATTR_CONCEAL_MASK    = 1 << 9,
//   VTERM_ATTR_SMALL_MASK      = 1 << 10,
//   VTERM_ATTR_BASELINE_MASK   = 1 << 11,
//   VTERM_ATTR_URI_MASK        = 1 << 12,
//
//   VTERM_ALL_ATTRS_MASK = (1 << 13) - 1,
// } VTermAttrMask;
//
// typedef enum {
//   // VTERM_VALUETYPE_NONE = 0
//   VTERM_VALUETYPE_BOOL = 1,
//   VTERM_VALUETYPE_INT,
//   VTERM_VALUETYPE_STRING,
//   VTERM_VALUETYPE_COLOR,
//
//   VTERM_N_VALUETYPES,
// } VTermValueType;
//
// typedef enum {
//   // VTERM_ATTR_NONE = 0
//   VTERM_ATTR_BOLD = 1,   // bool:   1, 22
//   VTERM_ATTR_UNDERLINE,  // number: 4, 21, 24
//   VTERM_ATTR_ITALIC,     // bool:   3, 23
//   VTERM_ATTR_BLINK,      // bool:   5, 25
//   VTERM_ATTR_REVERSE,    // bool:   7, 27
//   VTERM_ATTR_CONCEAL,    // bool:   8, 28
//   VTERM_ATTR_STRIKE,     // bool:   9, 29
//   VTERM_ATTR_FONT,       // number: 10-19
//   VTERM_ATTR_FOREGROUND,  // color:  30-39 90-97
//   VTERM_ATTR_BACKGROUND,  // color:  40-49 100-107
//   VTERM_ATTR_SMALL,      // bool:   73, 74, 75
//   VTERM_ATTR_BASELINE,   // number: 73, 74, 75
//   VTERM_ATTR_URI,        // number
//
//   VTERM_N_ATTRS,
// } VTermAttr;
pub const VTermAttr = enum(u32) {
    // VTERM_ATTR_NONE = 0
    bold = 1, // bool:   1, 22
    underline, // number: 4, 21, 24
    italic, // bool:   3, 23
    blink, // bool:   5, 25
    reverse, // bool:   7, 27
    conceal, // bool:   8, 28
    strike, // bool:   9, 29
    font, // number: 10-19
    foreground, // color:  30-39 90-97
    background, // color:  40-49 100-107
    small, // bool:   73, 74, 75
    baseline, // number: 73, 74, 75
    uri, // number
};
//
// enum {
//   VTERM_PROP_CURSORSHAPE_BLOCK = 1,
//   VTERM_PROP_CURSORSHAPE_UNDERLINE,
//   VTERM_PROP_CURSORSHAPE_BAR_LEFT,
//
//   VTERM_N_PROP_CURSORSHAPES,
// };
//
// enum {
//   VTERM_PROP_MOUSE_NONE = 0,
//   VTERM_PROP_MOUSE_CLICK,
//   VTERM_PROP_MOUSE_DRAG,
//   VTERM_PROP_MOUSE_MOVE,
//
//   VTERM_N_PROP_MOUSES,
// };
//
// typedef enum {
//   VTERM_SELECTION_CLIPBOARD = (1<<0),
//   VTERM_SELECTION_PRIMARY   = (1<<1),
//   VTERM_SELECTION_SECONDARY = (1<<2),
//   VTERM_SELECTION_SELECT    = (1<<3),
//   VTERM_SELECTION_CUT0      = (1<<4),  // also CUT1 .. CUT7 by bitshifting
// } VTermSelectionMask;
pub const VTermSelectionMask = u8;
pub const VTERM_SELECTION_CLIPBOARD: VTermSelectionMask = (1 << 0);
pub const VTERM_SELECTION_PRIMARY: VTermSelectionMask = (1 << 1);
pub const VTERM_SELECTION_SECONDARY: VTermSelectionMask = (1 << 2);
pub const VTERM_SELECTION_SELECT: VTermSelectionMask = (1 << 3);
pub const VTERM_SELECTION_CUT0: VTermSelectionMask = (1 << 4); // also CUT1 .. CUT7 by bitshifting

// typedef struct {
//   schar_T schar;
//   int width;
//   unsigned protected_cell:1;  // DECSCA-protected against DECSEL/DECSED
//   unsigned dwl:1;             // DECDWL or DECDHL double-width line
//   unsigned dhl:2;             // DECDHL double-height line (1=top 2=bottom)
// } VTermGlyphInfo;
pub const VTermGlyphInfo = extern struct {
    schar: u32,
    width: c_int,
    protected_cell: bool,
    dwl: bool,
    dhl: u2,
};

// typedef struct {
//   unsigned doublewidth:1;     // DECDWL or DECDHL line
//   unsigned doubleheight:2;    // DECDHL line (1=top 2=bottom)
//   unsigned continuation:1;    // Line is a flow continuation of the previous
// } VTermLineInfo;
pub const VTermLineInfo = extern struct {
    doublewidth: bool,
    doubleheight: u2,
    continuation: bool,
};

// // Copies of VTermState fields that the 'resize' callback might have reason to edit. 'resize'
// // callback gets total control of these fields and may free-and-reallocate them if required. They
// // will be copied back from the struct after the callback has returned.
// typedef struct {
//   VTermPos pos;                // current cursor position
//   VTermLineInfo *lineinfos[2];  // [1] may be NULL
// } VTermStateFields;
pub const VTermStateFields = extern struct {
    pos: VTermPos,
    lineinfos: [2]?*VTermLineInfo,
};

// typedef struct {
//   // libvterm relies on this memory to be zeroed out before it is returned by the allocator.
//   void *(*malloc)(size_t size, void *allocdata);
//   void (*free)(void *ptr, void *allocdata);
// } VTermAllocatorFunctions;
pub const VTermAllocatorFunctions = extern struct {
    malloc: *const fn (size: usize, allocdata: *anyopaque) *anyopaque,
    free: *const fn (ptr: *anyopaque, allocdata: *anyopaque) void,
};

// // Setting output callback will override the buffer logic
// typedef void VTermOutputCallback(const char *s, size_t len, void *user);
//
// struct VTermBuilder {
//   int ver;  // currently unused but reserved for some sort of ABI version flag
//
//   int rows, cols;
//
//   const VTermAllocatorFunctions *allocator;
//   void *allocdata;
//
//   // Override default sizes for various structures
//   size_t outbuffer_len;  // default: 4096
//   size_t tmpbuffer_len;  // default: 4096
// };

// typedef struct {
//   int (*putglyph)(VTermGlyphInfo *info, VTermPos pos, void *user);
//   int (*movecursor)(VTermPos pos, VTermPos oldpos, int visible, void *user);
//   int (*scrollrect)(VTermRect rect, int downward, int rightward, void *user);
//   int (*moverect)(VTermRect dest, VTermRect src, void *user);
//   int (*erase)(VTermRect rect, int selective, void *user);
//   int (*initpen)(void *user);
//   int (*setpenattr)(VTermAttr attr, VTermValue *val, void *user);
//   int (*settermprop)(VTermProp prop, VTermValue *val, void *user);
//   int (*bell)(void *user);
//   int (*resize)(int rows, int cols, VTermStateFields *fields, void *user);
//   int (*theme)(bool *dark, void *user);
//   int (*setlineinfo)(int row, const VTermLineInfo *newinfo, const VTermLineInfo *oldinfo,
//                      void *user);
//   int (*sb_clear)(void *user);
// } VTermStateCallbacks;
pub const VTermStateCallbacks = extern struct {
    //   int (*putglyph)(VTermGlyphInfo *info, VTermPos pos, void *user);
    putglyph: *const fn (info: *VTermGlyphInfo, pos: VTermPos, user: *anyopaque) c_int,
    //   int (*movecursor)(VTermPos pos, VTermPos oldpos, int visible, void *user);
    movecursor: *const fn (
        pos: VTermPos,
        oldpos: VTermPos,
        visible: c_int,
        user: *anyopaque,
    ) c_int,
    //   int (*scrollrect)(VTermRect rect, int downward, int rightward, void *user);
    scrollrect: *const fn (
        rect: VTermRect,
        downward: c_int,
        rightward: c_int,
        user: *anyopaque,
    ) c_int,
    //   int (*moverect)(VTermRect dest, VTermRect src, void *user);
    moverect: *const fn (dest: VTermRect, src: VTermRect, user: *anyopaque) c_int,
    //   int (*erase)(VTermRect rect, int selective, void *user);
    erase: *const fn (rect: VTermRect, selective: c_int, user: *anyopaque) c_int,
    //   int (*initpen)(void *user);
    initpen: *const fn (user: *anyopaque) c_int,
    //   int (*setpenattr)(VTermAttr attr, VTermValue *val, void *user);
    setpenattr: *const fn (attr: VTermAttr, val: *VTermValue, user: *anyopaque) c_int,
    //   int (*settermprop)(VTermProp prop, VTermValue *val, void *user);
    settermprop: *const fn (prop: VTermProp, val: *VTermValue, user: *anyopaque) c_int,
    //   int (*bell)(void *user);
    bell: *const fn (user: *anyopaque) c_int,
    //   int (*resize)(int rows, int cols, VTermStateFields *fields, void *user);
    resize: *const fn (
        rows: c_int,
        cols: c_int,
        fields: *VTermStateFields,
        user: *anyopaque,
    ) c_int,
    //   int (*theme)(bool *dark, void *user);
    theme: *const fn (dark: *bool, user: *anyopaque) c_int,
    //   int (*setlineinfo)(int row, const VTermLineInfo *newinfo, const VTermLineInfo *oldinfo c_int,
    //                      void *user);
    setlineinfo: *const fn (
        row: c_int,
        newinfo: *VTermLineInfo,
        oldinfo: *VTermLineInfo,
        user: *anyopaque,
    ) c_int,
    //   int (*sb_clear)(void *user);
    sb_clear: *const fn (user: *anyopaque) c_int,
};

// typedef struct {
//   int (*set)(VTermSelectionMask mask, VTermStringFragment frag, void *user);
//   int (*query)(VTermSelectionMask mask, void *user);
// } VTermSelectionCallbacks;
pub const VTermSelectionCallbacks = extern struct {
    set: ?*const fn (mask: VTermSelectionMask, frag: VTermStringFragment, user: *anyopaque) c_int,
    query: ?*const fn (mask: VTermSelectionMask, user: *anyopaque) c_int,
};

// typedef struct {
//   int (*text)(const char *bytes, size_t len, void *user);
//   int (*control)(uint8_t control, void *user);
//   int (*escape)(const char *bytes, size_t len, void *user);
//   int (*csi)(const char *leader, const long args[], int argcount, const char *intermed,
//              char command, void *user);
//   int (*osc)(int command, VTermStringFragment frag, void *user);
//   int (*dcs)(const char *command, size_t commandlen, VTermStringFragment frag, void *user);
//   int (*apc)(VTermStringFragment frag, void *user);
//   int (*pm)(VTermStringFragment frag, void *user);
//   int (*sos)(VTermStringFragment frag, void *user);
//   int (*resize)(int rows, int cols, void *user);
// } VTermParserCallbacks;

// // State of the pen at some moment in time, also used in a cell
// typedef struct {
//   // After the bitfield
//   VTermColor fg, bg;
//
//   // Opaque ID that maps to a URI in a set
//   int uri;
//
//   unsigned bold      : 1;
//   unsigned underline : 2;
//   unsigned italic    : 1;
//   unsigned blink     : 1;
//   unsigned reverse   : 1;
//   unsigned conceal   : 1;
//   unsigned strike    : 1;
//   unsigned font      : 4;  // 0 to 9
//   unsigned small     : 1;
//   unsigned baseline  : 2;
//
//   // Extra state storage that isn't strictly pen-related
//   unsigned protected_cell : 1;
//   unsigned dwl            : 1;  // on a DECDWL or DECDHL line
//   unsigned dhl            : 2;  // on a DECDHL line (1=top 2=bottom)
// } ScreenPen;
pub const ScreenPen = extern struct {
    //   // After the bitfield
    //   VTermColor fg, bg;
    fg: VTermColor,
    bg: VTermColor,
    //
    //   // Opaque ID that maps to a URI in a set
    //   int uri;
    uri: c_int,
    //
    bold: bool,
    underline: u2,
    italic: bool,
    blink: bool,
    reverse: bool,
    conceal: bool,
    strike: bool,
    font: u4, // 0 to 9
    small: bool,
    baseline: u2,

    // Extra state storage that isn't strictly pen-related
    protected_cell: bool,
    dwl: bool, // on a DECDWL or DECDHL line
    dhl: u2, // on a DECDHL line (1=top 2=bottom)
};

// // Internal representation of a screen cell
// typedef struct {
//   schar_T schar;
//   ScreenPen pen;
// } ScreenCell;
pub const ScreenCell = extern struct {
    schar: u32,
    pen: ScreenPen,
};
