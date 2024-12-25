# 🔔 🕯️ 👼 🍪 🥛 🧦 🧝‍♀️ 🧝 🧝‍♂️ 🌨️ ⭐ 🍰 🍬 🌠
my $input = "day25input.txt".IO.slurp;
my @keys-locks = $input.split("\n\n").map: {
    my @transpose = [Z] $_.lines>>.comb;
    (@transpose[0;0] eq "#", @transpose.map(*.grep(* eq "#").elems - 1).List);
};
say @keys-locks.combinations(2).grep(-> ($a, $b) {
    next if $a.head == $b.head;
    ($a[1] Z+ $b[1]).all < 6;
}).elems;