pragma circom 2.2.2;

include "bits/EnforceMaxBits.circom";
include "bits/IsBinaryTagged.circom";
include "comparators/LessEqThan.circom";

template LessEqThan_tagger(N) {
    signal input lhs_unbound, rhs_unbound;

    signal lhs <== EnforceMaxBits(N)(lhs_unbound);
    signal rhs <== EnforceMaxBits(N)(rhs_unbound);

    signal output out <== LessEqThan()(lhs, rhs);
    
    IsBinaryTagged()(out);
}