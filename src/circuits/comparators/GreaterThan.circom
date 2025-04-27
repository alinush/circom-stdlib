pragma circom 2.2.2;

include "LessThan.circom";

/**
 * Like LessThan(), except for the `>` operator (not for `<`).
 */
template GreaterThan() {
    signal input {maxbits} lhs;
    signal input {maxbits} rhs;

    // Flip the argument order:
    // lhs > rhs <=> LessThan()(rhs, lhs)
    signal output {binary} out <== LessThan()(rhs, lhs);
}