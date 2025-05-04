pragma circom 2.2.2;

include "Bits2Num_Tagger.circom";

component main { public [bits] } = Bits2Num_Tagger(
    // This will fit in a BN254 scalar
    253
);