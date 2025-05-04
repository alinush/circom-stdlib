/**
 * Author: Alin Tomescu
 */
pragma circom 2.2.2;

include "String.circom";
include "../arrays/Sum.circom";

/**
 * Derives a degree-bound N polynomial s(X) from a string s and evaluates it at a
 * point \tau, given the P powers of \tau as auxiliary input, where P >= N.
 *
 * @param   N               the max length of the string
 * @param   P               the max length of the powers of tau, >= N
 *
 * @input   s : String(N)   a string [s_0, s_1, ..., s_{N-1}], viewed as a polynomial
 *                          s(X) = \sum_{i=0}^{N-1} s_i X^i
 * @input   ptau[P]         \tau^0, \tau^1, ..., \tau^{P-1}
 *
 * @output  eval            the evaluation s(\tau)
 */
template StringToPolyEval(N, P) {
    assert(P >= N);

    input String(N) s;
    signal input ptau[P];

    signal terms[N];
    for (var i = 0; i < N; i++) {
       terms[i] <== s.chars[i] * ptau[i];
    }

    signal output eval <== Sum(N)(terms);
} 