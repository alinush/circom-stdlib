/**
 * Author: Alin Tomescu
 */
pragma circom 2.2.2;

/**
 * Returns a "V-hot" selector/mask that is V at idx and zero everywhere else.
 *
 * @param  N                     the array size
 * @param  V                     the value of selector[idx]
 *
 * @input  idx {maxvalue}        the index in the array
 *
 * @output selector[N] {binary}  the selector mask
 *
 * @preconditions
 *    idx < N  (via idx.maxvalue < N)
 *
 * @postconditions
 *    all locations in the selector output are zero except for location `idx`,
 *    which will be set to V
 *
 * @examples
 *   IndexSelector(4)(0)   --> V000
 *   IndexSelector(4)(1)   --> 0V00
 *   IndexSelector(4)(2)   --> 00V0
 *   IndexSelector(4)(3)   --> 000V
 *   IndexSelector(4)(idx) --> unsatisifiable when V > 0, \forall idx >= 4
 *
 * @notes
 *   when V > 0, unsatisfiable for idx >= N because C1 enforces selector[i] == 0,
 *   \forall i \in [0, N), while C2 requires their sum equals V > 0
 */
template IndexSelectorInternal(N, V) {
    signal input {maxvalue} idx;
    signal output {binary} selector[N];
    signal success;

    assert(idx.maxvalue < N);

    var sum = 0;
    for (var i = 0; i < N; i++) {
        selector[i] <-- (idx == i) ? V : 0;
        // C1: Enforces that selector[i] == 0, \forall i != idx
        selector[i] * (idx - i) === 0;
        sum += selector[i];
    }
    success <== sum;

    // C2: Enforces that selector[idx] == V when idx \in [0, N). Otherwise, there is
    // no selector[idx] to speak of.
    // Note: Without this check, *any* value could be plugged in for selector[idx].
    success === V;
}