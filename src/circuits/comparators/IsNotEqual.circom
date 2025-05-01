/**
 * Author: Alin Tomescu
 */
pragma circom 2.2.2;

include "IsNonZero.circom";

/**
 * Outputs a truth bit for whether lhs != rhs.
 *
 * @input lhs           the left-hand side input
 * @input rhs           the right-hand side input
 *
 * @input out {binary}  a bit indicating whether lhs != rhs
 */
template IsNotEqual () {
    signal input lhs;
    signal input rhs;

    signal output {binary} out <== IsNonZero()(lhs - rhs);
}