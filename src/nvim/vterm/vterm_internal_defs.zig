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

