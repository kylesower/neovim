const std = @import("std");
const c = @import("root").c;
const LOG_MAX_SIZE = 2048;

// pub const log = std.log.scoped(.nvim);

pub fn log(
    comptime level: std.log.Level,
    comptime scope: @Type(.enum_literal),
    comptime format: []const u8,
    args: anytype,
) void {
    const scope_str = "(" ++ switch (scope) {
        .nvim => @tagName(scope),
        else => if (@intFromEnum(level) <= @intFromEnum(std.log.Level.err))
            @tagName(scope)
        else
            return,
    } ++ "):";

    const lvl = switch (level) {
        .debug => c.LOGLVL_DBG,
        .info => c.LOGLVL_INF,
        .warn => c.LOGLVL_WRN,
        .err => c.LOGLVL_ERR,
    };

    var log_buf: [LOG_MAX_SIZE]u8 = undefined;
    const context = scope_str ++ "\x00";
    const msg = std.fmt.bufPrint(&log_buf, format ++ "\x00", args) catch return;
    _ = c.logmsg(lvl, context, null, -1, true, msg.ptr);
}

pub fn logsrc(
    comptime src: std.builtin.SourceLocation,
    comptime level: std.log.Level,
    comptime scope: @Type(.enum_literal),
    comptime format: []const u8,
    args: anytype,
) void {
    const new_format = src.fn_name ++ ":{}: " ++ format;
    const new_args = .{src.line} ++ args;
    log(level, scope, new_format, new_args);
}

pub fn info(comptime src: std.builtin.SourceLocation, comptime format: []const u8, args: anytype) void {
    logsrc(src, .info, .nvim, format, args);
}

pub fn info_scoped(comptime src: std.builtin.SourceLocation, comptime scope: @Type(.enum_literal), comptime format: []const u8, args: anytype) void {
    logsrc(src, .info, scope, format, args);
}

pub fn debug(comptime src: std.builtin.SourceLocation, comptime format: []const u8, args: anytype) void {
    logsrc(src, .debug, .nvim, format, args);
}

pub fn debug_scoped(comptime src: std.builtin.SourceLocation, comptime scope: @Type(.enum_literal), comptime format: []const u8, args: anytype) void {
    logsrc(src, .debug, scope, format, args);
}

pub fn warn(comptime src: std.builtin.SourceLocation, comptime format: []const u8, args: anytype) void {
    logsrc(src, .warn, .nvim, format, args);
}

pub fn warn_scoped(comptime src: std.builtin.SourceLocation, comptime scope: @Type(.enum_literal), comptime format: []const u8, args: anytype) void {
    logsrc(src, .warn, scope, format, args);
}

pub fn err(comptime src: std.builtin.SourceLocation, comptime format: []const u8, args: anytype) void {
    logsrc(src, .err, .nvim, format, args);
}

pub fn err_scoped(comptime src: std.builtin.SourceLocation, comptime scope: @Type(.enum_literal), comptime format: []const u8, args: anytype) void {
    logsrc(src, .err, scope, format, args);
}
