pragma circom 2.2.2;

include "bitify.circom";
include "__lib/wrappers.circom";

component main { public [maybe_bits] } = Bits2Num_wrapper(
    // THE BLS12-381 curve order is a 255-bit prime; so only 254-bit numbers
    // or smaller can be fully represented in its scalar field
    254
);