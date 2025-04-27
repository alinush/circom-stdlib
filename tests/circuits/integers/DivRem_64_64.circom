pragma circom 2.1.7;

include "integers/DivRem.circom";

template DivRem_wrapper_64_64() {
    signal input a, b;

    signal {maxbits} a_m;
    signal {nonzero, maxbits} b_m;

    a_m.maxbits = 64;
    a_m <== a;

    b_m.maxbits = 64;
    b_m <== b;

    signal output (q, r) <== DivRem()(a_m, b_m);
}

component main { public [a, b] } = DivRem_wrapper_64_64();
