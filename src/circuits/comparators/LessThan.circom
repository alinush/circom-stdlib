/**
 * Author: Alin Tomescu
 */
pragma circom 2.2.2;

include "../bits/Num2Bits.circom";
include "../../functions/max_signed.circom";
include "../../functions/assert_bits_fit_scalar.circom";

/**
 * Outputs a truth bit for whether lhs < rhs when viewed as N-bit
 * *unsigned* integers.
 *
 *
 * @input   lhs {maxbits}   the left-hand side input < 2^N
 * @input   rhs {maxbits}   the right-hand side input < 2^M
 *
 * @output  out {binary}    a bit indicating whether lhs < rhs when viewed as integers
 *
 * @preconditions
 *   lhs < 2^N
 *   rhs < 2^M
 *
 * @notes
 *   The old LessThan(N) template was (unfortunately) hard-coded for the scalar field
 *   of BN254, where scalars are \le (p - 1) and where 2^253 < p < 2^254.
 *
 *   Specifically, it was asserted that N <= 252, which ensures that the maximum
 *   value assigned to `bits` is (2^N - 1) + 2^N = 2^{N+1} - 1 = 2^253 - 1 and
 *   thus does not exceed p-1.
 *
 *   (If N were <= 253, then this maximum value would have been 2^254 - 1
 *    which would be larger than p-1 and would thus not fit in a signal.)
 */
template LessThan() {
    signal input {maxbits} lhs;
    signal input {maxbits} rhs;

    var L = max_signed(lhs.maxbits, rhs.maxbits);

    // We have to make sure 1 << L (which is L+1 bits wide) fits in the scalar 
    // field. Otherwise, we lose soundness.
    _ = assert_bits_fit_scalar(L+1);

    // (L+1)-bit representation of m = lhs + 1 << L - rhs
    //                               = lhs + 2^L    - rhs
    //                               <= (2^L - 1) + 2^L - 0 <= 2^{L+1} - 1
    // e.g., for L = 3
    //  lhs   = 100
    //        >
    //  rhs   = 001
    //  m     = lhs + 1 << L - rhs
    //        = 100 + 1000   - 001
    //        = 1100 - 001
    //        = 1011
    //        = ^___
    //
    // e.g., flipping over
    //  lhs   = 001
    //        <
    //  rhs   = 100
    //  m     = lhs + 1 << L - rhs
    //        = 001 + 1000   - 100
    //        = 1001 - 100
    //        = 0101
    //        = ^___
    signal {binary} bits[L + 1] <== Num2Bits(L + 1)(lhs + (1 << L) - rhs);

    // if lhs < rhs, then:
    //   bits[L], the L'th bit toggled above by adding 2^L, becomes 0 => assign 1 to `out`
    // else:
    //   bits[L], the L'th bit toggled above by adding 2^L, remains 1 => assign 0 to `out`
    //
    signal output {binary} out <== 1 - bits[L];

    // Mark remaining signals as intentionally-unused & avoid unnecessary compiler warnings
    for(var i = 0; i < L; i++) {
        _ <== bits[i];
    }
}