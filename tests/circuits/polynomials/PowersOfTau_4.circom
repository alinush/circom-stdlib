pragma circom 2.1.7;

include "polynomials/PowersOfTau.circom";

component main { public [tau] } = PowersOfTau(4);
