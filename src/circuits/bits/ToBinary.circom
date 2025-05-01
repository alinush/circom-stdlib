/**
 * Author: Alin Tomescu
 */
pragma circom 2.2.2;

include "../functions/utils.circom";

// WARNING: Coerces the input signal into an output signal that is tagged with
// {binary}. Should not need this.
//template CoerceToBinary() {
//    signal input in;
//    signal output {binary} out <== in;
//}

/**
 * Converts an input bit by tagging it with the {binary} tag.
 *
 * Only satisfiable by inputs that are actually bits.
 *
 * @input   in              any value; could be a bit, but not necessarily
 *
 * @output  out {binary}    if `in` was a bit, this is the same bit, but now tagged
 *
 * @postconditions
 *   $out = in \wedge in \in \{0,1\}$
 */
template ToBinary() {
    signal input in;

    (1 - in) * in === 0;
    signal output {binary} out <== in;
}