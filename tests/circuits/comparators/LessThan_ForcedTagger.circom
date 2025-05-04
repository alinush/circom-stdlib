
pragma circom 2.2.2;

include "bits/AssertHasBinaryTag.circom";
include "comparators/LessThan.circom";

template LessThan_ForcedTagger(N) {
    signal input lhs, rhs;

    signal {maxbits} lhs_tagged;
    lhs_tagged.maxbits = N;
    lhs_tagged <== lhs;

    signal {maxbits} rhs_tagged;
    rhs_tagged.maxbits = N;
    rhs_tagged <== rhs;

    signal output out <== LessThan()(lhs_tagged, rhs_tagged);
    
    AssertHasBinaryTag()(out);
}