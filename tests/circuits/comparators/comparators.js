const chai = require("chai");
const path = require("path");
const F1Field = require("ffjavascript").F1Field;
const Scalar = require("ffjavascript").Scalar;
// BN254's prime p, but it doesn't affect circom_tester's config; need to manually pass in the prime
// exports.p = Scalar.fromString("21888242871839275222246405745257275088548364400416034343698204186575808495617");
//const Fr = new F1Field(exports.p);

const wasm_tester = require("circom_tester").wasm;

const assert = chai.assert;

describe("comparators test", function ()  {
    this.timeout(100000);

    it("compilation tests", async() => {
        let files = [
            "GreaterThan_252.circom",
            "LessThan_252.circom", 
            "LessEqThan_252.circom",
            "IsEqual.circom",
            "IsNotEqual.circom",
        ];
        for(let fileIdx in files) {
            const _ = await wasm_tester(
                path.join(__dirname, files[fileIdx]),
                { 
                    "include": [ path.join(__dirname, "../../../src/circuits/") ],
                },
            );
        }
    });

    it("IsEqual tests", async() => {
        const circuit = await wasm_tester(
            path.join(__dirname, "IsEqual.circom"),
            { 
                "include": [ path.join(__dirname, "../../../src/circuits/") ],
            },
        );

        // TODO: are_equal_test_cases and are_not_equal_test_cases
        // run all of them on both templates and make sure the templates contradict each other

        let witness = await circuit.calculateWitness({ "lhs": 111, "rhs": 222 }, true);
        // witness[0] is always set to 1 by convention
        //assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)));
        // witness[1] is the value of the main output signal of the circuit
        //assert(Fr.eq(Fr.e(witness[1]), Fr.e(0)), "111 != 222");
        await circuit.checkConstraints(witness);
        await circuit.assertOut(witness, { out: 0 });

        witness = await circuit.calculateWitness({ "lhs": 444, "rhs": 444 }, true);
        await circuit.checkConstraints(witness);
        await circuit.assertOut(witness, { out: 1 });

        witness = await circuit.calculateWitness({ "lhs": 0, "rhs": 0 }, true);
        await circuit.checkConstraints(witness);
        await circuit.assertOut(witness, { out: 1 });

        witness = await circuit.calculateWitness({ "lhs": 1, "rhs": 1 }, true);
        await circuit.checkConstraints(witness);
        await circuit.assertOut(witness, { out: 1 });

        witness = await circuit.calculateWitness({ "lhs": 0, "rhs": 1 }, true);
        await circuit.checkConstraints(witness);
        await circuit.assertOut(witness, { out: 0 });

        witness = await circuit.calculateWitness({ "lhs": 1, "rhs": 0 }, true);
        await circuit.checkConstraints(witness);
        await circuit.assertOut(witness, { out: 0 });
    });
});
