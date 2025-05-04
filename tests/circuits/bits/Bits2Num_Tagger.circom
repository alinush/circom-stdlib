pragma circom 2.2.2;

include "bits/Bits2Num.circom";
include "bits/ToBinary.circom";

template Bits2Num_Tagger(N) {
    signal input bits[N];
    
    for(var i = 0; i < N; i++) {
        bits[i] * (bits[i] - 1) === 0;
    }

    signal {binary} bits_tagged[N] <== bits;

    signal output {maxbits} num <== Bits2Num(N)(bits_tagged);
    assert(num.maxbits == N);
} 