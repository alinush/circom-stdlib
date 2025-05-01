pragma circom 2.2.2;

include "Num2Bits.circom";
include "../functions/utils.circom";

/**
 * Checks that the input signal is < 2^N and if so returns a signal tagged
 * with {maxbits} set to N.
 *
 * @input   in              any value
 *
 * @output  out {maxbits}   the same value tagged with maxbits = N if in < 2^N
 *
 * @postconditions
 *   out == in
 *   out < 2^N
 *   out.maxbits <-- N
 */
template ToMaxBits(N) {
    signal input in;

    _ = assert_bits_fit_scalar(N);

    _ <== Num2Bits(N)(in);
    signal output {maxbits} out;
    out.maxbits = N;
    out <== in;

    assert(out.maxbits == N);
    assert(out == in);
    assert(out < 2^N);
}
