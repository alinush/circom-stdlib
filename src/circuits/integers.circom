pragma circom 2.2.2;

include "bitify.circom";
include "comparators.circom";
include "../functions/utils.circom";

// Divides a by b, returning a quotient q and a remainder r, as if a and
// b are integers that "fit" in the circuit's scalar field. For this
// template to be sound, the prime p must be large enough (see below).
//
// @preconditions
//   M <-- b.maxbits (i.e., 0 <= a < 2^N)
//   N <-- a.maxbits (i.e., 0 <= b < 2^M)
//   2^M(2^N + 1) <= p
//
// @input   a {maxbits}           the N-bit dividend
// @input   b {nonzero, maxbits}  the M-bit divisor
//
// @output  q {maxbits}           the N-bit quotient
// @output  r {maxbits}           the M-bit remainder
//
// @postconditions:
//   0 <= q < 2^N (i.e., q.maxbits = N)
//   0 <= r < b   (i.e., r.maxbits = M)
//   a = q b + r  (over the integers)
//
// @notes
//   Recall that, when dividing a by b, we get a quotient q and remainder r, such that:
//     0 <= r < b
//     a = q b + r
//
//   What is the max size in bits of q? It arises when r = 0 and b = 1.
//     max{|q|} = max{|a|} = N bits
//   
//   We know that a < 2^N, b < 2^M.
//
//   Of course, we check that a = q b + r (mod p)
//   Of course, we check that 0 <= r < b (< 2^M).
//   Say we check that 0 <= q < 2^N.
//
//   Is this enough?
//
//   Under what conditions does this guarantee that our division holds 
//   over the integers, without any wrap around?
//
//   Well, from the checks above: \forall q, r: q b + r < 2^{N + M} + 2^M.
//   So, as long as this "fits" inside a field element, we are good.
//   In other words, as long as 2^{N + M} + 2^M <= p <=> 2^M(2^N + 1) <= p, we are good. (Also fine if < p.)
//   
//   How do we check N, M against p at compile-time though?
//   Not easy, given circom's clumsiness. Instead, we'll over-approximate
//   and check that 2^{N + M + 1} < p.
template DivRem() {
    signal input {maxbits} a;
    signal input {nonzero, maxbits} b;
    signal output {maxbits} q;
    signal output {maxbits} r;

    var N = a.maxbits;
    var M = b.maxbits;

    // Tags must be assigned first before assigning the signals (ugh)
    r.maxbits = M;
    r <-- a % b;
    q.maxbits = N;
    q <-- a \ b;

    // We only need to test 2^M(2^N + 1) <= p, but no easy way to in circom.
    // Instead, we can test that a slighlty larger 2^{M + N + 1} < p.
    // We do lose the ability of using this with higher (N, M), but that's okay.
    _ = assert_bits_fit_scalar(N + M + 1);

    // Check Euclidean division theorem, including r \in [0, b)
    a === q * b + r;

    // We can assume b < 2^M, because it is tagged.
    // But, for the remainder r, we have to enforce it:
    // (Of course, r may is a bit smaller than M bits, because r < b)
    _ <== Num2Bits(M)(r);

    // Note: r, b are tagged as < 2^M
    signal valid_remainder <== LessThan()(r, b);
    valid_remainder === 1;

    // Check that q is bounded, otherwise we are in trouble
    _ <== Num2Bits(N)(q);
}