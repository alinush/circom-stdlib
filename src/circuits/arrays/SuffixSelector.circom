/**
 * Author: Alin Tomescu
 */
pragma circom 2.2.2;

include "IndexSelectorUnsafe.circom";

// Returns a selector/mask that is 1 at [idx + 1, N) and zero everywhere else.
// (Negation of PrefixSelector.)
//
// @param  N        the array size
//
// @input  idx      the index in the array s.t. 0 <= idx <= N
//
// @output selector the selector mask
//
// @examples
//   SuffixSelector(4)(0) --> 1111
//   SuffixSelector(4)(1) --> 0111
//   SuffixSelector(4)(2) --> 0011
//   SuffixSelector(4)(3) --> 0001
//   SuffixSelector(4)(4) --> 0000
//   SuffixSelector(4)(idx) is not satisifiable when idx > N
template SuffixSelector(N) {
    signal input {maxvalue} idx;
    signal output {binary} selector[N];

    // Note: we allow idx = N
    assert(idx.maxvalue <= N);

    signal idxSelector[N] <== IndexSelectorUnsafe(N)(idx);

    selector[0] <== idxSelector[0];
    for(var i = 1; i < N; i++) {
        selector[i] <== selector[i - 1] + idxSelector[i];
    }
}