pragma circom 2.2.2;

include "bits/Bits2Num.circom";
include "bits/ToBinary.circom";

template Bits2Num_tagger(N) {
    signal input maybe_bits[N];

    signal {binary} bits[N];
    for(var i = 0; i < N; i++) {
        bits[i] <== ToBinary()(maybe_bits[i]);
    }

    signal output {maxbits} num <== Bits2Num(N)(bits);
    assert(num.maxbits == N);
} 