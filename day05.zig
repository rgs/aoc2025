const std = @import("std");
const print = std.debug.print;
const fs = std.fs;

const Range = struct { from: u32, to: u32 };

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    const buffer: []Range = try allocator.alloc(Range, 64);
    var ranges = std.ArrayList(Range).initBuffer(buffer);
    var fresh_count: u32 = 0;

    const file = try fs.cwd().openFile("day05.txt", .{});
    defer file.close();
    var file_buffer: [4096]u8 = undefined;
    var reader = file.reader(&file_buffer);
    while (try reader.interface.takeDelimiter('\n')) |line| {
        // ingredient range a-b
        if (std.mem.indexOf(u8, line, "-")) |i| {
            const range: Range = .{
                .from = try std.fmt.parseInt(u32, line[0..i], 10),
                .to = try std.fmt.parseInt(u32, line[i + 1 ..], 10),
            };
            print("Range: {d} {d}\n", .{ range.from, range.to });
            try ranges.append(allocator, range);
        } else break;
    }
    while (try reader.interface.takeDelimiter('\n')) |line| {
        const ingredient_id = try std.fmt.parseInt(u32, line, 10);
        for (ranges.items) |r| {
            if (ingredient_id >= r.from and ingredient_id <= r.to) {
                print("ingredient {d} is fresh\n", .{ingredient_id});
                fresh_count += 1;
                break;
            }
        } else print("ingredient {d} is spoiled\n", .{ingredient_id});
    }
    print("Fresh count = {d}\n", .{fresh_count});
}
