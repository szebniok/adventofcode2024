my @input = "day18input.txt".IO.lines;
my @bytes = @input».split(",")».Array;
my $width = 70;
sub simulate($steps) {
    my $grid = @bytes.head($steps).map(*.join(" ")).Set;
    my @queue = $(0, 0, 0);
    my $seen = SetHash.new;
    while @queue {
        my ($x, $y, $cost) = @queue.shift;
        return $cost if ($x, $y).all == $width;
        for (0, -1), (1, 0), (0, 1), (-1, 0) -> ($Δx, $Δy) {
            my ($nx, $ny) = ($x, $y) »+« ($Δx, $Δy);
            next unless ($nx, $ny).all ∈ (0..$width);
            next if $grid{"$nx $ny"} or $seen{"$nx $ny"}++;
            @queue.push: ($nx, $ny, $cost + 1);
        }
    }
}
say simulate(1024);

# 2 star
my ($left, $right) = 1024, @bytes.elems;
while ($left < $right) {
    my $m = ($left + $right) div 2;
    if ?simulate($m) { $left = $m + 1 }
    else { $right = $m }
};
say @bytes[$left - 1].join(",");