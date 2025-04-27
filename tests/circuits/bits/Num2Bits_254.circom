pragma circom 2.2.2;

include "bits/Num2Bits.circom";

component main { public [num] } = Num2Bits(
    // THE BLS12-381 curve order is a 255-bit prime; so only 254-bit numbers
    // or smaller can be fully represented in its scalar field
    254
);