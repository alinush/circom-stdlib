/**
 * Trimmed-down, linted and commented version from standard circomlib.
 *
 * Author: Alin Tomescu (tomescu.alin@gmail.com)
 */

pragma circom 2.2.2;

// includes Num2Bits(N)()
include "bitify.circom";
// includes MAX_BITS()
include "../functions/utils.circom";
// includes NOT()
include "gates.circom";

 /**
  * Outputs a truth bit indicating whether the input number `in` is zero or not.
  *
  * Input signals:
  *   in    scalar      the input number
  *
  * Output signals:
  *   out   {binary}    the truth bit indicating if `in` is zero
  *
  * Notes:
  *   When `in` is 0, the `in * out === 0` constraint is trivially satisfied.
  *   The `1 - in * inv === out` constraint can only be satified by assigning 1
  *   to `out`. Therefore, when `in = 0`, we must have `out = 1`, as desired.
  *
  *   When `in` is non-zero, the `in * out === 0` constraint can only be
  *   satisfied by assigning 0 to `out`. But, we must also satisfy 
  *   `1 - in * inv === out`. This can be done by assigning `1/in` to `inv` 
  *   (via witness generation).
  *
  *   You'll note the beauty of the `1 - in * inv === out` constraint, if you
  *   pay attention: `in * inv` is either 1 (when `in` is non-zero) or 0 (when
  *   `in` is zero).
  */
template IsZero() {
    signal input in;

    // The inverse of `in`, when in != 0.
    // AFAICT, what we assign to inv when in = 0 does not even matter.
    signal inv <-- in != 0 ? 1/in : 0;

    signal output {binary} out <== 1 - in * inv;
    
    in * out === 0;
}

/**
 * Opposite of IsZero.
 *
 * @notes
 *   if out is 1 => C1 constrains in * inv === 1 => inv === in^{-1} => in != 0
 *   if out is 0 => C2 constrains in === 0
 *
 *   if in is 0 => C1 constrains out === 0
 *   if in is 1 ==> C2 constrains 1 - out === 0 => out === 1
 */
template IsNonZero() {
    signal input in;

    signal inv <-- in != 0 ? 1/in : 0;

    // C1
    signal output {binary} out <== in * inv;

    // C2
    in * (1 - out) === 0;
}

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
    signal output {binary} out;

    out <== IsZero()(lhs - rhs);
}

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

/**
 * Outputs a truth bit for whether lhs < rhs when viewed as N-bit
 * *unsigned* integers.
 *
 * @preconditions
 *
 * @input   lhs {maxbits}   the left-hand side input < 2^N
 * @input   rhs {maxbits}   the right-hand side input < 2^M
 *
 * @output  out {binary}    a bit indicating whether lhs < rhs when viewed as integers
 *
 * @notes
 *   The old LessThan(N) template was (unfortunately) hard-coded for the scalar field
 *   of BN254, where scalars are \le (p - 1) and where 2^253 < p < 2^254.
 *
 *   The choice of N <= 252 ensures that the maximum value assigned to `bits`
 *   below is (2^N - 1) + 2^N = 2^{N+1} - 1 = 2^253 - 1, and thus does not
 *   exceed p-1.
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
    //  rhs   = 001
    //  m     = lhs + 1 << L - rhs
    //        = 100 + 1000   - 001
    //        = 1100 - 001
    //        = 1011
    //
    // e.g., flipping over
    //  lhs   = 001
    //  rhs   = 100
    //  m     = lhs + 1 << L - rhs
    //        = 001 + 1000   - 100
    //        = 1001 - 100
    //        = 0101
    signal {binary} bits[L + 1] <== Num2Bits(L + 1)(lhs + (1 << L) - rhs);

    // if lhs >= rhs, then:
    //   bits[L], the L'th bit toggled above by adding 2^L, remains 1 => assign 0 to `out`
    // else:
    //   bits[L] turns into 0 => assign 1 to `out`
    //
    signal output {binary} out <== 1 - bits[L];

    // Mark remaining signals as intentionally-unused & avoid unnecessary compiler warnings
    for(var i = 0; i < L; i++) {
        _ <== bits[i];
    }
}

/**
 * Like LessThan(), except for the `<=` operator (not for `<`).
 */
template LessEqThan() {
    signal input {maxbits} lhs;
    signal input {maxbits} rhs;

    // is_gt = (lhs > rhs)
    signal is_gt <== GreaterThan()(lhs, rhs);

    // returns !(lhs > rhs)
    // so, returns lhs <= rhs
    signal output {binary} out <== NOT()(is_gt);
}

/**
 * Like LessThan(), except for the `>` operator (not for `<`).
 */
template GreaterThan() {
    signal input {maxbits} lhs, rhs;

    // Flip the argument order:
    // lhs > rhs <=> LessThan()(rhs, lhs)
    signal output {binary} out <== LessThan()(rhs, lhs);
}