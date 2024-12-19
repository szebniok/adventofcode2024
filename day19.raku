my $input = "day19input.txt".IO.slurp;
my (@towels, @designs) := $input.split("\n\n")».comb(/<alpha>+/);
say sum gather for @designs -> $design {
    my @possible = True, |(False xx $design.chars);
    for ^$design.chars -> $i {
        next unless @possible[$i];
        for @towels.grep({$design.substr($i).starts-with($_)}) {
            @possible[$i + .chars] = True;
        }
    }
    take @possible.tail;
}
# 2 star
say sum gather for @designs -> $design {
    my @ways = 1, |(0 xx $design.chars);
    for ^$design.chars -> $i {
        next unless @ways[$i] > 0;
        for @towels.grep({$design.substr($i).starts-with($_)}) {
            @ways[$i + $_.chars] += @ways[$i];
        }
    }
    take @ways.tail;
}