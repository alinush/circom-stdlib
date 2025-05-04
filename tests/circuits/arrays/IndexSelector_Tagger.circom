pragma circom 2.2.2;

include "arrays/IndexSelector.circom";
include "comparators/ToLessThanConstant.circom";

template IndexSelector_Tagger(N) {
    signal input idx;

    signal {maxvalue} idx_tagged <== ToLessThanConstant(N)(idx);
    assert(idx_tagged.maxvalue == N - 1);

    signal output selector[N] <== IndexSelector(N)(idx_tagged);
}