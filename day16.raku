my @input = "day16input.txt".IO.lines;
my @grid = @input».comb».Array;
my ($y, $x) = @grid.map({.first("S"):k}).first(?*):kv;
sub find-path($best-score) {
    my %𝒬 = "$x $y 1 0" => (0, ());
    my $visited = SetHash.new;
    while %𝒬 {
        my $key = %𝒬.pairs.min(*.value[0]).key;
        my ($x, $y, $Δx, $Δy) = $key.split(" ");
        my ($score, $path) = %𝒬{$key}:delete;
        $path = (|$path, $key);
        next if $visited{$key}++;
        next if $score > $best-score;
        return ($score, $path) if @grid[$y; $x] eq "E";
        for ($Δx, $Δy), ($Δy, -$Δx), (-$Δy, $Δx) -> ($nΔx, $nΔy) {
            my ($nx, $ny) = ($x, $y) »+« ($nΔx, $nΔy);
            next if @grid[$ny; $nx] eq "#";
            my $cost = ($Δx, $Δy) eqv ($nΔx, $nΔy) ?? 1 !! 1001;
            %𝒬{"$nx $ny $nΔx $nΔy"} = ($score + $cost, $path)
        }
    };
}
my ($best-score, $best-path) = find-path(∞);
say $best-score;

# 2 star
my $all = [∪] gather for @$best-path[1..*] {
    my ($wall-x, $wall-y) = .split(" ")[^2];
    temp @grid[$wall-y; $wall-x] = "#";
    my ($score, $path) = find-path($best-score);
    take $path.Set if $score eqv $best-score;
}
say ($all ∪ $best-path.Set).keys.map(*.split(" ")[^2].join(" ")).unique.elems;