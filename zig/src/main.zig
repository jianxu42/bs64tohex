const std = @import("std");

pub fn main() !void {
    const err = error.ArgsNotFound;
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);
    if (args.len < 2) {
        std.debug.print("Usage: {s} <base64>\n", .{args[0]});
        return err;
    }

    const base64 = std.base64;
    const base64String = args[1];
    var buffer: [0x100]u8 = undefined;
    var decoded = buffer[0..try base64.standard.Decoder.calcSizeForSlice(base64String)];
    try base64.standard.Decoder.decode(decoded, base64String);

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();
    try stdout.print("{s}", .{std.fmt.fmtSliceHexUpper(decoded)});
    try bw.flush();
}
