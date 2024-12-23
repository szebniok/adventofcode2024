my @input = "day23input.txt".IO.lines;
my %edges;
for @input {
    my ($a, $b) = $_.comb(/<alpha>+/);
    (%edges{$a} //= []).push: $b;
    (%edges{$b} //= []).push: $a;
}
say (gather for %edges -> $first {
    next unless $first.key.starts-with("t");
    for @($first.value) -> $second {
        my $third = %edges{$second}.Set ∩ $first.value.Set;
        for @($third.keys) {
            take ($first.key, $second, $_).sort.join;
        }
    }
}).unique.elems;
# 2 star
say (gather for %edges -> $first {
    my $lan = $first.SetHash;
    for @($first.value) -> $second {
        next unless $lan ⊂ %edges{$second}.Set;
        $lan{$second}++;
    }
    take $lan.keys.sort.join(",")
}).max(*.chars);