/**
 * Author: Alin Tomescu
 */
pragma circom 2.2.2;

include "../../functions/min_num_bits.circom";
include "../bits/ToMaxBits.circom";
include "../comparators/LessThan.circom";
include "../comparators/ToLessThanConstant.circom";
include "arrays/SuffixSelector.circom";
include "String.circom";

/**
 * Converts an adversarially-provided array into a type-safe, bounded-length, 
 * zero-padded string.
 *
 * @param  MAX_LEN    the max # of characters in the string; must be > 0, because
 *                    pretty useless template otherwise
 *
 * @input  in   the unsanitized string characters (may not even be bytes)
 *
 * @output s    the validated string as a String(MAX_LEN) bus
 *
 * @preconditions
 *    `in` is a valid string: i.e., first `len` bytes are non-zero; remaining
 *    `MAX_LEN - len` bytes are zero
 *
 * @postconditions
 *    all the invariants in String(MAX_LEN)'s comments
 */
template ToString(MAX_LEN) {
    // It'd be a pretty-useless template if the max string length were 0
    assert(MAX_LEN > 0);

    signal input in[MAX_LEN];
    output String(MAX_LEN) s;

    // Compute string length
    var len;
    for(len = 0; in[len] != 0; len++) {
        // skip over non-zero chars
    }

    // Compute the string length (untrusted witness generation)
    s.len.maxvalue = MAX_LEN;
    s.len.maxbits = min_num_bits(MAX_LEN);
    s.len <-- len;

    // Ensure in[i] = 0, \forall i \in [s.len, MAX_LEN)
    signal suffixMask[MAX_LEN] <== SuffixSelector(MAX_LEN)(s.len);
    for (var i = 0; i < MAX_LEN; i++) {
        suffixMask[i] * in[i] === 0;
    }

    // Ensure in[i] != 0, \forall i \in [0, s.len)
    signal inv[MAX_LEN];
    for (var i = 0; i < MAX_LEN; i++) {
        inv[i] <-- in[i] != 0 ? 1 / in[i] : 0;
        inv[i] * in[i] === 1 - suffixMask[i];
    }

    // Copy over the string, ensuring every character is a byte
    s.chars.maxbits = 8;
    for (var i = 0; i < MAX_LEN; i++) {
        _ <== ToMaxBits(8)(in[i]);
        s.chars[i] <== in[i];
    }

    // Sanity-check assertions
    assert(s.len.maxbits == min_num_bits(MAX_LEN));
    assert(s.len.maxvalue == MAX_LEN);
    assert(s.chars.maxbits == 8);
}
    
        