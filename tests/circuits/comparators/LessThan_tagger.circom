pragma circom 2.2.2;

include "bits/EnforceMaxBits.circom";
include "bits/IsBinaryTagged.circom";
include "comparators/LessThan.circom";

template LessThan_tagger(N) {
    signal input lhs_unbound, rhs_unbound;

    signal lhs <== EnforceMaxBits(N)(lhs_unbound);
    signal rhs <== EnforceMaxBits(N)(rhs_unbound);

    signal output out <== LessThan()(lhs, rhs);
    
    IsBinaryTagged()(out);
}