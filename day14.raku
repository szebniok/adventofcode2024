my @input = "day14input.txt".IO.lines;
my @robots = @input».comb(/"-"?<digit>+/)».batch(2)».Array;
my ($width, $height) = 101, 103;
my @hundred-seconds = @robots.map: -> ($p, $v) {
    ($p «+» (100 «*« $v)) «%» ($width, $height)
}
my @midpoints = ($width, $height) »div» 2;
say [×] @hundred-seconds.grep({[&&] @$_ Z!= @midpoints})
    .classify({(@$_ Z> @midpoints)})
    .map(*.value)
    .flatmap(*.map(*.value.elems));

# 2 star
for ^∞ -> $i {
    my @i-seconds = @robots.map: -> ($p, $v) {
        ($p «+» ($i «*« $v)) «%» ($width, $height)
    }
    my $points = set @i-seconds.map(*.join(" "));
    for $points.keys {
        my ($x, $y) = $_.words;
        next unless $points{"$x {$y + 1}"};
        next unless $points{"{$x - 1} {$y + 1}"};
        next unless $points{"{$x + 1} {$y + 1}"};
        next unless $points{"$x {$y + 2}"};
        next unless $points{"{$x - 2} {$y + 2}"};
        next unless $points{"{$x - 1} {$y + 2}"};
        next unless $points{"{$x + 1} {$y + 2}"};
        next unless $points{"{$x + 2} {$y + 2}"};
        say "$i second:";
        for ^$height -> $y {
            for ^$width -> $x {
                print $points{"$x $y"} ?? "#" !! " ";
            }
            say "";
        }
        exit;
    }
}