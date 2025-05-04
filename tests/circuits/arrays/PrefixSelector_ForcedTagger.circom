pragma circom 2.2.2;

include "arrays/PrefixSelector.circom";

template PrefixSelector_ForcedTagger(N) {
    signal input idx;

    signal {maxvalue} idx_tagged;
    idx_tagged.maxvalue = N;
    idx_tagged <== idx;

    assert(idx_tagged.maxvalue == N);

    signal output selector[N] <== PrefixSelector(N)(idx_tagged);
}