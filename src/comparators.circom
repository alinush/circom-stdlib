/**
 * Trimmed-down, linted and commented version from standard circomlib.
 *
 * Author: Alin Tomescu (tomescu.alin@gmail.com)
 */

pragma circom 2.1.7;

// Needed for Num2Bits
include "bitify.circom";

 /**
  * Outputs a truth bit indicating whether the input number `in` is zero or not.
  *
  * Input signals:
  *   in        the input number
  *
  * Output signals:
  *   out       the truth bit indicating if `in` is zero
  *
  * Notes:
  *   When `in` is 0, the `in * out === 0` constraint is trivially satisfied.
  *   The `-in * inv + 1 === out` constraint can only be satified by assigning 1
  *   to `out`. Therefore, when `in = 0`, we must have `out = 1`, as desired.
  *
  *   When `in` is non-zero, the `in * out === 0` constraint can only be
  *   satisfied by assigning 0 to `out`. But, we must also satisfy 
  *   `-in * inv + 1 === out`. This can be done by assigning `1/in` to `inv` 
  *   (via witness generation).
  *
  *   You'll note the beauty of the `-in * inv + 1 === out` constraint, if you
  *   pay attention: `in * inv` is either 1 (when `in` is non-zero) or 0 (when
  *   `in` is zero).
  */
template IsZero() {
    signal input in;
    signal output out;      // TODO(Tags): Tag as {binary}?
    
    signal inv;             // the inverse of `in`, when in != 0
 
    // AFAICT, what we assign to inv when in = 0 does not even matter
    inv <-- in != 0 ? 1/in : 0;
    -in * inv + 1 ==> out;
    
    in * out === 0;
}

/*original
template IsZero() {
    signal input in;
    signal output out;

    signal inv;

    inv <-- in!=0 ? 1/in : 0;

    out <== -in*inv +1;
    in*out === 0;
}*/

/**
 * Outputs a truth bit for whether in[0] < in[1] when viewed as N-bit
 * integers.
 *
 * Parameters:
 *   N      in[0] and in[1] MUST be in [0, 2^N)
 *
 * Input signals:
 *   in     array of the two numbers to be compared
 *
 * Output signals:
 *   out    a bit indicating whether in[0] < in[1] when viewed as integers
 */
template LessThan(N) {
    // This seems to (unfortunately) be hard-coded for the scalar field of BN254,
    // where scalars are \le (p - 1) and where 2^253 < p < 2^254.
    //
    // The choice of N <= 252 ensures that the maximum value assigned to `bits`
    // below is 2^N + (2^N - 1) = 2^{N+1} - 1 = 2^253 - 1, and thus does not
    // exceed p-1.
    //
    // (If N were <= 253, then this maximum value would have been 2^254 - 1
    //  which would be larger than p-1 and would thus not fit in a signal.)
    assert(N <= 252);

    signal input in[2];

    // (N+1)-bit representation of m = (2^N + in[0]) - in[1]
    // e.g., for N = 3
    //  in[0] = 100
    //  in[1] = 001
    //  m     = (1000 + 100) - 001
    //        = 1100 - 001
    //        = 1011
    signal bits[N + 1] <== Num2Bits(N + 1)(in[0] + (1 << N) - in[1]);

    // if in[0] >= in[1], then:
    //   bits[N], the nth bit toggled above by adding 2^N, remains 1 => assign 0 to `out`
    // else:
    //   bits[N] turns into 0 => assign 1 to `out`
    //
    // TODO(Tags): add {binary} tag?
    signal output out <== 1 - bits[N];
}

/* original
template LessThan(n) {
    assert(n <= 252);
    signal input in[2];
    signal output out;

    component n2b = Num2Bits(n+1);

    n2b.in <== in[0]+ (1<<n) - in[1];

    out <== 1-n2b.out[n];
}*/

/**
 * Outputs a truth bit for whether in[0] > in[1] when viewed as N-bit
 * integers.
 *
 * Parameters:
 *   N      in[0] and in[1] MUST be in [0, 2^N)
 *
 * Input signals:
 *   in     array of the two numbers to be compared
 *
 * Output signals:
 *   out    a bit indicating whether in[0] > in[1] when viewed as integers
 */
template GreaterThan(N) {
    signal input in[2];

    // calls LessThan on in[1] and in[0], flipping the argument order
    component lt = LessThan(N);
    lt.in[0] <== in[1];
    lt.in[1] <== in[0];

    // TODO(Tags): Tag as {binary}?
    signal output out <== lt.out;
}

/*original
// N is the number of bits the input  have.
// The MSF is the sign bit.
template GreaterThan(n) {
    signal input in[2];
    signal output out;

    component lt = LessThan(n);

    lt.in[0] <== in[1];
    lt.in[1] <== in[0];
    lt.out ==> out;
}
*/
