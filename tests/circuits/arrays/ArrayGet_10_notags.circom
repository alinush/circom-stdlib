pragma circom 2.2.2;

include "ArrayGet_ForcedTagger.circom";

component main { public [arr, idx] } = ArrayGet_ForcedTagger(10);