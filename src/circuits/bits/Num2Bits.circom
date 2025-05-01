/**
 * Author: Alin Tomescu
 */
pragma circom 2.2.2;

include "../../functions/utils.circom";

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