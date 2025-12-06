const std = @import("std");
const print = std.debug.print;
const fs = std.fs;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alligator = arena.allocator();
    var problems = try std.ArrayList(std.ArrayList(i64)).initCapacity(alligator, 32);
    var operations = try std.ArrayList(u8).initCapacity(alligator, 32);

    const file = try fs.cwd().openFile("day06.txt", .{});
    defer file.close();
    var file_buffer: [4096]u8 = undefined;
    var reader = file.reader(&file_buffer);
    var linenum: usize = 0;
    while (try reader.interface.takeDelimiter('\n')) |line| {
        var splittor = std.mem.splitScalar(u8, line, ' ');
        var pb_index: usize = 0;
        while (splittor.next()) |item| {
            if (item.len == 0) continue;
            const first = item[0];
            if (first == '+' or first == '*') {
                try operations.append(alligator, first);
            } else {
                const num = try std.fmt.parseInt(u32, item, 10);
                if (problems.items.len == pb_index)
                    try problems.append(alligator, try std.ArrayList(i64).initCapacity(alligator, 32));
                try problems.items[pb_index].append(alligator, num);
            }
            pb_index += 1;
        }
        linenum += 1;
    }
    var accuaccu: i64 = 0;
    for (problems.items, 0..) |pb, pbi| {
        const op = operations.items[pbi];
        var accu: i64 = if (op == '*') 1 else 0;
        for (pb.items) |n| {
            if (op == '*') {
                accu *= n;
            } else {
                accu += n;
            }
        }
        print("+ {d}\n", .{accu});
        accuaccu += accu;
    }
    print("= {d}\n", .{accuaccu});
}
