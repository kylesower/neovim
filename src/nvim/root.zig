const std = @import("std");
pub const vterm = @import("./vterm/vterm.zig");
pub const log = @import("log.zig");
pub const handler = @import("./vterm/vterm_handler.zig");
pub const c = @cImport({
    @cInclude("stdarg.h");
    @cInclude("stdio.h");
    @cInclude("stdlib.h");
    @cInclude("string.h");
    @cInclude("auto/config.h");
    @cInclude("nvim/log.h");
    @cInclude("nvim/main.h");
    @cInclude("nvim/grid.h");
    @cInclude("nvim/memory.h");
    @cInclude("nvim/errors.h");
    @cInclude("nvim/vterm/screen.h");
    @cInclude("nvim/vterm/state.h");
    @cInclude("nvim/vterm/vterm.h");
    // @cInclude("nvim/vterm/vtermz.h");
});

comptime {
    // Ensure that exported symbols get exported
    _ = @import("vterm/vterm.zig");
}

pub const std_options: std.Options = .{
    // Set the log level to debug. Since we log using the C logger, we let
    // that do the log level filtering.
    .log_level = .debug,

    // Define logFn to override the std implementation
    .logFn = log.log,
};
