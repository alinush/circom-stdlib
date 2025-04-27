pragma circom 2.2.2;

include "comparators/IsNotEqual.circom";

component main { public [lhs, rhs] } = IsNotEqual();
