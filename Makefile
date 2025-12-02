days = day01 day02

.PHONY: all clean

all: $(days)

$(days): %: %.zig
	zig build-exe $^

clean:
	rm -f $(days)
