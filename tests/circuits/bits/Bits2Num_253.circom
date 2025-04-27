pragma circom 2.2.2;

include "Bits2Num_tagger.circom";

component main { public [maybe_bits] } = Bits2Num_tagger(
    // This will fit in a BN254 scalar
    253
);