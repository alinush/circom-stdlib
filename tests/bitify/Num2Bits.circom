pragma circom 2.2.2;

include "bitify.circom";

component main { public [num] } = Num2Bits(
    253  // N
);