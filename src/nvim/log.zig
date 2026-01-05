const std = @import("std");
const c = @import("root.zig").c;
const LOG_MAX_SIZE = 65536;
const LOG_DEV = true;

fn logBase(
    comptime level: std.log.Level,
    comptime scope: @Type(.enum_literal),
    comptime format: []const u8,
    args: anytype,
) void {
    const scope_str = "(" ++ @tagName(scope) ++ "):";

    var log_buf: [LOG_MAX_SIZE]u8 = undefined;
    if (LOG_DEV) {
        const f = std.fs.createFileAbsolute(
            "/tmp/nvim_dev_debug.txt",
            .{ .mode = 0o640, .truncate = false },
        ) catch return;
        defer f.close();

        f.seekFromEnd(0) catch return;

        const msg = std.fmt.bufPrint(&log_buf, level.asText() ++ " "  ++ scope_str ++ " " ++ format ++ "\n", args) catch return;
        f.writeAll(msg) catch return;
    } else {
        const lvl = switch (level) {
            .debug => c.LOGLVL_DBG,
            .info => c.LOGLVL_INF,
            .warn => c.LOGLVL_WRN,
            .err => c.LOGLVL_ERR,
        };

        const context = scope_str ++ "\x00";
        const msg = std.fmt.bufPrint(&log_buf, format ++ "\x00", args) catch return;
        _ = c.logmsg(lvl, context, null, -1, true, msg.ptr);
    }
}

/// The default logger, which will only log warning or error level messages.
/// This is what we set in our std_options so that logging from external libraries
/// isn't too noisy.
pub fn log(
    comptime level: std.log.Level,
    comptime scope: @Type(.enum_literal),
    comptime format: []const u8,
    args: anytype,
) void {
    if (@intFromEnum(level) > @intFromEnum(std.log.Level.warn)) return;
    logBase(level, scope, format, args);
}

fn logsrc(
    comptime src: std.builtin.SourceLocation,
    comptime level: std.log.Level,
    comptime scope: @Type(.enum_literal),
    comptime format: []const u8,
    args: anytype,
) void {
    const ArgsType = @TypeOf(args);
    const args_type_info = @typeInfo(ArgsType);
    comptime if (args_type_info != .@"struct") {
        var errbuf: [1024]u8 = undefined;
        const e = std.fmt.bufPrint(
            &errbuf,
            src.file ++ ":{}: expected tuple or struct argument, found " ++ @typeName(ArgsType),
            .{src.line},
        ) catch "expected tuple or struct argument, found " ++ @typeName(ArgsType);
        @compileError(e);
    };

    const new_format = src.fn_name ++ ":{}: " ++ format;
    const new_args = .{src.line} ++ args;
    logBase(level, scope, new_format, new_args);
}

pub fn scoped(comptime scope: @Type(.enum_literal)) type {
    return struct {
        pub fn info(comptime src: std.builtin.SourceLocation, comptime format: []const u8, args: anytype) void {
            logsrc(src, .info, scope, format, args);
        }

        pub fn debug(comptime src: std.builtin.SourceLocation, comptime format: []const u8, args: anytype) void {
            logsrc(src, .debug, scope, format, args);
        }

        pub fn warn(comptime src: std.builtin.SourceLocation, comptime format: []const u8, args: anytype) void {
            logsrc(src, .warn, scope, format, args);
        }

        pub fn err(comptime src: std.builtin.SourceLocation, comptime format: []const u8, args: anytype) void {
            logsrc(src, .err, scope, format, args);
        }
    };
}
