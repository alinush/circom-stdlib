/**
 * Author: Alin Tomescu
 */
pragma circom 2.2.2;

include "GreaterThan.circom";
include "../gates/NOT.circom";

/**
 * Like LessThan(), except for the `<=` operator (not for `<`).
 *
 * TODO(Perf): Consider adopting the +1 trick from circomlib after understanding
 * its soundness better.
 */
template LessEqThan() {
    signal input {maxbits} lhs;
    signal input {maxbits} rhs;

    // is_gt = (lhs > rhs)
    signal is_gt <== GreaterThan()(lhs, rhs);

    // returns !(lhs > rhs)
    // so, returns lhs <= rhs
    signal output {binary} out <== NOT()(is_gt);
}