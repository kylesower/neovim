#pragma once

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include "nvim/api/private/defs.h"  // IWYU pragma: keep
#include "nvim/types_defs.h"  // IWYU pragma: keep
#include "nvim/vterm/vterm_defs.h"
#include "nvim/state_defs.h"
#include "nvim/event/defs.h"

typedef void (*terminal_write_cb)(const char *buffer, size_t size, void *data);
typedef void (*terminal_resize_cb)(uint16_t width, uint16_t height, void *data);
typedef void (*terminal_close_cb)(void *data);

typedef struct {
  void *data;  // PTY process channel
  uint16_t width, height;
  terminal_write_cb write_cb;
  terminal_resize_cb resize_cb;
  terminal_close_cb close_cb;
  bool force_crlf;
} TerminalOptions;

#define DEFINE_FUNC_ATTRIBUTES
#include "nvim/func_attr.h"
#undef DEFINE_FUNC_ATTRIBUTES
#ifndef DLLEXPORT
#  ifdef MSWIN
#    define DLLEXPORT __declspec(dllexport)
#  else
#    define DLLEXPORT
#  endif
#endif
// #include "terminal.h.generated.h"
DLLEXPORT void terminal_init(void);
DLLEXPORT void terminal_teardown(void);
DLLEXPORT void terminal_open(Terminal **termpp, buf_T *buf, TerminalOptions opts) FUNC_ATTR_NONNULL_ALL;
DLLEXPORT void terminal_close(Terminal **termpp, int status) FUNC_ATTR_NONNULL_ALL;
DLLEXPORT void terminal_check_size(Terminal *term);
DLLEXPORT bool terminal_enter(void);
DLLEXPORT void terminal_destroy(Terminal **termpp) FUNC_ATTR_NONNULL_ALL;
DLLEXPORT void terminal_paste(int count, String *y_array, size_t y_size);
DLLEXPORT void terminal_receive(Terminal *term, const char *data, size_t len);
DLLEXPORT void terminal_get_line_attributes(Terminal *term, win_T *wp, int linenr, int *term_attrs);
DLLEXPORT Buffer terminal_buf(const Terminal *term);
DLLEXPORT bool terminal_running(const Terminal *term);
DLLEXPORT void terminal_notify_theme(Terminal *term, bool dark) FUNC_ATTR_NONNULL_ALL;
DLLEXPORT void on_scrollback_option_changed(Terminal *term);
DLLEXPORT void fetch_row(Terminal* term, int row, int end_col);
DLLEXPORT bool fetch_cell(Terminal*term, int row, int col, VTermScreenCell *cell);
DLLEXPORT int terminal_execute(VimState *state, int key);
DLLEXPORT int term_settermprop(VTermProp prop, VTermValue *val, void *data);
DLLEXPORT int on_osc(int command, VTermStringFragment frag, void *user);
TimeWatcher *term_refresh_timer(void);
