pragma circom 2.2.2;

/**
 * Logically OR's two bits.
 *
 * @input lhs {binary}  left-hand side input
 * @input rhs {binary}  right-hand side input
 *
 * @output or {binary}  logical OR of the LHS and RHS inputs (i.e., lhs | rhs)
 */
template OR() {
    signal input {binary} lhs;
    signal input {binary} rhs;
    signal output {binary} or;

    or <== lhs + rhs - lhs * rhs;
}

/**
 * Returns the negated bit value.
 *
 * @input in {binary}  input bit
 *
 * @output notin {binary}  logical NOT input bit (i.e., !in)
 */
template NOT() {
    signal input {binary} in;
    // TODO: Why does circomlib use: `1 + in - 2*in`?
    signal output {binary} notin <== 1 - in;
}