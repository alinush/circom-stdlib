/**
 * Playground file to experiment in.
 */
pragma circom 2.2.2;

template Main(N) {
    signal input in;
}

component main { public [in] } =  Main(
    32  // N
);
