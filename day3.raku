my $input = "day3input.txt".IO.slurp;

my token mul { mul "(" (<digit>+) "," (<digit>+) ")" };
say $input.match(&mul):g.map({.[0] * .[1]}).sum;

# 2 star
grammar Program {
    regex TOP { [ .*? [ <mul> | <do_> | <don't> ] .*? ]+ }
    token do_ { "do()" }
    token don't { "don't()" }
}
class Actions {
    has $!enabled = True;
    method TOP($/) { make $<mul>».made.sum }
    method mul($/) { make $0 * $1 * $!enabled }
    method do_($/) { $!enabled = True }
    method don't($/) { $!enabled = False }
}
say Program.parse($input, actions => Actions.new).made;