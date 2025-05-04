pragma circom 2.2.2;

include "LessEqThan_Tagger.circom";

component main { public [lhs, rhs] } = LessEqThan_Tagger(
    2
);