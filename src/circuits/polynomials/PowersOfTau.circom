/**
 * Author: Alin Tomescu
 */
pragma circom 2.2.2;

/**
 * Returns \tau^0, \tau^1, \tau^2, ..., \tau^{N-1}
 *
 * @param   N     the number of powers of \tau
 *
 * @input   tau   the trapdoor tau
 * @output  ptau  the powers of tau, where ptau[i] = \tau^i
 */
template PowersOfTau(N) {
    assert(N >= 2);
    
    signal input tau;
    signal output ptau[N];

    ptau[0] <== 1;
    ptau[1] <== tau;
    for (var i = 2; i < N; i++) {
       ptau[i] <== ptau[i - 1] * tau; 
    }
}