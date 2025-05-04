pragma circom 2.1.7;

include "strings/IsConcatenationInternal.circom";
include "strings/ToString.circom";

template IsConcatenationInternal_wrapper(N, N_1, N_2) {
    signal input s[N], s1[N_1], s2[N_2];
    signal input tau;

    String(N) s_str <== ToString(N)(s);
    String(N_1) s_1_str <== ToString(N_1)(s1);
    String(N_2) s_2_str <== ToString(N_2)(s2);

    signal output out <== IsConcatenationInternal(N, N_1, N_2)(s_str, s_1_str, s_2_str, tau);
}

component main { public [s, s1, s2, tau] } = IsConcatenationInternal_wrapper(16, 10, 10);
