pragma circom 2.2.2;

include "bits/ToMaxBits.circom";
include "bits/AssertHasBinaryTag.circom";
include "comparators/GreaterThan.circom";

template GreaterThan_Tagger(N) {
    signal input lhs, rhs;

    signal lhs_tagged <== ToMaxBits(N)(lhs);
    signal rhs_tagged <== ToMaxBits(N)(rhs);

    signal output out <== GreaterThan()(lhs_tagged, rhs_tagged);
    
    AssertHasBinaryTag()(out);
}