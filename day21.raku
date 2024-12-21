my @input = "day21input.txt".IO.lines;
my &digit-to-pos = {
    when 1..9 { ( ($_ - 1) mod 3, 2 - ($_ - 1) div 3 ) }
    when 0 { ( 1, 3 ) }
    when "A" { ( 2, 3 ) }
}
my &dir-to-pos = {
    when "^" { ( 1, 0 ) }
    when ">" { ( 2, 1 ) }
    when "v" { ( 1, 1 ) }
    when "<" { ( 0, 1 ) }
    when "A" { ( 2, 0 ) }
}
my @dir-pad = "^A<v>".comb;
my %first = (@dir-pad X~ " " X~ @dir-pad) X=> 1;
my @cost = $%first;
for ^25 -> $level {
    my %current;
    for @dir-pad X @dir-pad -> ($from, $to) {
        my ($x-pos, $y-pos) = dir-to-pos($from);
        my ($x-target, $y-target) = dir-to-pos($to);
        my $path = [~]
            "<" x -($x-target - $x-pos),
            ">" x ($x-target - $x-pos),
            "^" x -($y-target - $y-pos),
            "v" x ($y-target - $y-pos);
        my @paths = $path.comb.permutations.unique(as => *.join).grep({
            my ($x, $y) = $x-pos, $y-pos;
            not .first: {
                $x-- if $_ eq "<";
                $x++ if $_ eq ">";
                $y-- if $_ eq "^";
                $y++ if $_ eq "v";
                ($x, $y) eqv (0, 0);
            }
        }).map("A" ~ *.join ~ "A");
        %current{"$from $to"} = @paths.map(*.comb).map({
            @cost[$level]{.rotor(2=>-1).map(*.join(" "))};
        }).map(*.sum).min
    }
    @cost.push: %current;
}
my @digit-pad = "0123456789A".comb;
my @digit-costs;
for 2, 25 -> $level {
    my %digit-cost;
    for @digit-pad X @digit-pad -> ($from, $to) {
        my ($x-dir, $y-dir) = digit-to-pos($from);
        my ($x-target, $y-target) = digit-to-pos($to);
        my $path = [~]
            "<" x -($x-target - $x-dir),
            ">" x ($x-target - $x-dir),
            "^" x -($y-target - $y-dir),
            "v" x ($y-target - $y-dir);
        my @paths = $path.comb.permutations.unique(as => *.join).grep({
            my ($x, $y) = $x-dir, $y-dir;
            not .first: {
                $x-- if $_ eq "<";
                $x++ if $_ eq ">";
                $y-- if $_ eq "^";
                $y++ if $_ eq "v";
                ($x, $y) eqv (0, 3);
            }
        }).map(*.join).map("A" ~ * ~ "A");
        %digit-cost{"$from $to"} = @paths.map(*.comb).map({
            @cost[$level]{.rotor(2=>-1).map(*.join(" "))};
        }).map(*.sum).min
    }
    @digit-costs.push: %digit-cost;
}
say sum gather for @input {
    my $cost = @digit-costs[0]{"A$_".comb.rotor(2=>-1).map(*.join(" "))};
    take $_.substr(0, * - 1) * $cost.sum;
}
# 2 star
say sum gather for @input {
    my $cost = @digit-costs[1]{"A$_".comb.rotor(2=>-1).map(*.join(" "))};
    take $_.substr(0, * - 1) * $cost.sum;
}