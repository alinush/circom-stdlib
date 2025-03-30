/**
 * Trimmed-down, linted and commented version from standard circomlib.
 *
 * Author: Alin Tomescu (tomescu.alin@gmail.com)
 */

pragma circom 2.2.2;

// includes MAX_BITS()
include "../functions/utils.circom";

// WARNING: Coerces the input signal into an output signal that is tagged with
// {binary}. Should not need this.
//template CoerceToBinary() {
//    signal input in;
//    signal output {binary} out <== in;
//}

/**
 * Converts an input bit by tagging it with the {binary} tag.
 *
 * Only satisfiable by inputs that are actually bits.
 *
 * @input   in              any value; could be a bit, but not necessarily
 *
 * @output  out {binary}    if `in` was a bit, this is the same bit, but now tagged
 *
 * @postconditions
 *   $out = in \wedge in \in \{0,1\}$
 */
template EnforceBinary() {
    signal input in;

    (1 - in) * in === 0;
    signal output {binary} out <== in;
}

/**
 * Outputs the number that has the given N-bit representation.
 *
 * @param   N               the presumed number of bits of the number
 *
 * @preconditions
 *   $2^N - 1 < p$
 *   $bits[i] \in \{0, 1\}$
 *
 * @input   bits {binary}   an array bits[N-1], ..., bits[0] of bits, with `bits[N-1]`
 *                          being the most significant bit
 *
 * @output  num             the number in [0, 2^N) with the given binary representation
 *
 * @postconditions
 *    $num = \sum_{i = 0}^{N-1} 2^i bits[i]$
 *
 */
template Bits2Num(N) {
    signal input {binary} bits[N];

    // This template assumes that 2^N - 1 fits in a scalar
    _ = assert_bits_fit_scalar(N);

    // incrementally-updated to eventually store the symbolic expression:
    //
    //   bits[0] * 1 + bits[1] * 2 + bits[2] * 2^2 + ... + bits[N-1] * (2^(N-1))
    //
    var acc = 0;

    // stores increasing powers of two: 2^0, 2^1, 2^2, ...
    var pow2 = 1;
    for (var i = 0; i < N; i++) {
        // appends `+ bits[i] * 2^i` as a term to the symbolic expression in
        // `acc`, setting it to \prod_{i = 0}^{N-1} bits[i] * 2^{i+1}
        acc += bits[i] * pow2;

        // set to 2^{i+1}
        pow2 = pow2 + pow2;
    }

    signal output {maxbits} num;
    num.maxbits = N;
    num <== acc;
}

/**
 * Outputs an array of bits containing the N-bit representation of the input number.
 *
 * This effectively acts as a range check for the input number being in [0, 2^N).
 *
 * @param   N   correctness only holds if the number is in [0, 2^N)
 *              soundness is unconditional, but only when 2^N - 1 "fits" in a scalar
 *              (i.e, numbers >= 2^N cannot satisfy this template if 2^N - 1 "fits")
 *
 * @preconditions
 *   $2^N - 1 < p$
 *
 * @input   num             the number to be converted to binary
 *
 * @output  bits {binary}   an array bits[N-1], ..., bits[0] of the N bits representing
 *                          `num` with bits[N-1] being the most significant bit
 *
 * @postconditions
 *    $bits[i] \in \{0, 1\}$
 *    $num = \sum_{i = 0}^{N-1} 2^i bits[i]$
 */
template Num2Bits(N) {
    signal input num;
    signal output {binary} bits[N];

    // Asserts that 2^N - 1 fits in a scalar
    _ = assert_bits_fit_scalar(N);

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