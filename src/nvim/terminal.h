#pragma once

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include "nvim/api/private/defs.h"  // IWYU pragma: keep
#include "nvim/types_defs.h"  // IWYU pragma: keep
#include "nvim/vterm/keyboard.h"
#include "nvim/vterm/vterm_defs.h"

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

#include "terminal.h.generated.h"

typedef struct VTermZ VTermZ;
VTermZ *vtermz_new(int rows, int cols);
void vtermz_free(VTermZ *vt);
void vtermz_print(VTermZ *vt);
size_t vtermz_input_write(VTermZ *vt, const char *bytes, size_t len);
void vtermz_set_utf8(VTermZ *vt, bool is_utf8);
void vtermz_get_size(const VTermZ *vt, int *rowsp, int *colsp);
void vtermz_set_size(VTermZ *vt, int rows, int cols);
void vtermz_state_set_palette_color(VTermZ *vt, int index, const VTermColor *col);
void vtermz_output_set_callback(VTermZ *vt, VTermOutputCallback *func, void *user);
void vtermz_keyboard_key(VTermZ *vtz, VTermKey key, VTermModifier mod);
void vtermz_teardown(void);
int vtermz_screen_get_cell(const VTermZ *screen, VTermPos pos, VTermScreenCell *cell);
void vtermz_refresh(VTermZ *vt);
void vtermz_keyboard_unichar(VTermZ *vt, uint32_t c, VTermModifier mod);
