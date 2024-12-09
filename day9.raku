my $input = "day9input.txt".IO.slurp;

my @disk = ($input ~ "0").comb.rotor(2).kv.map(-> $id, ($len, $gap) {
    ($id xx $len), ("." xx $gap);
}).flat;
my $left = 0;
while $left < +@disk {
    when @disk[$left] ne "." { $left++ }
    @disk[$left] = @disk.pop;
}
say @disk.kv.map(* * *).sum;

# 2 star
@disk = ($input ~ "0").comb.rotor(2).kv.map(-> $id, ($len, $gap) {
    [$id, $len, $gap]
});
for (^@disk).reverse -> $src {
    my $dest = @disk[^$src].first({ .[2] >= @disk[$src][1] }):k;
    with $dest {
        my $freed = [+] @disk[$src][1,2];
        @disk = @disk[
            0..$dest,
            $src,
            $dest+1..^$src,
            $src^..^*
        ].flat;
        @disk[$dest + 1][2] = @disk[$dest][2] - @disk[$dest + 1][1];
        @disk[$dest][2] = 0;
        @disk[$src][2] += $freed;
        redo;
    }
}
say gather for @disk -> ($id, $len, $gap) {
    state $idx = 0;
    take $id * ((^$len) + $idx).sum;
    $idx += $len + $gap;
}.sum;