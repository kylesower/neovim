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
    "nvim/memory.h";
});
const vterm_defs = @import("vterm_defs.zig");
const vterm_internal_defs = @import("vterm_internal_defs.zig");
const VTerm = vterm_internal_defs.VTerm;
const VTermState = vterm_defs.VTermState;
const VTermScreenCallbacks = vterm_defs.VTermScreenCallbacks;
const VTermDamageSize = vterm_defs.VTermDamageSize;
const VTermRect = vterm_defs.VTermRect;
const ScreenCell = vterm_defs.ScreenCell;
const ScreenPen = vterm_defs.ScreenPen;
const VTermScreenCell = vterm_defs.VTermScreenCell;
const VTermAllocatorFunctions = vterm_defs.VTermAllocatorFunctions;

// // move a rect
// static inline void vterm_rect_move(VTermRect *rect, int row_delta, int col_delta)
// {
//   rect->start_row += row_delta; rect->end_row += row_delta;
//   rect->start_col += col_delta; rect->end_col += col_delta;
// }
//
// // Bit-field describing the content of the tagged union `VTermColor`.
// typedef enum {
//   // If the lower bit of `type` is not set, the colour is 24-bit RGB.
//   VTERM_COLOR_RGB = 0x00,
//
//   // The colour is an index into a palette of 256 colours.
//   VTERM_COLOR_INDEXED = 0x01,
//
//   // Mask that can be used to extract the RGB/Indexed bit.
//   VTERM_COLOR_TYPE_MASK = 0x01,
//
//   // If set, indicates that this colour should be the default foreground color, i.e. there was no
//   // SGR request for another colour. When rendering this colour it is possible to ignore "idx" and
//   // just use a colour that is not in the palette.
//   VTERM_COLOR_DEFAULT_FG = 0x02,
//
//   // If set, indicates that this colour should be the default background color, i.e. there was no
//   // SGR request for another colour. A common option when rendering this colour is to not render a
//   // background at all, for example by rendering the window transparently at this spot.
//   VTERM_COLOR_DEFAULT_BG = 0x04,
//
//   // Mask that can be used to extract the default foreground/background bit.
//   VTERM_COLOR_DEFAULT_MASK = 0x06,
// } VTermColorType;
//
// // Returns true if the VTERM_COLOR_RGB `type` flag is set, indicating that the given VTermColor
// // instance is an indexed colour.
// #define VTERM_COLOR_IS_INDEXED(col) \
//   (((col)->type & VTERM_COLOR_TYPE_MASK) == VTERM_COLOR_INDEXED)
//
// // Returns true if the VTERM_COLOR_INDEXED `type` flag is set, indicating that the given VTermColor
// // instance is an rgb colour.
// #define VTERM_COLOR_IS_RGB(col) \
//   (((col)->type & VTERM_COLOR_TYPE_MASK) == VTERM_COLOR_RGB)
//
// // Returns true if the VTERM_COLOR_DEFAULT_FG `type` flag is set, indicating that the given
// // VTermColor instance corresponds to the default foreground color.
// #define VTERM_COLOR_IS_DEFAULT_FG(col) \
//   (!!((col)->type & VTERM_COLOR_DEFAULT_FG))
//
// // Returns true if the VTERM_COLOR_DEFAULT_BG `type` flag is set, indicating that the given
// // VTermColor instance corresponds to the default background color.
// #define VTERM_COLOR_IS_DEFAULT_BG(col) \
//   (!!((col)->type & VTERM_COLOR_DEFAULT_BG))
//
// // Constructs a new VTermColor instance representing the given RGB values.
// static inline void vterm_color_rgb(VTermColor *col, uint8_t red, uint8_t green, uint8_t blue)
// {
//   col->type = VTERM_COLOR_RGB;
//   col->rgb.red = red;
//   col->rgb.green = green;
//   col->rgb.blue = blue;
// }
//
// // Construct a new VTermColor instance representing an indexed color with the given index.
// static inline void vterm_color_indexed(VTermColor *col, uint8_t idx)
// {
//   col->type = VTERM_COLOR_INDEXED;
//   col->indexed.idx = idx;
// }
//
// // ------------
// // Parser layer
// // ------------
//
// /// Flag to indicate non-final subparameters in a single CSI parameter.
// /// Consider
// ///   CSI 1;2:3:4;5a
// /// 1 4 and 5 are final.
// /// 2 and 3 are non-final and will have this bit set
// ///
// /// Don't confuse this with the final byte of the CSI escape; 'a' in this case.
// #define CSI_ARG_FLAG_MORE (1U << 31)
// #define CSI_ARG_MASK      (~(1U << 31))
//
// #define CSI_ARG_HAS_MORE(a) ((a)& CSI_ARG_FLAG_MORE)
// #define CSI_ARG(a)          ((a)& CSI_ARG_MASK)
//
// // Can't use -1 to indicate a missing argument; use this instead
// #define CSI_ARG_MISSING ((1UL<<31) - 1)
//
// #define CSI_ARG_IS_MISSING(a) (CSI_ARG(a) == CSI_ARG_MISSING)
// #define CSI_ARG_OR(a, def)     (CSI_ARG(a) == CSI_ARG_MISSING ? (def) : CSI_ARG(a))
// #define CSI_ARG_COUNT(a)      (CSI_ARG(a) == CSI_ARG_MISSING || CSI_ARG(a) == 0 ? 1 : CSI_ARG(a))
//
// enum {
//   VTERM_UNDERLINE_OFF,
//   VTERM_UNDERLINE_SINGLE,
//   VTERM_UNDERLINE_DOUBLE,
//   VTERM_UNDERLINE_CURLY,
// };
//
// enum {
//   VTERM_BASELINE_NORMAL,
//   VTERM_BASELINE_RAISE,
//   VTERM_BASELINE_LOWER,
// };
//
// // Back-compat alias for the brief time it was in 0.3-RC1
// #define vterm_screen_set_reflow  vterm_screen_enable_reflow
//
// void vterm_scroll_rect(VTermRect rect, int downward, int rightward,
//                        int (*moverect)(VTermRect src, VTermRect dest, void *user),
//                        int (*eraserect)(VTermRect rect, int selective, void *user), void *user);

// struct VTermScreen {
//   VTerm *vt;
//   VTermState *state;
//
//   const VTermScreenCallbacks *callbacks;
//   void *cbdata;
//
//   VTermDamageSize damage_merge;
//   // start_row == -1 => no damage
//   VTermRect damaged;
//   VTermRect pending_scrollrect;
//   int pending_scroll_downward, pending_scroll_rightward;
//
//   int rows;
//   int cols;
//
//   unsigned global_reverse : 1;
//   unsigned reflow : 1;
//
//   // Primary and Altscreen. buffers[1] is lazily allocated as needed
//   ScreenCell *buffers[2];
//
//   // buffer will == buffers[0] or buffers[1], depending on altscreen
//   ScreenCell *buffer;
//
//   // buffer for a single screen row used in scrollback storage callbacks
//   VTermScreenCell *sb_buffer;
//
//   ScreenPen pen;
// };
pub const VTermScreen = extern struct {
    vt: *VTerm,
    state: *VTermState,
    callbacks: ?*const VTermScreenCallbacks,
    cbdata: ?*anyopaque,
    damage_merge: VTermDamageSize,
    // // start_row == -1 => no damage
    damaged: VTermRect,
    pending_scrollrect: VTermRect,
    pending_scroll_downward: c_int,
    pending_scroll_rightward: c_int,
    rows: c_int,
    cols: c_int,
    global_reverse: bool,
    reflow: bool,
    // // Primary and Altscreen. buffers[1] is lazily allocated as needed
    // ScreenCell *buffers[2];
    buffers: [2]?*ScreenCell,
    // // buffer will == buffers[0] or buffers[1], depending on altscreen
    buffer: ?*ScreenCell,
    // // buffer for a single screen row used in scrollback storage callbacks
    sb_buffer: *VTermScreenCell,
    pen: ScreenPen,
};

// static void *default_malloc(size_t size, void *allocdata)
// {
//   void *ptr = xmalloc(size);
//   if (ptr) {
//     memset(ptr, 0, size);
//   }
//   return ptr;
// }
fn default_malloc(size: usize, allocdata: *anyopaque) *anyopaque {
    _ = allocdata;
    const ptr = c.xmalloc(size);
    if (ptr) {
        c.memset(ptr, 0, size);
    }
    return ptr;
}

// static void default_free(void *ptr, void *allocdata)
// {
//   xfree(ptr);
// }
fn default_free(ptr: *anyopaque, allocdata: *anyopaque) void {
    _ = allocdata;
    c.xfree(ptr);
}

// static VTermAllocatorFunctions default_allocator = {
//   .malloc = &default_malloc,
//   .free = &default_free,
// };
pub const default_allocator: VTermAllocatorFunctions = .{
    .malloc = default_malloc,
    .free = default_free,
};

// /// Convenient shortcut for default cases
// VTerm *vterm_new(int rows, int cols)
// {
//   return vterm_build(&(const struct VTermBuilder){
//     .rows = rows,
//     .cols = cols,
//   });
// }
//
// // A handy macro for defaulting values out of builder fields
// #define DEFAULT(v, def)  ((v) ? (v) : (def))
//
// VTerm *vterm_build(const struct VTermBuilder *builder)
// {
//   const VTermAllocatorFunctions *allocator = DEFAULT(builder->allocator, &default_allocator);
//
//   // Need to bootstrap using the allocator function directly
//   VTerm *vt = (*allocator->malloc)(sizeof(VTerm), builder->allocdata);
//
//   vt->allocator = allocator;
//   vt->allocdata = builder->allocdata;
//
//   vt->rows = builder->rows;
//   vt->cols = builder->cols;
//
//   vt->parser.state = NORMAL;
//
//   vt->parser.callbacks = NULL;
//   vt->parser.cbdata = NULL;
//
//   vt->parser.emit_nul = false;
//
//   vt->outfunc = NULL;
//   vt->outdata = NULL;
//
//   vt->outbuffer_len = DEFAULT(builder->outbuffer_len, 4096);
//   vt->outbuffer_cur = 0;
//   vt->outbuffer = vterm_allocator_malloc(vt, vt->outbuffer_len);
//
//   vt->tmpbuffer_len = DEFAULT(builder->tmpbuffer_len, 4096);
//   vt->tmpbuffer = vterm_allocator_malloc(vt, vt->tmpbuffer_len);
//
//   return vt;
// }
//
// void vterm_free(VTerm *vt)
// {
//   if (vt->screen) {
//     vterm_screen_free(vt->screen);
//   }
//
//   if (vt->state) {
//     vterm_state_free(vt->state);
//   }
//
//   vterm_allocator_free(vt, vt->outbuffer);
//   vterm_allocator_free(vt, vt->tmpbuffer);
//
//   vterm_allocator_free(vt, vt);
// }
//
// void *vterm_allocator_malloc(VTerm *vt, size_t size)
// {
//   return (*vt->allocator->malloc)(size, vt->allocdata);
// }
//
// void vterm_allocator_free(VTerm *vt, void *ptr)
// {
//   (*vt->allocator->free)(ptr, vt->allocdata);
// }
//
// void vterm_get_size(const VTerm *vt, int *rowsp, int *colsp)
// {
//   if (rowsp) {
//     *rowsp = vt->rows;
//   }
//   if (colsp) {
//     *colsp = vt->cols;
//   }
// }
//
// void vterm_set_size(VTerm *vt, int rows, int cols)
// {
//   if (rows < 1 || cols < 1) {
//     return;
//   }
//
//   vt->rows = rows;
//   vt->cols = cols;
//
//   if (vt->parser.callbacks && vt->parser.callbacks->resize) {
//     (*vt->parser.callbacks->resize)(rows, cols, vt->parser.cbdata);
//   }
// }
//
// void vterm_set_utf8(VTerm *vt, int is_utf8)
// {
//   vt->mode.utf8 = (unsigned)is_utf8;
// }
//
// void vterm_output_set_callback(VTerm *vt, VTermOutputCallback *func, void *user)
// {
//   vt->outfunc = func;
//   vt->outdata = user;
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
