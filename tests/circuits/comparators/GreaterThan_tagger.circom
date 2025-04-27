pragma circom 2.2.2;

include "bits/EnforceMaxBits.circom";
include "bits/IsBinaryTagged.circom";
include "comparators/GreaterThan.circom";

template GreaterThan_tagger(N) {
    signal input lhs_unbound, rhs_unbound;

    signal lhs <== EnforceMaxBits(N)(lhs_unbound);
    signal rhs <== EnforceMaxBits(N)(rhs_unbound);

    signal output out <== GreaterThan()(lhs, rhs);
    
    IsBinaryTagged()(out);
}