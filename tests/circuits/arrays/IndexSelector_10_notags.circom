pragma circom 2.2.2;

include "IndexSelector_ForcedTagger.circom";

component main { public [idx] } = IndexSelector_ForcedTagger(10);