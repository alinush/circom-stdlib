/**
 * Author: Alin Tomescu
 */
pragma circom 2.2.2;

include "IndexSelectorUnsafe.circom";

// TODO: Add more
//   IndexSelectorNegated
//   SliceSelector

// Returns a "one-hot" selector/mask that is 1 at idx and zero everywhere else.
//
// @param  N                  the array size
//
// @input  idx {maxvalue}     the index in the array s.t. idx < N
//
// @output selector {binary}  the selector mask
//
// @preconditions
//    idx < N
// @postconditions
//    all bits in the output are zero except for the bit at location `idx`
//
// @examples
//   IndexSelector(4)(0) --> 1000
//   IndexSelector(4)(1) --> 0100
//   IndexSelector(4)(2) --> 0010
//   IndexSelector(4)(3) --> 0001
//   IndexSelector(4)(idx) is not satisifiable when idx >= N
template IndexSelector(N) {
    signal input {maxvalue} idx;
    signal output selector[N];

    assert(idx.maxvalue < N);

    selector <== IndexSelectorUnsafe(N)(idx);
}