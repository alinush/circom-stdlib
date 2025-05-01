pragma circom 2.1.7;

include "strings/IsConcatenationInternal.circom";
include "strings/ToString.circom";

template IsConcatenationInternal_wrapper(N, N_1, N_2) {
    signal input s_raw[N], s1_raw[N_1], s2_raw[N_2];
    signal input tau;

    String(N) s <== ToString(N)(s_raw);
    String(N_1) s_1 <== ToString(N_1)(s1_raw);
    String(N_2) s_2 <== ToString(N_2)(s2_raw);

    signal output out <== IsConcatenationInternal(N, N_1, N_2)(s, s_1, s_2, tau);
}

component main { public [s_raw, s1_raw, s2_raw, tau] } = IsConcatenationInternal_wrapper(16, 10, 10);
