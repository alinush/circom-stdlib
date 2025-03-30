/**
 * Some templates expect their input signals to be tagged. These wrappers apply (dummy)
 * tags before calling such templates.
 */
pragma circom 2.2.2;

include "bitify.circom";
include "comparators.circom";
include "integers.circom";

template Bits2Num_wrapper(N) {
    signal input maybe_bits[N];

    signal {binary} bits[N];
    for(var i = 0; i < N; i++) {
        bits[i] <== EnforceBinary()(maybe_bits[i]);
    }

    signal output {maxbits} num;
    num.maxbits = N;

    num <== Bits2Num(N)(bits);
    assert(num.maxbits == N);
}

template LessThan_wrapper() {
    signal input lhs, rhs;
    
    signal {maxbits} lhs_m, rhs_m;

    lhs_m.maxbits = 7;
    lhs_m <== lhs;
    
    rhs_m.maxbits = 7;
    rhs_m <== rhs;
    
    signal output out <== LessThan()(lhs_m, rhs_m);
}

template LessEqThan_wrapper() {
    signal input lhs, rhs;
    
    signal {maxbits} lhs_m, rhs_m;

    lhs_m.maxbits = 64;
    lhs_m <== lhs;
    
    rhs_m.maxbits = 32;
    rhs_m <== rhs;
    
    signal output out <== LessEqThan()(lhs_m, rhs_m);
}

template GreaterThan_wrapper() {
    signal input lhs, rhs;
    
    signal {maxbits} lhs_m, rhs_m;
    lhs_m.maxbits = 32;
    lhs_m <== lhs;
    rhs_m.maxbits = 64;
    rhs_m <== rhs;
    
    signal output out <== GreaterThan()(lhs_m, rhs_m);
}

template DivRem_wrapper() {
    signal input a, b;

    signal {maxbits} a_m;
    signal {nonzero, maxbits} b_m;

    a_m.maxbits = 64;
    a_m <== a;

    b_m.maxbits = 64;
    b_m <== b;

    signal output (q, r) <== DivRem()(a_m, b_m);
}