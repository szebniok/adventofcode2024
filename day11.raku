my $input = "day11input.txt".IO.slurp;
my %stones = $input.words.Bag;
my &blink = {
    when 0 { 1 }
    when .chars %% 2 { (+.substr(0, .chars / 2), +.substr(.chars / 2)) }
    default { $_ * 2024 }
}
for ^75 {
    if $_ ≡ 25 { say %stones.values.sum }
    %stones = %stones.map({ blink(.key) X=> .value }).Bag;
}
# 2 star
say %stones.values.sum;