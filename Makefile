days = day01 day02 day03 day04

.PHONY: all clean

all: $(days)

$(days): %: %.zig
	zig build-exe $^

clean:
	rm -f $(days)
