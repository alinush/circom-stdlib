pragma circom 2.2.2;

include "arrays/SuffixSelector.circom";

template SuffixSelector_ForcedTagger(N) {
    signal input idx;

    signal {maxvalue} idx_tagged;
    idx_tagged.maxvalue = N;
    idx_tagged <== idx;

    assert(idx_tagged.maxvalue == N);

    signal output selector[N] <== SuffixSelector(N)(idx_tagged);
}