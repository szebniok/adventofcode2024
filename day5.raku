my $input = "day5input.txt".IO.slurp;
my ($encoded-rules, $encoded-pages) = $input.split("\n\n");

my %rules;
for $encoded-rules.lines {
    my ($before, $after) = .split("|");
    (%rules{$before} //= Set.new) ∪= $after;
}
my $result;
for $encoded-pages.lines {
    my @pages = $_.split(",");
    my $valid = @pages.kv.map(-> $i, $_ { %rules{$_} ⊇ @pages[$i^..*] }).all;
    $result += @pages[* div 2] if $valid;
}
say $result;

# 2 star
my $result2 = 0;
for $encoded-pages.lines {
    my @pages = $_.split(",");
    $result2 += @pages.first({(%rules{$_} ∩ @pages) == @pages div 2}); 
}
say $result2 - $result;