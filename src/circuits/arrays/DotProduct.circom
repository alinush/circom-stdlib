/**
 * Author: Alin Tomescu
 */
pragma circom 2.2.2;

/**
 * Returns the dot product of two equal-sized array: 
 *   i.e., \sum_{i = 0}^{N - 1} lhs[i] * rhs[i].
 *
 * @param  N       the array size
 *
 * @input  lhs[N]  the left-hand side input array
 * @input  rhs[N]  the right-hand side input array
 *
 * @output out     the dot product
 */
template DotProduct(N) {
    signal input lhs[N];
    signal input rhs[N];

    signal term[N];
    var sum = 0;
    for (var i = 0; i < N; i++) {
        term[i] <== lhs[i] * rhs[i];
        sum = sum + term[i];
    }

    signal output out <== sum;
}