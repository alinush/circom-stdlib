/**
 * Author: Alin Tomescu
 */
pragma circom 2.2.2;

include "../functions/utils.circom";

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