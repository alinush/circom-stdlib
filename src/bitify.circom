/**
 * Trimmed-down, linted and commented version from standard circomlib.
 *
 * Author: Alin Tomescu (tomescu.alin@gmail.com)
 */

pragma circom 2.1.7;

/**
 * Outputs the number that has the given N-bit representation.
 *
 * Parameters:
 *   N      the bit representation is N-bit
 *
 * Input signals:
 *   bits   an array bits[N-1], ..., bits[0] of bits with bits[N-1] being the
 *          most significant bit
 *
 * Output signals:
 *   num    the number in [0, 2^N) with the given binary representation
 */
template Bits2Num(N) {
    signal input bits[N];

    // incrementally-updated to eventually store the symbolic expression:
    //
    //   bits[0] * 1 + bits[1] * 2 + bits[2] * 2^2 + ... + bits[N-1] * (2^(N-1))
    //
    var acc;

    // stores increasing powers of two: 2^0, 2^1, 2^2, ...
    var pow2 = 1;
    for (var i = 0; i < N; i++) {
        // appends `+ bits[i] * 2^i` as a term to the symbolic expression in
        // `acc`, setting it to \prod_{i = 0}^{N-1} bits[i] * 2^{i+1}
        acc += bits[i] * pow2;

        // set to 2^{i+1}
        pow2 = pow2 + pow2;
    }

    signal output num <== acc;
}

/* original
template Bits2Num(n) {
    signal input in[n];
    signal output out;
    var lc1=0;

    var e2 = 1;
    for (var i = 0; i<n; i++) {
        lc1 += in[i] * e2;
        e2 = e2 + e2;
    }

    lc1 ==> out;
}*/


/**
 * Outputs an array of bits containing the N-bit representation of the input number.
 *
 * Parameters:
 *   N      the number MUST be in [0, 2^N) for correctness
 *          soundness is unconditional (i.e, numbers > 2^N cannot satisfy this template)
 *
 * Input signals:
 *   num    the number to be converted to binary
 *
 * Output signals:
 *   bits   an array bits[N-1], ..., bits[0] of the N bits representing `num`, with
 *          bits[N-1] being the most significant bit
 */
template Num2Bits(N) {
    signal input num;
    signal output bits[N];

    // incrementally-updated to eventually store the symbolic expression:
    //
    //   bits[0] * 1 + bits[1] * 2 + bits[2] * 2^2 + ... + bits[N-1] * (2^(N-1))
    //
    var acc = 0;

    // stores increasing powers of two: 2^0, 2^1, 2^2, ...
    var pow2 = 1;

    for (var i = 0; i < N; i++) {
        bits[i] <-- (num >> i) & 1;    // extracts `num`'s ith bit
        bits[i] * (bits[i] - 1) === 0; // constrains bits[i] to be a bit

        // appends `+ bits[i] * 2^i` as a term to the symbolic expression in
        // `acc`, setting it to \prod_{i = 0}^{N-1} bits[i] * 2^{i+1}
        acc += bits[i] * pow2;

        // set to 2^{i+1}
        pow2 = pow2 + pow2;
    }

    // since acc stores the symbolic expression from above, this constrains
    // that the `bits` are indeed the binary representation of `num`
    num === acc;
}

/* original
template Num2Bits(n) {
    signal input in;
    signal output out[n];
    var lc1=0;

    var e2=1;
    for (var i = 0; i<n; i++) {
        out[i] <-- (in >> i) & 1;
        out[i] * (out[i] -1 ) === 0;
        lc1 += out[i] * e2;
        e2 = e2+e2;
    }

    lc1 === in;
}*/
