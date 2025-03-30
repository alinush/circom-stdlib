pragma circom 2.2.2;

/**
 * Returns the max between a and b, but NOT when viewed as numbers in [0, p).
 *
 * Recall circom's weird comparisons: http://alinush.org/circom#comparison-operators-----on-vars
 */
function max_signed(a, b) {
    return a > b ? a : b;
}

/**
 * Computes the maximum bit-width $b$ such that an *unsigned* $2^b - 1$ value can
 * be always stored in a circom scalar in $\mathbb{Z}_p$, without it wrapping around
 * after being reduced modulo $p$.
 *
 * Leverages the fact that circom comparison operators treat scalars in $[0, p/2]$
 * as positive, while every $v \in (p/2, p)$ is treated as negative (i.e., as 
 * $v - p$ instead of as $v$).
 */
function MAX_BITS() {
    var n = 1;
    var b = 1;

    while (2 * n > n) {
        n = n * 2;
        b = b + 1;
    }

    return b;
}

/**
 * Utility method used to make sure an N-bit *unsigned* number will fit in a scalar, * for the curently-selected circom scalar field.
 */
function assert_bits_fit_scalar(N) {
    var max_bits = MAX_BITS();
    log("N: ", N);
    log("MAX_BITS(): ", max_bits);

    assert(N <= max_bits);

    return 0;   // circom needs you to return!
}

/**
 * Given a natural number n > 0, returns \floor{\log_2{n}}.
 *
 * Arguments:
 *   n  non-zero, natural number 
 *      (presumed not to have been >= p and thus not to have been wrapped around)
 *
 * Returns:
 *   \floor{\log_2{n}}
 *
 * Examples:
 *   n = 0                     --> undefined
 *   n = 1                     --> 0
 *   n = 2,3                   --> 1
 *   n = 4,5,6,7               --> 2
 *   n = 8,9,10,11,12,13,14,15 --> 3
 */
function log2_floor(n) {
	assert(n != 0);

    var log2 = 0;

    // WARNING: Do not use <, >, <=, >= comparison operators here or you will
    // suffer from circom's signed numbers semantics!
    while (n != 1) {
        log2 += 1;
        n \= 2;
    }

    return log2;
}

/**
 * Returns the minimum # of bits needed to represent n.
 * 
 * Note: Representing 0 is assumed to be done via 1 (zero) bit.
 *
 * Examples:
 *   n = 0                --> 1
 *   n = 1                --> 1
 *   n = 2,3              --> 2
 *   n = 4,5,6,7          --> 3
 *   n \in [2^k, 2^{k+1}) --> k + 1
 */
function min_num_bits(n) {
    if(n == 0) {
        return 1;
    }

    return log2_floor(n) + 1;
}