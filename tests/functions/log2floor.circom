pragma circom 2.2.2;

include "../functions/log2_floor.circom";

template log2floor_test() {
    signal input in;

    assert(log2_floor(1) == 0);

    assert(log2_floor(2) == 1);
    assert(log2_floor(3) == 1);

    assert(log2_floor(4) == 2);
    assert(log2_floor(5) == 2);
    assert(log2_floor(6) == 2);
    assert(log2_floor(7) == 2);

    assert(log2_floor(8) == 3);
    assert(log2_floor(9) == 3);
    assert(log2_floor(10) == 3);
    assert(log2_floor(11) == 3);
    assert(log2_floor(12) == 3);
    assert(log2_floor(13) == 3);
    assert(log2_floor(14) == 3);
    assert(log2_floor(15) == 3);
}

component main { public [in] } =  log2floor_test(
);
