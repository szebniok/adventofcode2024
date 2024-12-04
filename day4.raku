my @input = "day4input.txt".IO.lines;
my @letters = @input».comb;

my @dirs = (1, 0), (1, 1), (0, 1), (-1, 1);
my @offsets = @dirs.map({(0..3).map(@$_ X* *).list});
my $result;
for 0..^@letters -> $y {
    for 0..^@letters -> $x {
        my @xy = $x, $y;
        for @offsets {
            my $coords = $_.map({ @$_ Z+ @xy })».list;
            next unless (0 <= $coords.flat.all < +@letters);
            my $word = $coords.map({ @letters[$_[1]][$_[0]] }).join();
            $result += so $word === "XMAS"|"SAMX";
        }
    }
}
say $result;

# 2 star
@offsets = (-1, -1), (1, 1), (1, -1), (-1, 1);
$result = 0;
for 0..^@letters -> $y {
    for 0..^@letters -> $x {
        next unless @letters[$y][$x] === "A";
        my @xy = $x, $y;
        my $coords = @offsets.map({ @$_ Z+ @xy })».list;
        next unless (0 <= $coords.flat.all < +@letters);
        my $word = $coords.map({ @letters[$_[1]][$_[0]] }).join();
        $result += so $word === "MSMS"|"MSSM"|"SMMS"|"SMSM";
    }
}
say $result;