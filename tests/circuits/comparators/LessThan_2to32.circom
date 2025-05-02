pragma circom 2.2.2;

include "comparators/LessThan.circom";
include "bits/AssertHasBinaryTag.circom";

template LessThan_forced_tagger() {
    signal input lhs, rhs;

    signal {maxbits} lhs_tagged;
    lhs_tagged.maxbits = 32;
    lhs_tagged <== lhs;

    signal {maxbits} rhs_tagged;
    rhs_tagged.maxbits = 32;
    rhs_tagged <== rhs;

    signal output out <== LessThan()(lhs_tagged, rhs_tagged);
    
    AssertHasBinaryTag()(out);
}

component main { public [lhs, rhs] } = LessThan_forced_tagger(
);