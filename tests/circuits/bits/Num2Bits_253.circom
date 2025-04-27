pragma circom 2.2.2;

include "bits/Num2Bits.circom";

component main { public [num] } = Num2Bits(
    // This will fit in a BN254 scalar
    253
);