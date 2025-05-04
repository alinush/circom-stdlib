pragma circom 2.2.2;

include "LessThan_ForcedTagger.circom";

component main { public [lhs, rhs] } = LessThan_ForcedTagger(
    32
);