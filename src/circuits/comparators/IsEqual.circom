/**
 * Author: Alin Tomescu
 */
pragma circom 2.2.2;

include "IsZero.circom";

/**
 * Outputs a truth bit for whether lhs == rhs.
 *
 * @input lhs           the left-hand side input
 * @input rhs           the right-hand side input
 *
 * @input out {binary}  a bit indicating whether lhs == rhs
 */
template IsEqual() {
    signal input lhs;
    signal input rhs;

    signal output {binary} out <== IsZero()(lhs - rhs);
}