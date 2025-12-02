const std = @import("std");
const print = std.debug.print;
const fs = std.fs;

pub fn main() !void {
    var pos: u32 = 50;
    var password: u32 = 0;

    const file = try fs.cwd().openFile("day01.txt", .{});
    defer file.close();

    var file_buffer: [4096]u8 = undefined;
    var reader = file.reader(&file_buffer);
    while (try reader.interface.takeDelimiter('\n')) |line| {
        const direction = line[0..1];
        const clicks = try std.fmt.parseInt(u32, line[1..], 10);
        if (std.mem.eql(u8, direction, "R")) {
            pos += clicks;
            pos %= 100;
        } else if (std.mem.eql(u8, direction, "L")) {
            if (pos < clicks)
                pos += 100;
            pos -= clicks;
            pos %= 100;
        }
        if (pos == 0)
            password += 1;
    }
    print("Password: {d}\n", .{password});
}
