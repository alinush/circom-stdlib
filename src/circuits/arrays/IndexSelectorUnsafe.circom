/**
 * Author: Alin Tomescu
 */
pragma circom 2.2.2;

// Returns a "one-hot" selector/mask that is 1 at idx and zero everywhere else.
// Marked as "unsafe" because it accepts idx >= N, in which case it returns all zeros.
//
// @param  N        the array size
//
// @input  idx      the index in the array
//
// @output selector the selector mask
//
// @examples
//   IndexSelector(4)(0)   --> 1000
//   IndexSelector(4)(1)   --> 0100
//   IndexSelector(4)(2)   --> 0010
//   IndexSelector(4)(3)   --> 0001
//   IndexSelector(4)(idx) --> 0000 when idx >= N
template IndexSelectorUnsafe(N) {
    signal input idx;
    signal output {binary} selector[N];

    signal success;
    var sum = 0;

    for (var i = 0; i < N; i++) {
        selector[i] <-- (idx == i) ? 1 : 0;
        // Enforces that either: selector[i] == 0, or idx == i
        selector[i] * (idx - i) === 0;
        sum += selector[i];
    }
    success <== sum;

    // Enforces that only one selector[i] location was 1, assuming idx \in [0, N)
    success === 1;
}