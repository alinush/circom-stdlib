const chai = require("chai");
const path = require("path");
const F1Field = require("ffjavascript").F1Field;
const Scalar = require("ffjavascript").Scalar;
// BN254's prime p, but it doesn't affect circom_tester's config; need to manually pass in the prime
// exports.p = Scalar.fromString("21888242871839275222246405745257275088548364400416034343698204186575808495617");
//const Fr = new F1Field(exports.p);

const wasm_tester = require("circom_tester").wasm;

const assert = chai.assert;

describe("IsNonZero test", function ()  {
    this.timeout(100000);

    it("basic viability test", async() => {
        const circuit = await wasm_tester(
            path.join(__dirname, "IsNonZero.circom"),
            { 
                "include": [ path.join(__dirname, "../../../src/circuits/") ],
            },
        );

        const _circuit_2 = await wasm_tester(
            path.join(__dirname, "IsZero.circom"),
            { 
                "include": [ path.join(__dirname, "../../../src/circuits/") ],
            },
        );

        witness = await circuit.calculateWitness({ "in": 0 }, true);
        await circuit.checkConstraints(witness);
        await circuit.assertOut(witness, { out: 0 });


        witness = await circuit.calculateWitness({ "in": 1 }, true);
        await circuit.checkConstraints(witness);
        await circuit.assertOut(witness, { out: 1 });


        witness = await circuit.calculateWitness({ "in": 23 }, true);
        await circuit.checkConstraints(witness);
        await circuit.assertOut(witness, { out: 1 });
    });
});
