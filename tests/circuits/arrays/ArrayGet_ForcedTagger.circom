pragma circom 2.2.2;

include "arrays/ArrayGet.circom";

template ArrayGet_ForcedTagger(N) {
    signal input arr[N];
    signal input idx;

    signal {maxvalue} idx_tagged;
    idx_tagged.maxvalue = N-1;
    idx_tagged <== idx;

    assert(idx_tagged.maxvalue == N - 1);

    signal output out <== ArrayGet(N)(arr, idx_tagged);
}