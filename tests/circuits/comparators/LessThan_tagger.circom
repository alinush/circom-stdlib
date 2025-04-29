pragma circom 2.2.2;

include "bits/EnforceMaxBits.circom";
include "bits/IsBinaryTagged.circom";
include "comparators/LessThan.circom";

template LessThan_tagger(N) {
    signal input lhs, rhs;

    signal lhs_tagged <== EnforceMaxBits(N)(lhs);
    signal rhs_tagged <== EnforceMaxBits(N)(rhs);

    signal output out <== LessThan()(lhs_tagged, rhs_tagged);
    
    IsBinaryTagged()(out);
}