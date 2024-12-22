my @input = "day22input.txt".IO.lines;
my @secrets = @input>>.Int;
sub circumfix:<🎅 🦌>($_) { .[0] +^ .[1] };
sub postfix:<🙊>($a) { $a mod 2²⁴ };
say sum @secrets.race.map: -> $secret is copy {
    for ^2000 {
        $secret = 🎅$secret, $secret *   64🦌🙊;
        $secret = 🎅$secret, $secret div 32🦌🙊;
        $secret = 🎅$secret, $secret * 2048🦌🙊;
    }
    $secret;
}
# 2 star
my %bananas;
for @secrets -> $secret is rw {
    my @prices = ($secret mod 10), |gather for ^2000 {
        $secret = 🎅$secret, $secret *   64🦌🙊;
        $secret = 🎅$secret, $secret div 32🦌🙊;
        $secret = 🎅$secret, $secret * 2048🦌🙊;
        take $secret mod 10;
    }
    my %sequences = @prices.rotor(5 => -4).map({
        .rotor(2 => -1).map({.[1] - .[0]}) => .tail;
    }).classify(*.key.join, as => *.value).pairs.map({.key => .value.head});
    %bananas{.key} += .value for %sequences;
}
say %bananas.values.max;