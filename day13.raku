my $input = "day13input.txt".IO.slurp;
my token button { "Button " . ": X+" (<digit>+) ", Y+" (<digit>+) }
my token prize { "Prize: X=" (<digit>+) ", Y=" (<digit>+) }
my token machine { <button> \n <button> \n <prize> \n? }
my @machines = $input.match(&machine, :g).map: {
    (|.<button>.map(*[0,1]), .<prize>[0,1]);
}
sub circumfix:<🎄 🌟>($_) { .[0] * .[3] - .[1] * .[2] }
sub token-count(($a-x, $a-y), ($b-x, $b-y), ($p-x, $p-y)) {
    my $det   = 🎄$a-x, $b-x, $a-y, $b-y🌟;
    my $det-a = 🎄$p-x, $b-x, $p-y, $b-y🌟;
    my $det-b = 🎄$a-x, $p-x, $a-y, $p-y🌟;
    my ($a, $b) = ($det-a, $det-b) »/» $det;
    ($a, $b).all ~~ * %% 1 ?? 3*$a + $b !! 0;
}
say @machines.map({token-count(|$_)}).sum;
# 2 star
say @machines.map({token-count(|.[0,1], .[2] »+» 10¹³)}).sum;