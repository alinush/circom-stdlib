/**
 * Author: Alin Tomescu
 */
pragma circom 2.2.2;

/**
 * Returns the max between a and b, but NOT when viewed as numbers in [0, p).
 *
 * Recall circom's weird comparisons: http://alinush.org/circom#comparison-operators-----on-vars
 */
function max_signed(a, b) {
    return a > b ? a : b;
}
