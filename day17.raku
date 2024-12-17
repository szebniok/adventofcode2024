my $input = "day17input.txt".IO.slurp;
my ($a, $b, $c, @program) := $input.comb(/<digit>+/)[0, 1, 2, 3..*];
sub run($a is copy, $b is copy, $c is copy, @program, $dont-jump?) {
    my $ip = 0;
    my &fetch = { $_ < 4 ?? $_ !! [$a, $b, $c][$_ - 4] };
    gather while $ip < @program {
        my ($opcode, $operand) = @program[$ip, $ip+1];
        my $next-ip = $ip + 2;
        given $opcode {
            when #`[adv] 0 { $a div= 2 ** fetch($operand) }
            when #`[bxl] 1 { $b +^= $operand }
            when #`[bst] 2 { $b = fetch($operand) mod 8 }
            when #`[jnz] 3 { $next-ip = $operand if $a != 0 }
            when #`[bxc] 4 { $b +^= $c }
            when #`[out] 5 { take fetch($operand) mod 8; last if $dont-jump }
            when #`[bdv] 6 { $b = $a div 2 ** fetch($operand) }
            when #`[cdv] 7 { $c = $a div 2 ** fetch($operand) }
        }
        $ip = $next-ip;
    }
}
say run($a, $b, $c, @program).join(",");

# 2 star
# 2,4 $b = $a mod 8;
# 1,5 $b = $b +^ 5;
# 7,5 $c = $a div 2 ** $b;
# 1,6 $b = $b +^ 6;
# 4,3 $b = $b +^ $c;
# 5,5 $b mod 8
# 0,3 $a = $a div 2 ** 3;
# 3,0 if $a != 0 jump 0
#
# output (((($a +& 7) +^ 5) +^ 6) +^ ($a +> (($a +& 7) +^ 5))) +& 7
# $a = $a div 2 ** 3;
# if $a != 0 jump 0
my $og = @program;
sub get-init($a, @program) {
    return $a unless @program;
    my $op = @program[0];
    my @offsets = (^8).grep({ run($a +< 3 + $_, 0, 0, $og, True)[0] == $op });
    return False unless @offsets;
    @offsets.map({get-init($a +< 3 + $_, @program[1..*])}).first(so *)
}
say get-init(0, @program.reverse);