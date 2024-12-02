my @lines = "day2input.txt".IO.lines;
my @reports = @lines».words».Array;

sub is-safe(@arg) {
    my @diffs = @arg.rotor(2 => -1).map({[-] $_});
    @diffs.all ~~ (-3..-1)|(1..3);
}
say @reports.grep(&is-safe).elems;

# 2 star
say @reports.grep({
    (for 0..^$_ -> $i {
        my @dampened = $_[0..^$i, $i^..*].flat;
        is-safe(@dampened)
    }).any.so
}).elems;