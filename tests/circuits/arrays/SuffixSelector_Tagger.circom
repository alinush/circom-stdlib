pragma circom 2.2.2;

include "arrays/SuffixSelector.circom";
include "comparators/ToLessThanConstant.circom";

template SuffixSelector_Tagger(N) {
    signal input idx;

    signal {maxvalue} idx_tagged;
    idx_tagged <== ToLessThanConstant(N+1)(idx);

    assert(idx_tagged.maxvalue == N);

    signal output selector[N] <== SuffixSelector(N)(idx_tagged);
}