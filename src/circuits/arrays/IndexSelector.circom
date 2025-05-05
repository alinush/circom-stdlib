/**
 * Author: Alin Tomescu
 */
pragma circom 2.2.2;

// TODO: Add more
//   IndexSelectorNegated
//   SliceSelector
include "internal/IndexSelectorInternal.circom";

/**
 * Returns a "one-hot" selector/mask that is 1 at idx and zero everywhere else.
 *
 * @param  N                     the array size
 *
 * @input  idx {maxvalue}        the index in the array
 *
 * @output selector[N] {binary}  the selector mask
 *
 * @preconditions
 *    idx < N  (via idx.maxvalue < N)
 *
 * @postconditions
 *    all bits in the output are zero except for the bit at location `idx`
 *    (note: there will be exactly one 1-bit)
 *
 * @examples
 *   IndexSelector(4)(0)   --> 1000
 *   IndexSelector(4)(1)   --> 0100
 *   IndexSelector(4)(2)   --> 0010
 *   IndexSelector(4)(3)   --> 0001
 *   IndexSelector(4)(idx) --> unsatisifiable, \forall idx >= 4
 *
 * @benchmarks
 *   IndexSelector(N): N + 1 constraints, N + 2 vars
 *   IndexSelector_10_no_tags.circom: 11 constraints, 12 vars
 *   IndexSelector_20_no_tags.circom: 21 constraints, 22 vars
 *
 * @notes
 *   unsatisfiable for idx >= N because IndexSelectorInternal enforces
*    selector[i] == 0, \forall i \in [0, N), but also requires their sum be equal to 1
 */
template IndexSelector(N) {
    signal input {maxvalue} idx;

    assert(idx.maxvalue < N);

    signal output {binary} selector[N] <== IndexSelectorInternal(N, 1)(idx);
}