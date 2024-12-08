my @input = "day8input.txt".IO.lines;
my @grid = @input».comb;

my %antennas = gather for @grid.kv -> $y, @row {
    for @row.kv -> $x, $_ {
        next if $_ === ".";
        take ($_, ($x, $y));
    }
}.classify(*[0], :as(*[1]));

say gather for %antennas.values {
    for .combinations(2) -> (@a, @b) {
        my @diff = @b Z- @a;
        for (@b Z+ @diff), (@a Z- @diff) {
            take @_.join(" ") if @_.all ∈ ^@grid;
        }
    }
}.unique.elems;

# 2 star
say gather for %antennas.values {
    for .combinations(2) -> (@a, @b) {
        my @diff = @b Z- @a;
        my @n = @a;
        while @n.all ∈ ^@grid {
            take @n.join(" ");
            @n Z-= @diff;
        }
        @n = @b;
        while @n.all ∈ ^@grid {
            take @n.join(" ");
            @n Z+= @diff;
        }
    }
}.unique.elems;