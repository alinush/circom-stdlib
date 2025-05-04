const chai = require("chai");
const path = require("path");
const F1Field = require("ffjavascript").F1Field;
const Scalar = require("ffjavascript").Scalar;
// exports.p = ;
// BN254's prime p
const Fr = new F1Field(Scalar.fromString("21888242871839275222246405745257275088548364400416034343698204186575808495617"));

const wasm_tester = require("circom_tester").wasm;

const assert = chai.assert;

describe("comparators test", function () {
    this.timeout(100000);

    it("compilation tests", async() => {
        let files = [
            "ToLessThanConstant_10.circom",
        ];
        for(let fileIdx in files) {
            const _ = await wasm_tester(
                path.join(__dirname, files[fileIdx]),
                {
                    "prime": "bn128",
                    "include": [ path.join(__dirname, "../../../src/circuits/") ],
                },
            );
        }
    });

    it("basic viability tests", async() => {
        const lt = await wasm_tester(
            path.join(__dirname, "LessThan_2.circom"),
            {
                "prime": "bn128",
                "include": [ path.join(__dirname, "../../../src/circuits/") ],
            },
        );

        const le = await wasm_tester(
            path.join(__dirname, "LessEqThan_2.circom"),
            {
                "prime": "bn128",
                "include": [ path.join(__dirname, "../../../src/circuits/") ],
            },
        );

        const gt = await wasm_tester(
            path.join(__dirname, "GreaterThan_2.circom"),
            {
                "prime": "bn128",
                "include": [ path.join(__dirname, "../../../src/circuits/") ],
            },
        );

        const eq = await wasm_tester(
            path.join(__dirname, "IsEqual.circom"),
            {
                "prime": "bn128",
                "include": [ path.join(__dirname, "../../../src/circuits/") ],
            },
        );

        const neq = await wasm_tester(
            path.join(__dirname, "IsNotEqual.circom"),
            {
                "prime": "bn128",
                "include": [ path.join(__dirname, "../../../src/circuits/") ],
            },
        );

        const isnz = await wasm_tester(
            path.join(__dirname, "IsNonZero.circom"),
            {
                "prime": "bn128",
                "include": [ path.join(__dirname, "../../../src/circuits/") ],
            },
        );
        
        const isz = await wasm_tester(
            path.join(__dirname, "IsZero.circom"),
            {
                "prime": "bn128",
                "include": [ path.join(__dirname, "../../../src/circuits/") ],
            },
        );

        async function assertLessThan(i, j, isLessThan) {
            // console.log("LessThan(", i, ",", j, ")");

            let witness = await lt.calculateWitness({ "lhs": i, "rhs": j }, true);
            await lt.checkConstraints(witness);
            // witness[0] is always set to 1 by convention
            //assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)));
            // witness[1] is the value of the main output signal of the circuit
            //assert(Fr.eq(Fr.e(witness[1]), Fr.e(0)), "111 != 222");
            await lt.assertOut(witness, { out: isLessThan ? 1 : 0 });
        }

        async function assertLessEqThan(i, j, isLessEqThan) {
            // console.log("LessEqThan(", i, ",", j, ")");

            let witness = await le.calculateWitness({ "lhs": i, "rhs": j }, true);
            await le.checkConstraints(witness);
            await le.assertOut(witness, { out: isLessEqThan ? 1 : 0 });
        }

        async function assertGreaterThan(i, j, isGreaterThan) {
            // console.log("GreaterThan(", i, ",", j, ")");

            let witness = await gt.calculateWitness({ "lhs": i, "rhs": j }, true);
            await gt.checkConstraints(witness);
            await gt.assertOut(witness, { out: isGreaterThan ? 1 : 0});
        }

        async function assertIsEqual(i, j, isEq) {
            // console.log("IsEqual(", i, ",", j, ")");

            let witness = await eq.calculateWitness({ "lhs": i, "rhs": j }, true);
            await eq.checkConstraints(witness);
            await eq.assertOut(witness, { out: isEq ? 1 : 0 });
        }

        async function assertIsNotEqual(i, j, isNeq) {
            // console.log("IsNotEqual(", i, ",", j, ")");

            let witness = await neq.calculateWitness({ "lhs": i, "rhs": j }, true);
            await neq.checkConstraints(witness);
            await neq.assertOut(witness, { out: isNeq ? 1 : 0 });
        }

        async function assertIsZero(i, isZero) {
            // console.log("IsZero(", i, ")");

            let witness = await isz.calculateWitness({ "in": i }, true);
            await isz.checkConstraints(witness);
            await isz.assertOut(witness, { out: isZero ? 1 : 0 });
        }

        async function assertIsNonZero(i, isNz) {
            // console.log("IsNonZero(", i, ")");

            let witness = await isnz.calculateWitness({ "in": i }, true);
            await isnz.checkConstraints(witness);
            await isnz.assertOut(witness, { out: isNz ? 1 : 0 });
        }

        // test p-1
        await assertIsZero(Fr.e("-1"), 0);
        await assertIsNonZero(Fr.e("-1"), 1);

        for(var i = 0; i < 4; i++) {
            for(var j = 0; j < 4; j++) {
                await assertIsZero(i, i == 0);
                await assertIsNonZero(i, i != 0);

                await assertLessThan(i, j, i < j);
                await assertLessThan(j, i, j < i);

                await assertLessEqThan(i, j, i <= j);
                await assertLessEqThan(j, i, j <= i);

                await assertGreaterThan(i, j, i > j);
                await assertGreaterThan(j, i, j > i);

                await assertIsEqual(i, j, i == j);
                await assertIsNotEqual(i, j, i != j);
            }
        }
    });
});
