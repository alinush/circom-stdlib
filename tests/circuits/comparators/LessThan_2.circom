pragma circom 2.2.2;

include "LessThan_tagger.circom";

template LessThan_forced_tagger(N) {
    signal input lhs, rhs;

    signal {maxbits} lhs_tagged;
    lhs_tagged.maxbits = 2;
    lhs_tagged <== lhs;

    signal {maxbits} rhs_tagged;
    rhs_tagged.maxbits = 2;
    rhs_tagged <== rhs;

    signal output out <== LessThan()(lhs_tagged, rhs_tagged);
    
    IsBinaryTagged()(out);
}

component main { public [lhs, rhs] } = LessThan_forced_tagger(
    2
);