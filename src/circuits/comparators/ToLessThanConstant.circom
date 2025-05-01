/**
 * Author: Alin Tomescu
 */
pragma circom 2.2.2;

// For Num2Bits
include "../comparators/LessThan.circom";
include "../bits/ToMaxBits.circom";
include "../../functions/min_num_bits.circom";

/**
 * Checks that the input signal is < C and if so returns a signal tagged
 * with {maxbits} set to min_num_bits(C) and {maxvalue} set to C.
 *
 * @input   in                      any value
 *
 * @output  out {maxbits, maxvalue} the same value as `in`, tagged
 *
 * @postconditions
 *   out == in
 *   out < C
 *   out.maxbits  <-- min_num_bits(C)
 *   out.maxvalue <-- C-1
 */
template ToLessThanConstant(C) {
    signal input in;
    signal output {maxvalue, maxbits} out;

    // Later on, we'll ensure out < C; but we tag the out signal early here
    out.maxvalue = C - 1;

    // Ensure |in| <= |C| in bits
    var C_NUM_BITS = min_num_bits(C);
    out <== ToMaxBits(C_NUM_BITS)(in);

    // Need to artificially build a {maxbits}-tagged signal that stores C
    // so we can call LessThan() safely below.
    signal {maxbits} C_tagged;
    C_tagged.maxbits = C_NUM_BITS;
    C_tagged <== C;
    
    signal is_less_than <== LessThan()(out, C_tagged);
    is_less_than === 1;

    assert(out == in);
    assert(out < C);
    assert(out.maxbits == C_NUM_BITS);
    assert(out.maxvalue == C - 1);
}