/**
 * Author: Alin Tomescu
 */
pragma circom 2.2.2;

include "comparators/IsEqual.circom";
include "IndexSelector.circom";

/**
 * Returns a selector/mask that is 1 at [idx + 1, N) and zero everywhere else.
 * (Negation of PrefixSelector.)
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
 *    the first `idx` bits in `selector` are 0
 *    the bits after `idx` are all 1
 *
 * @examples
 *   SuffixSelector(4)(0)   --> 1111
 *   SuffixSelector(4)(1)   --> 0111
 *   SuffixSelector(4)(2)   --> 0011
 *   SuffixSelector(4)(3)   --> 0001
 *   SuffixSelector(4)(4)   --> 0000
 *   SuffixSelector(4)(idx) --> unsatisfiable, \forall idx > 4; plus, compile-time checks
 *     will prevent such a call
 *
 * @benchmarks
 *   SuffixSelector(N): 2*N + 4 constraints, 2*N + 5 vars
 *   SuffixSelector_10_no_tags.circom: 24 constraints, 25 vars
 *   SuffixSelector_20_no_tags.circom: 44 constraints, 45 vars
 */
template SuffixSelector(N) {
    signal input {maxvalue} idx;
    signal output {binary} selector[N];

    // Note: we allow idx == N
    assert(idx.maxvalue <= N);

    // Will be 0 everywhere except at idx, when idx < N
    signal idxSelector[N];
    
    // We use custom index selection logic here, since we want to allow for idx == N
    signal success;
    var sum = 0;
    for (var i = 0; i < N; i++) {
        idxSelector[i] <-- (idx == i) ? 1 : 0;
        // C1: Enforces that idxSelector[i] == 0, \forall i != idx
        idxSelector[i] * (idx - i) === 0;
        sum += idxSelector[i];
    }
    success <== sum;

    // If idx == N, we require that idxSelector[i] == 0, \forall i.
    //
    // Otherwise, if idx != N (<=> if idx < N, b.c. of the {maxvalue} tag), we
    //   require that idxSelector[idx] == 1.
    signal idxIsN <== IsEqual()(idx, N);
    success === 1 - idxIsN;

    selector[0] <== idxSelector[0];
    for(var i = 1; i < N; i++) {
        selector[i] <== selector[i - 1] + idxSelector[i];
    }
}