/**
 * Author: Alin Tomescu
 */
pragma circom 2.2.2;

include "SuffixSelector.circom";

/**
 * Returns a selector/mask that is 1 at [0, idx) and zero everywhere else.
 * (Negation of SuffixSelector.)
 *
 * @param  N                     the array size
 *
 * @input  idx {maxvalue}        the index in the array s.t. 0 <= idx <= N
 *
 * @output selector[N] {binary}  the selector mask
 *
 * @preconditions
 *    idx <= N  (via idx.maxvalue <= N)
 *    (Note: different than in IndexSelector, where idx < N)
 *
 * @postconditions
 *    the first `idx` bits in `selector` are 1
 *    the bits after `idx` are all zeros
 *
 * @examples
 *   PrefixSelector(4)(0) --> 0000
 *   PrefixSelector(4)(1) --> 1000
 *   PrefixSelector(4)(2) --> 1100
 *   PrefixSelector(4)(3) --> 1110
 *   PrefixSelector(4)(4) --> 1111
 *   PrefixSelector(4)(idx) --> unsatisfiable, \forall idx > 4; plus, compile-time checks
 *     will prevent such a call
 */
template PrefixSelector(N) {
    signal input {maxvalue} idx;
    signal output {binary} selector[N];

    // Note: we allow idx = N
    assert(idx.maxvalue <= N);

    // TODO: Do better than inverting the suffix mask
    // (benchmarked this and it adds another N variables and N constraints)
    signal suffixSelector[N] <== SuffixSelector(N)(idx);
    for(var i = 0; i < N; i++) {
        selector[i] <== 1 - suffixSelector[i];
    }
}