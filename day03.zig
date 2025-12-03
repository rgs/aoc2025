const std = @import("std");
const print = std.debug.print;
const fs = std.fs;

pub fn main() !void {
    var total_joltage: i64 = 0;
    const file = try fs.cwd().openFile("day03.txt", .{});
    defer file.close();
    var file_buffer: [4096]u8 = undefined;
    var reader = file.reader(&file_buffer);
    while (try reader.interface.takeDelimiter('\n')) |bank| {
        var first_digit: u8 = '0';
        var first_index: usize = 0;
        var second_digit: u8 = '0';
        for (bank[0..(bank.len - 1)], 0..) |d, index| {
            if (d > first_digit) {
                first_digit = d;
                first_index = index;
            }
        }
        for (bank[(first_index + 1)..]) |d| {
            if (d > second_digit) {
                second_digit = d;
            }
        }
        const joltage = try std.fmt.parseInt(u32, &[_]u8{ first_digit, second_digit }, 10);
        print("Joltage = {d}\n", .{joltage});
        total_joltage += joltage;
    }
    print("Total joltage = {d}\n", .{total_joltage});
}
