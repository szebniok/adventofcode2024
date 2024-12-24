my $input = "day24input.txt".IO.slurp;
my ($values-encoded, $wires-encoded) = $input.split("\n\n");
my %values = $values-encoded.lines».split(": ").map({ .[0] => .[1] eq "1" });
my @rules = my @og-rules = $wires-encoded.lines.map(*.words[0,1,2,4]);
sub infix:<🍫>(%values, $xyz) {
    %values.pairs.grep(*.key.starts-with($xyz))
        .sort(*.key).map(*.value).kv.map(-> $id, $v { $v * 2**$id }).sum;
}
sub circumfix:<🎁 🛷>(@arg) {
    my %values = @arg[0].clone;
    my @rules = @arg[1].clone;
    my $rules-count = @rules.elems;
    while @rules {
        my ($a, $op, $b, $dest) = my $top = @rules.shift;
        when not %values{$a&$b}:exists {
            @rules.push: $top;
            return -1 if $rules-count-- < 0;
        }
        $rules-count = @rules.elems;
        %values{$dest} = do given $op, %values{$a}, %values{$b} {
            when .[0] eq "AND" { so (.[1] and .[2]) }
            when .[0] eq "OR"  { so (.[1] or  .[2]) }
            when .[0] eq "XOR" { so (.[1] xor .[2]) }
        };
    }
    %values 🍫 "z";
}
say 🎁%values, @rules🛷;
# 2 star
sub prefix:<📜>($dest) {
    my @queue = @rules.first({.[3] eq $dest}):k;
    my $result = SetHash.new;
    while @queue {
        my $idx = @queue.pop;
        $result{$idx}++;
        my ($a, $, $b, $) = @rules[$idx];
        my $ap = @rules.first({.[3] eq $a}):k;
        my $bp = @rules.first({.[3] eq $b}):k;
        @queue.push($ap) with $ap;
        @queue.push($bp) with $bp;
    }
    $result;
}
sub get-z-for-xy($x is copy, $y is copy, @rules) {
    my %values-new = %values.clone;
    for ^45 {
        %values-new{"x%02d".sprintf($_)} = $x !%% 2;
        %values-new{"y%02d".sprintf($_)} = $y !%% 2;
        ($x, $y) »div=» 2;
    }
    🎁%values-new, @rules🛷;
}
my @arena = [X] gather for 1..43 -> $bit {
    my $x = 2**$bit;
    my $z = get-z-for-xy($x, 0, @rules);
    next if $x == $z;
    my ($prev, $curr, $next) = (-1, 0, 1).map({📜("z%02d".sprintf($bit + $_))});
    my $rules-to-check = ($next ∪ $curr) ∖ $prev;
    my @swaps = gather for $rules-to-check.keys.combinations(2) -> ($s1, $s2) {
        my @rules = @og-rules.clone».Array;
        my $tmp = @rules[$s1][3];
        @rules[$s1][3] = @rules[$s2][3];
        @rules[$s2][3] = $tmp;
        my $fixed-z = get-z-for-xy($x, 0, @rules);
        next unless $fixed-z == $x;
        take ($s1, $s2);
    }
    take @swaps;
}
while @arena > 1 {
    my ($x, $y) = (2**43 - 1, 2**43 - 1)».rand».floor;
    my @arena-next = gather for @arena -> $c {
        my @rules = @og-rules.clone».Array;
        for @$c -> ($s1, $s2) {
            my $tmp = @rules[$s1][3];
            @rules[$s1][3] = @rules[$s2][3];
            @rules[$s2][3] = $tmp;
        }
        my $z = get-z-for-xy($x, $y, @rules);
        take $c if $z == $x + $y;
    }
    @arena = @arena-next;
}
say @rules[@arena[0]».List.flat].map(*[3]).sort.join(",");