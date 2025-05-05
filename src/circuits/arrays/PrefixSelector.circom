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
 * 
 * @notes
 *   unsatisfiable for idx > 4 because C1 enforces idxSelectorNeg[i] == 0, \forall i
 *   \in [0, N) while C2 will try to enforce their sum be equal to -1 (note that 
 *   idxIsN will be 0)
 */
template PrefixSelector(N) {
    signal input {maxvalue} idx;
    signal output {binary} selector[N];

    // Note: we allow idx == N
    assert(idx.maxvalue <= N);

    // Will be 0 everywhere except at idx, where it will be -1, when idx < N
    signal idxSelectorNeg[N];

    // We use custom index selection logic here, since we want to allow for idx == N
    signal success;
    var sum = 0;
    for (var i = 0; i < N; i++) {
        idxSelectorNeg[i] <-- (idx == i) ? -1 : 0;
        // C1: Enforces that idxSelectorNeg[i] == 0, \forall i != idx
        idxSelectorNeg[i] * (idx - i) === 0;
        sum += idxSelectorNeg[i];
    }
    success <== sum;

    // If idx == N, we require that idxSelectorNeg[i] == 0, \forall i.
    //
    // Otherwise, if idx != N (<=> if idx < N, b.c. of the {maxvalue} tag), we
    //   require that idxSelectorNeg[idx] == -1.
    signal idxIsN <== IsEqual()(idx, N);
    success === -1 + idxIsN;

    selector[0] <== 1 + idxSelectorNeg[0];
    for(var i = 1; i < N; i++) {
        selector[i] <== selector[i - 1] + idxSelectorNeg[i];
    }
}