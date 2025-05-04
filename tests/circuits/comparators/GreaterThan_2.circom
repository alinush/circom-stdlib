pragma circom 2.2.2;

include "GreaterThan_Tagger.circom";

component main { public [lhs, rhs] } = GreaterThan_Tagger(
    2
);