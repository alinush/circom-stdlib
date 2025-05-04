const chai = require("chai");
const path = require("path");
const F1Field = require("ffjavascript").F1Field;
const Scalar = require("ffjavascript").Scalar;
// exports.p = ;
// BN254's prime p
const Fr = new F1Field(Scalar.fromString("21888242871839275222246405745257275088548364400416034343698204186575808495617"));

const wasm_tester = require("circom_tester").wasm;

const assert = chai.assert;

describe("lessthan soundness test", function ()  {
    this.timeout(100000);

    // Really bad because there may be a lot of code that calls LessThan(32)(x, 2^{31})
    it("LessThan_2to32 soundness breaks for (p-(2^31), 2^31)", async() => {
        const circuit = await wasm_tester(
            path.join(__dirname, "LessThan_2to32_notags.circom"),
            {
                "prime": "bn128",
                "include": [ path.join(__dirname, "../../../src/circuits/") ],
            },
        );

        let witness = await circuit.calculateWitness({
            "lhs": Fr.e("-2147483648"),
            "rhs": Fr.e("2147483648")
        }, true);
        await circuit.checkConstraints(witness);
        await circuit.assertOut(witness, { out: 1 });
    });

    it("LessThan_2 soundness breaks for (0, p-2)", async() => {
        const circuit = await wasm_tester(
            path.join(__dirname, "LessThan_2_notags.circom"),
            {
                "prime": "bn128",
                "include": [ path.join(__dirname, "../../../src/circuits/") ],
            },
        );

        let witness = await circuit.calculateWitness({ "lhs": 0, "rhs": Fr.e("-2") }, true);
        // console.log(witness);
        await circuit.checkConstraints(witness);
        await circuit.assertOut(witness, { out: 0 });
    });

    it("LessThan_2 soundness breaks for (p-2, 0)", async() => {
        const circuit = await wasm_tester(
            path.join(__dirname, "LessThan_2_notags.circom"),
            {
                "prime": "bn128",
                "include": [ path.join(__dirname, "../../../src/circuits/") ],
            },
        );

        let witness = await circuit.calculateWitness({ "lhs": Fr.e("-2"), "rhs": 0 }, true);
        // console.log(witness);
        await circuit.checkConstraints(witness);
        await circuit.assertOut(witness, { out: 1 });
    });

    it("LessThan_2 soundness breaks for (p-2, 1)", async() => {
        const circuit = await wasm_tester(
            path.join(__dirname, "LessThan_2_notags.circom"),
            {
                "prime": "bn128",
                "include": [ path.join(__dirname, "../../../src/circuits/") ],
            },
        );

        let witness = await circuit.calculateWitness({ "lhs": Fr.e("-2"), "rhs": 2 }, true);
        // console.log(witness);
        await circuit.checkConstraints(witness);
        await circuit.assertOut(witness, { out: 1 });
    });

    it("LessThan_2 soundness breaks for (p-2, 2)", async() => {
        const circuit = await wasm_tester(
            path.join(__dirname, "LessThan_2_notags.circom"),
            {
                "prime": "bn128",
                "include": [ path.join(__dirname, "../../../src/circuits/") ],
            },
        );

        let witness = await circuit.calculateWitness({ "lhs": Fr.e("-2"), "rhs": 2 }, true);
        // console.log(witness);
        await circuit.checkConstraints(witness);
        await circuit.assertOut(witness, { out: 1 });
    });
});
