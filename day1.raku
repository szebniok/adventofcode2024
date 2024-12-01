my @lines = "day1input.txt".IO.lines;

my ($a, $b) = [Z] @lines>>.words;

say zip(($a, $b)>>.sort).map({(.[0] - .[1]).abs}).sum;

# 2 star
my %occ is default(0);
%occ{$_}++ for |$b;

say $a.map({
    $_ * %occ{$_};
}).sum;