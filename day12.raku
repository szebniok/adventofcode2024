my @input = "day12input.txt".IO.lines;
my @grid = @input».comb;

my $visited = SetHash.new;
say sum gather for ^@grid X ^@grid -> ($y, $x) {
    next if $visited{"$x $y"};
    my $area;
    my $perimeter;
    my @queue = ($x, $y),;
    while @queue > 0 {
        my ($cx, $cy) = @queue.pop;
        next if $visited{"$cx $cy"}++;
        $area++;
        for (0, -1), (1, 0), (0, 1), (-1, 0) -> ($Δx, $Δy) {
            my ($nx, $ny) = ($cx + $Δx, $cy + $Δy);
            if ($nx, $ny).all ∈ ^@grid and @grid[$ny;$nx] eq @grid[$y;$x] {
                @queue.push: ($nx, $ny);
            } else {
                $perimeter++;
            }
        }
    }
    take $area * $perimeter;
}

# 2 star
$visited = SetHash.new;
say sum gather for ^@grid X ^@grid -> ($y, $x) {
    next if $visited{"$x $y"};
    my $area;
    my %perimeter;
    my @queue = ($x, $y),;
    while @queue > 0 {
        my ($cx, $cy) = @queue.pop;
        next if $visited{"$cx $cy"}++;
        $area++;
        for (0, -1), (1, 0), (0, 1), (-1, 0) -> ($Δx, $Δy) {
            my ($nx, $ny) = ($cx + $Δx, $cy + $Δy);
            if ($nx, $ny).all ∈ ^@grid and @grid[$ny;$nx] eq @grid[$y;$x] {
                @queue.push: ($nx, $ny);
            } else {
                (%perimeter{"$Δx $Δy"} //= []).push: ($cx, $cy)
            }
        }
    }
    my $sides-count = sum gather for %perimeter {
        my ($by, $as) = .key.words».abs;
        my $row-or-column = .value.categorize(*[$by], :as(*[$as])).map({
            $_.key => set |$_.value
        }).sort(*.key).map(*.value);
        take (Set.new, |$row-or-column).rotor(2 => -1).map({.[1] ∖ .[0]}).sum;
    }
    take $area * $sides-count;
}