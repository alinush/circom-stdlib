pragma circom 2.2.2;

include "bitify.circom";
include "__lib/wrappers.circom";

component main { public [maybe_bits] } = Bits2Num_wrapper(
     // Testing the BN254 limits here: this should NOT work, because some 254-bit numbers
     // are not representable as a BN254 scalar.
    254
);