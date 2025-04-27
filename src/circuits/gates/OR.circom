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
