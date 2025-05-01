/**
 * Author: Alin Tomescu
 */
pragma circom 2.2.2;

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