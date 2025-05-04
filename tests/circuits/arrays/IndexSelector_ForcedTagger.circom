pragma circom 2.2.2;

include "arrays/IndexSelector.circom";

template IndexSelector_ForcedTagger(N) {
    signal input idx;

    signal {maxvalue} idx_tagged;
    idx_tagged.maxvalue = N - 1;
    idx_tagged <== idx;

    assert(idx_tagged.maxvalue == N - 1);

    signal output selector[N] <== IndexSelector(N)(idx_tagged);
}