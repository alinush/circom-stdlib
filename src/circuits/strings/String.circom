/**
 * Author: Alin Tomescu
 */
pragma circom 2.2.2;

/**
 * @param   N             the maximum length in bytes of the strings
 *
 * @signal chars[N] {maxbits}       the characters of the string
 *
 * @signal len {maxbits, maxvalue}  the length of the string such that 
 *                                  chars[len..] are all zeros
 *
 * @invariants
 *    0 <= len < N
 *    chars[i] \in [0, 2^8), \forall i \in [0, n)
 *    chars[i] != 0,         \forall i \in [0, len)
 *    chars[i] = 0,          \forall i \in [len, N)
 *    len.maxbits  <-- min_num_bits(N)
 *    len.maxvalue <-- N - 1
 */
bus String(N) {
    signal {maxbits} chars[N];
    signal {maxbits, maxvalue} len;
}