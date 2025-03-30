pragma circom 2.1.7;

include "__lib/wrappers.circom";

template DivRemTest() {
    signal input a, b;

    component dr1 = DivRem_wrapper();
    dr1.a <== 2;
    dr1.b <== 3;
}

component main { public [a, b] } = DivRemTest();