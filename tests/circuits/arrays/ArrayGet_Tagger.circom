pragma circom 2.2.2;

include "arrays/ArrayGet.circom";
include "comparators/ToLessThanConstant.circom";

template ArrayGet_Tagger(N) {
    signal input arr[N];
    signal input idx;

    signal {maxvalue} idx_tagged <== ToLessThanConstant(N)(idx);
    assert(idx_tagged.maxvalue == N - 1);

    signal output out <== ArrayGet(N)(arr, idx_tagged);
}