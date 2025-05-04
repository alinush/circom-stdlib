pragma circom 2.2.2;

include "ArrayGet_Tagger.circom";

component main { public [arr, idx] } = ArrayGet_Tagger(20);