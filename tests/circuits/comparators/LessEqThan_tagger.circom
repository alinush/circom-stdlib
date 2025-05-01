pragma circom 2.2.2;

include "bits/ToMaxBits.circom";
include "bits/AssertHasBinaryTag.circom";
include "comparators/LessEqThan.circom";

template LessEqThan_tagger(N) {
    signal input lhs_unbound, rhs_unbound;

    signal lhs <== ToMaxBits(N)(lhs_unbound);
    signal rhs <== ToMaxBits(N)(rhs_unbound);

    signal output out <== LessEqThan()(lhs, rhs);
    
    AssertHasBinaryTag()(out);
}