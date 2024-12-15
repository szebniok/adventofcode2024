my $input = "day15input.txt".IO.slurp;
my ($grid-encoded, $moves-encoded) = $input.split("\n\n");
my @grid = $grid-encoded.lines».comb».Array;
my @moves = $moves-encoded.comb.grep(* eq "^"|">"|"v"|"<");
my ($y, $x) = @grid.map({.first("@"):k}).first(?*):kv;
@grid[$y; $x] = ".";
my %directions = "^>v<".comb Z=> ((0, -1), (1, 0), (0, 1), (-1, 0));
for @moves {
    my ($dx, $dy) = %directions{$_};
    my $boxes = (^∞).first: {
        @grid[$y + $dy * ($_ + 1); $x + $dx * ($_ + 1)] ne "O"
    }
    next if @grid[$y + $dy * ($boxes + 1); $x + $dx * ($boxes + 1)] eq "#";
    ($x,$y) Z+= $dx,$dy;
    @grid[$y + $dy * $boxes; $x + $dx * $boxes] = "O";
    @grid[$y; $x] = ".";
}
say sum gather for ^@grid X ^@grid[0] -> ($y, $x) {
    take 100 * $y + $x if @grid[$y; $x] eq "O";
}

# 2 star
@grid = $grid-encoded.lines».comb».Array;
@grid .= map({
    .flatmap(*.trans(["#","O",".","@"] => ('##','[]','..','@.')).comb).Array
});
($y, $x) = @grid.map({.first("@"):k}).first(?*):kv;
@grid[$y; $x] = ".";
MOVE:
for @moves {
    my ($dx, $dy) = %directions{$_};
    when $dx == -1|1 {
        my $boxes = (^∞).first({ @grid[$y; $x + $dx * ($_ + 1)] ne "["|"]" });
        my $box-char = @grid[$y; $x + $dx];
        next if @grid[$y; $x + $dx * ($boxes + 1)] eq "#";
        $x += $dx;
        for ^$boxes {
            FIRST { @grid[$y; $x] = "." }
            @grid[$y; $x + $dx * ($_ + 1)] = $box-char;
            $box-char = $box-char eq "]" ?? "[" !! "]";
        }
    }
    next if @grid[$y + $dy; $x] eq "#";
    when @grid[$y + $dy; $x] eq "." { $y += $dy }
    my @queue = (@grid[$y + $dy; $x] eq "[" ?? $x !! $x - 1, $y+$dy),;
    my @to-move;
    while @queue > 0 {
        my ($cx, $cy) = @queue.pop;
        @to-move.push: ($cx, $cy);
        next MOVE if @grid[$cy + $dy; $cx | ($cx + 1)].any eq "#";
        @queue.push: ($cx - 1, $cy + $dy) if @grid[$cy + $dy; $cx] eq "]";
        @queue.push: ($cx, $cy + $dy) if @grid[$cy + $dy; $cx] eq "[";
        @queue.push: ($cx + 1, $cy + $dy) if @grid[$cy + $dy; $cx + 1] eq "[";
    }
    $y += $dy;
    for @to-move -> ($cx, $cy) {
        (@grid[$cy; $cx], @grid[$cy; $cx+1]) »[=]» ".";
    }
    for @to-move -> ($cx, $cy) {
        @grid[$cy+$dy; $cx] = "[";
        @grid[$cy+$dy; $cx+1] = "]";
    }
}
say sum gather for ^@grid X ^@grid[0] -> ($y, $x) {
    take 100 * $y + $x if @grid[$y; $x] eq "[";
}