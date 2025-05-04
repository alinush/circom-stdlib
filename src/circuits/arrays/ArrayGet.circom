/**
 * Author: Alin Tomescu
 */
pragma circom 2.2.2;

include "IndexSelector.circom";
include "DotProduct.circom";
include "../comparators/IsZero.circom";

// @benchmarks
//    ArrayGet_100.circom: 502 vars, 400 constraints
// template ArrayGet(len) {
//     assert(len > 0);
//
//     signal input arr[len];
//     signal input i;
//
//     signal mask[len];
//     signal prods[len];
//
//     for (var j = 0; j < len; j++) {
//         mask[j] <== IsZero()(i - j);
//         prods[j] <== arr[j] * mask[j];
//     }
//
//     var sum = 0;
//     for (var j = 0; j < len; j++) {
//         sum += prods[j];
//     }
//
//     signal output out <== sum;
// }


// Returns arr[idx] for a max-size MAX_LEN array where idx < MAX_LEN.
//
// @param   MAX_LEN  the maximum length of the array
//
// @input   idx {maxvalue}  the location to index into the array at and 
//                          fetch the element
//
// @input   arr[MAX_LEN]    the array to fetch from
//
// @output  out             arr[idx]
//
// @preconditions
//      idx < MAX_LEN
//
// @benchmarks
//   ArrayGet(MAX_LEN): 3*MAX_LEN + 3 vars, 2*MAX_LEN + 2 constraints
//   ArrayGet_100.circom: 303 vars, 202 constraints
//   ArrayGet_200.circom: 603 vars, 402 constraints
template ArrayGet(MAX_LEN) {
    signal input arr[MAX_LEN];
    signal input {maxvalue} idx;

    assert(MAX_LEN > 0);
    assert(idx.maxvalue < MAX_LEN);

    signal mask[MAX_LEN] <== IndexSelector(MAX_LEN)(idx);

    signal output out <== DotProduct(MAX_LEN)(arr, mask);
}