/**
 * Author: Alin Tomescu
 */
pragma circom 2.2.2;

// Returns a selector/mask that is 1 at [0, idx) and zero everywhere else.
// (Negation of SuffixSelector.)
//
// @param  N        the array size
//
// @input  idx      the index in the array s.t. 0 <= idx <= N
//
// @output selector the selector mask
//
// @examples
//   PrefixSelector(4)(0) --> 0000
//   PrefixSelector(4)(1) --> 1000
//   PrefixSelector(4)(2) --> 1100
//   PrefixSelector(4)(3) --> 1110
//   PrefixSelector(4)(4) --> 1111
//   PrefixSelector(4)(idx) --> 1111, \forall idx > 4, but compile-time checks
//     will prevent such a call
template PrefixSelector(N) {
    signal input {maxvalue} idx;
    signal output {binary} selector[N];

    // Note: we allow idx = N
    assert(idx.maxvalue <= N);

    // TODO: Do better than inverting the suffix mask (or benchmark constraints)
    signal suffixSelector <== SuffixSelector(N)(idx);
    for(var i = 0; i < N; i++) {
        selector[i] <== 1 - suffixSelector[i];
    }
}