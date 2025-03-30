pragma circom 2.2.2;

include "bitify.circom";
include "__lib/wrappers.circom";

component main { public [maybe_bits] } = Bits2Num_wrapper(
     // Testing the BLS12-381 limits here: this should NOT work, because some 255-bit numbers
     // are not representable as a BLS12-381 scalar.
    255
);
