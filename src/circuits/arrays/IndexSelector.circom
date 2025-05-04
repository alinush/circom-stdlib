/**
 * Author: Alin Tomescu
 */
pragma circom 2.2.2;

// TODO: Add more
//   IndexSelectorNegated
//   SliceSelector

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
 */
template IndexSelector(N) {
    signal input {maxvalue} idx;
    signal output {binary} selector[N];
    signal success;

    assert(idx.maxvalue < N);

    var sum = 0;
    for (var i = 0; i < N; i++) {
        selector[i] <-- (idx == i) ? 1 : 0;
        // C1: Enforces that selector[i] == 0, \forall i != idx
        selector[i] * (idx - i) === 0;
        sum += selector[i];
    }
    success <== sum;

    // C2: Enforces that selector[idx] == 1 when idx \in [0, N). Otherwise, there is
    // no selector[idx] to speak of.
    // Note: Without this check, *any* value could be plugged in for selector[idx].
    success === 1;
}