my @input = "day20input.txt".IO.lines;
my @grid = @input».comb».Array;
my ($y-start, $x-start) = @grid.map({.first("S"):k}).first(?*):kv;
my ($y-end, $x-end) = @grid.map({.first("E"):k}).first(?*):kv;
sub get-dists($x, $y) {
    my @Q = $($x, $y, 0);
    my %result;
    while @Q {
        my ($x, $y, $score) = @Q.shift;
        next with %result{"$x $y"};
        %result{"$x $y"} = $score;
        for (0, -1), (1, 0), (0, 1), (-1, 0) -> ($nΔx, $nΔy) {
            my ($nx, $ny) = ($x, $y) »+« ($nΔx, $nΔy);
            next unless $nx&$ny ∈ ^@grid;
            next if @grid[$ny; $nx] eq "#";
            @Q.push: ($nx, $ny, $score + 1);
        }
    };
    %result;
}
my %from-start = get-dists($x-start, $y-start);
my %from-end = get-dists($x-end, $y-end);
my @from-end-unrolled = %from-end.map({ (|.key.split(" ")».Int, .value) });
sub get-cheat-count($duration) {
    sum do for %from-start {
        my ($x, $y) = .key.split(" ")».Int;
        my $legit-dist = .value + %from-end{"$x $y"};
        @from-end-unrolled.race.grep(-> ($x-end, $y-end, $dist-end) {
            my $cheat-dist = (($x, $y) »-« ($x-end, $y-end))».abs.sum;
            next if $cheat-dist > $duration;
            $legit-dist > %from-start{"$x $y"} + $dist-end + $cheat-dist + 99
        }).elems;
    }
}
say get-cheat-count(2);
# 2 star
say get-cheat-count(20);