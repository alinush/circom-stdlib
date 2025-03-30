pragma circom 2.1.7;

include "bitify.circom";

component main { public [bits] } = Bits2Num(
    32  // N
);
