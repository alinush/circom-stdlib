pragma circom 2.2.2;

include "bits/ToMaxBits.circom";
include "bits/AssertHasBinaryTag.circom";
include "comparators/LessEqThan.circom";

template LessEqThan_Tagger(N) {
    signal input lhs, rhs;

    signal lhs_tagged <== ToMaxBits(N)(lhs);
    signal rhs_tagged <== ToMaxBits(N)(rhs);

    signal output out <== LessEqThan()(lhs_tagged, rhs_tagged);
    
    AssertHasBinaryTag()(out);
}