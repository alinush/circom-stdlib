pragma circom 2.2.2;

include "arrays/ArrayGet.circom";

template ArrayGet_tagger(N, MAX) {
    signal input arr[N];
    signal input idx_raw;

    signal {maxvalue} idx;
    idx.maxvalue = MAX;
    idx <== idx_raw;

    signal output out <== ArrayGet(N)(arr, idx);
}