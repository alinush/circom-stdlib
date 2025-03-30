pragma circom 2.2.2;

include "__lib/wrappers.circom";

component main { public [maybe_bits] } = Bits2Num_wrapper(
    // THE BN254 curve order is a 254-bit prime; so only 253-bit numbers
    // or smaller can be fully represented in its scalar field
    253
);