my @input = "day6input.txt".IO.lines;
my @grid = @input».comb».Array;

my @initial-pos = @grid.map({.first("^"):k}).first(?*):kv;
my ($y, $x) = @initial-pos;
my @directions = (0, -1), {-.[1], .[0]} … ∞;
my $visited = ∅;
for @directions -> ($dir-x, $dir-y) {
    $visited ∪= "$x $y";
    my ($ny, $nx) = ($y + $dir-y, $x + $dir-x);
    last unless $ny & $nx ~~ ^@grid;
    next if @grid[$ny; $nx] === "#";
    ($y, $x) = $ny, $nx;
    redo;
}
say $visited.elems;

# 2 star
my $result = 0;
for $visited.keys {
    my ($obs-x, $obs-y) = $_.words;
    next unless @grid[$obs-y; $obs-x] === ".";
    temp @grid[$obs-y; $obs-x] = "#";
    my ($y, $x) = @initial-pos;
    my $visited = ∅;
    my @directions = (0, -1), {-.[1], .[0]} … ∞;
    for @directions -> ($dir-x, $dir-y) {
        if "$x $y $dir-x $dir-y" ∈ $visited {
            $result++;
            last;
        }
        $visited ∪= "$x $y $dir-x $dir-y";
        my ($ny, $nx) = ($y + $dir-y, $x + $dir-x);
        last unless $ny & $nx ~~ ^@grid;
        next if @grid[$ny; $nx] === "#";
        ($y, $x) = ($ny, $nx);
        redo;
    }
}
say $result;