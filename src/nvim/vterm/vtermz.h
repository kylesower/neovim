#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include "nvim/api/private/defs.h"  // IWYU pragma: keep
#include "nvim/types_defs.h"  // IWYU pragma: keep
#include "nvim/vterm/keyboard.h"
#include "nvim/vterm/vterm_defs.h"

typedef struct VTermZ VTermZ;

typedef enum {
  VTERMZ_TERMINATOR_BEL,  // \x07
  VTERMZ_TERMINATOR_ST,  // \x1b\x5c
} VTermZTerminator;

typedef struct {
  int command;  // 4 for palette colors, 10 for FG, 11 for BG, 12 for cursor
  char *buf; // If command is 4, the colors being queried
  size_t len;
  VTermZTerminator terminator; // The terminator used in the original request
} VTermZOscColor;

typedef struct {
  // TODO: do we need these other callbacks?
  // int (*damage)(VTermRect rect, void *user);
  // int (*moverect)(VTermRect dest, VTermRect src, void *user);
  int (*movecursor)(int row, int col, void *user);
  int (*settermprop)(VTermProp prop, VTermValue *val, void *user);
  int (*bell)(void *user);
  int (*theme)(bool *dark, void *user);
  int (*osc_color)(VTermZOscColor osc, void *user);
  // int (*sb_pushline)(int cols, const VTermScreenCell *cells, void *user);
  // int (*sb_popline)(int cols, VTermScreenCell *cells, void *user);
  // int (*sb_clear)(void *user);
} VTermZCallbacks;


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

void vterm_screen_cell_setz(void *srcz, void *dstc);
void vtermz_screen_set_callbacks(VTermZ *vt, VTermZCallbacks *callbacks, void *user);
