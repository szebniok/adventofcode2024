my @input = "day10input.txt".IO.lines;
my @grid = @input».comb;

sub get-trailheads(:$part2 = False) {
    sum gather for ^@grid X ^@grid -> ($y, $x) {
        next if @grid[$y;$x] !== 0;
        my @queue = [[$x, $y],]; 
        my $visited = SetHash.new;
        take gather while @queue > 0 {
            my ($nx, $ny) = @queue.pop;
            my $height = @grid[$ny;$nx];
            for (0, -1), (1, 0), (0, 1), (-1, 0) -> ($Δx, $Δy) {
                my ($mx, $my) = ($nx + $Δx, $ny + $Δy);
                next unless ($mx, $my).all ∈ ^@grid;
                next unless @grid[$my; $mx] - $height == 1;
                next if !$part2 and $visited{"$mx $my"}++;
                @grid[$my; $mx] == 9
                    ?? take 1
                    !! @queue.push: [$mx, $my];
            }
        }
    }
}
say get-trailheads;
say get-trailheads(:part2);