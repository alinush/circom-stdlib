/**
 * Author: Alin Tomescu
 */
pragma circom 2.2.2;

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