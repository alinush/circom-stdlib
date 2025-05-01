/**
 * Author: Alin Tomescu
 */
pragma circom 2.2.2;

include "String.circom";
include "StringToPolyEval.circom";
include "../arrays/ArrayGet.circom";
include "../bits/AssertHasBinaryTag.circom";
include "../comparators/IsEqual.circom";
include "../polynomials/PowersOfTau.circom";

/**
 * Checks whether s = s_1 || s_2, where || denotes string concatenation.
 *
 * @param   N      the max length of s
 * @param   N_1    the max length of s_1
 * @param   N_2    the max length of s_2
 *
 * @input s   : String(N)    the concatenated string s
 * @input s_1 : String(N_1)  the first string s_1
 * @input s_2 : String(N_2)  the second string s_2
 * @input tau                random Fiat-Shamir challenge, typically-derived by
 *                           hashing (s, s_1, s_2)
 *
 * @output out {binary}     a bit indicating whether s = s_1 || s_2
 *
 * TODO(Test): test for lengths of zero
 * TODO(Test): test for N_1 > N and/or N_2 > N
 * TODO(Test): test for N_1 + N_2 > N
 * TODO(Test): test |s_1| = 0 and/or |s_2| = 0
 * TODO(Test): test for |s_i| > |s|
 */
template IsConcatenationInternal(N, N_1, N_2) {
    assert(N_1 <= N);
    assert(N_2 <= N);

    input String(N) s;
    input String(N_1) s_1;
    input String(N_2) s_2;
    signal input tau;

    s.len === s_1.len + s_2.len;

    signal ptau[N] <== PowersOfTau(N)(tau);
    
    // compute s_1(\tau)
    signal e_1 <== StringToPolyEval(N_1, N)(s_1, ptau);
    // compute s_2(\tau)
    signal e_2 <== StringToPolyEval(N_2, N)(s_2, ptau);
    // compute s(\tau)
    signal e <== StringToPolyEval(N, N)(s, ptau);

    // get \tau^{|s_1|}
    signal tauToL1 <== ArrayGet(N)(ptau, s_1.len);

    // check s(\tau) == s_1(\tau) + \tau^{|s_1|} s_2(\tau)
    signal output out <== IsEqual()(e, e_1 + tauToL1 * e_2);

    AssertHasBinaryTag()(out);
}