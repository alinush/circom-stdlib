pragma circom 2.2.2;

include "ArrayGet_tagger.circom";

component main { public [arr, idx_raw] } = ArrayGet_tagger(100, 1);