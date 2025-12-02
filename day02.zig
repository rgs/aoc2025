const std = @import("std");
const print = std.debug.print;
const fs = std.fs;

pub fn main() !void {
    var accumulator: u64 = 0;

    const file = try fs.cwd().openFile("day02.txt", .{});
    defer file.close();

    var file_buffer: [4096]u8 = undefined;
    var reader = file.reader(&file_buffer);
    while (try reader.interface.takeDelimiter(',')) |item| {
        var end_index: usize = 0;
        for (item, 0..) |character, index| {
            if (character != '-' and (character < '0' or character > '9'))
                break;
            end_index = index + 1;
        }
        const range: []u8 = item[0..end_index];
        var range_begin: []u8 = range;
        var range_end: []u8 = range;
        if (std.mem.indexOf(u8, range, "-")) |index| {
            range_begin = range[0..index];
            range_end = range[(index + 1)..];
        }
        if (range_begin.len == 0 or range_end.len == 0)
            continue;
        const range_begin_value = try std.fmt.parseInt(u32, range_begin, 10);
        const range_end_value = try std.fmt.parseInt(u32, range_end, 10);
        print("Range: {s} {d} {d}\n", .{ range, range_begin_value, range_end_value });

        for (range_begin_value..(range_end_value + 1)) |v| {
            var b: [20]u8 = undefined;
            const vstring = try std.fmt.bufPrint(&b, "{d}", .{v});
            if (vstring.len % 2 == 1)
                continue;
            const halfsize: usize = vstring.len / 2;
            if (std.mem.eql(u8, vstring[0..halfsize], vstring[halfsize..])) {
                print("> {s}\n", .{vstring});
                accumulator += try std.fmt.parseInt(u32, vstring, 10);
            }
        }
    }
    print("Total: {d}\n", .{accumulator});
}
