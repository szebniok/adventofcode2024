my @input = "day7input.txt".IO.lines;
my @equations = @input.map: { 
    my ($goal, $rest) = .split(":");
    ($goal, $rest.words)
};
sub infix:<☃️> { $^a + $^b | $^a * $^b };
say sum @equations.race.map: -> ($goal, @nums) {
    $goal if ([☃️] @nums) == $goal
};

# 2 star
sub infix:<❄️> { $^a + $^b | $^a * $^b | $^a ~ $^b };
say sum @equations.race.map: -> ($goal, @nums) {
    $goal if ([❄️] @nums) == $goal
};