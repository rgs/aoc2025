const std = @import("std");
const print = std.debug.print;
const fs = std.fs;

fn offset(x: usize, y: usize, cols: usize) usize {
    return x * (cols + 1) + y;
}

pub fn main() !void {
    var num_rows: usize = 0;
    var num_cols: usize = 0;

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const buffer: []u8 = try allocator.alloc(u8, 4096);
    var file_contents = std.ArrayList(u8).initBuffer(buffer);

    // Read the file in file_contents, count number of columns and rows
    const file = try fs.cwd().openFile("day04.txt", .{});
    defer file.close();
    var file_buffer: [4096]u8 = undefined;
    var reader = file.reader(&file_buffer);
    while (try reader.interface.takeDelimiter('\n')) |line| {
        num_rows += 1;
        if (line.len > num_cols)
            num_cols = line.len;
        try file_contents.appendSliceBounded(line);
        try file_contents.appendBounded('\n');
    }

    // Allocate a buffer to hold the 2D floorplan plus a border
    const bufsize = (num_rows + 2) * (num_cols + 2);
    const floorplan: []u8 = try allocator.alloc(u8, bufsize);
    for (floorplan) |*item|
        item.* = 0;

    var fixed_reader = std.Io.Reader.fixed(file_contents.items);
    var row: usize = 1;
    while (try fixed_reader.takeDelimiter('\n')) |line| {
        for (line, 0..) |char, col| {
            if (char == '@')
                floorplan[offset(col + 1, row, num_cols)] = 1;
        }
        row += 1;
    }

    var count_rolls: u16 = 0;
    for (1..(num_rows + 1)) |y| {
        for (1..(num_cols + 1)) |x| {
            if (floorplan[offset(x, y, num_cols)] == 0) {
                print(".", .{});
                continue;
            }
            const adjacent_rolls = (floorplan[offset(x - 1, y - 1, num_cols)] +
                floorplan[offset(x - 1, y, num_cols)] +
                floorplan[offset(x - 1, y + 1, num_cols)] +
                floorplan[offset(x, y - 1, num_cols)] +
                floorplan[offset(x, y + 1, num_cols)] +
                floorplan[offset(x + 1, y - 1, num_cols)] +
                floorplan[offset(x + 1, y, num_cols)] +
                floorplan[offset(x + 1, y + 1, num_cols)]);
            if (adjacent_rolls < 4) {
                print("x", .{});
                count_rolls += 1;
            } else {
                print("@", .{});
            }
        }
        print("\n", .{});
    }
    print("Count of paper rolls = {d}\n", .{count_rolls});
}
