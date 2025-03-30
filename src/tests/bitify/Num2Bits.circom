pragma circom 2.1.7;

include "bitify.circom";

component main { public [num] } = Num2Bits(
    32  // N
);
