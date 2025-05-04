const chai = require("chai");
const path = require("path");
const F1Field = require("ffjavascript").F1Field;
const Scalar = require("ffjavascript").Scalar;
// exports.p = ;
// BN254's prime p
const Fr = new F1Field(Scalar.fromString("21888242871839275222246405745257275088548364400416034343698204186575808495617"));

const wasm_tester = require("circom_tester").wasm;

const assert = chai.assert;
const expect = chai.expect;

describe("arrays test", function ()  {
    this.timeout(100000);

    it("IndexSelector_4 in-range", async() => {
        const circuit = await wasm_tester(
            path.join(__dirname, "IndexSelector_4.circom"),
            {
                "prime": "bn128",
                "O": 1,
                "include": [ path.join(__dirname, "../../../src/circuits/") ],
            },
        );

        async function assertOutput(idx, selector) {
            // console.log("IndexSelector_4(", idx, ")");

            let witness = await circuit.calculateWitness({ "idx": idx }, true);
            await circuit.checkConstraints(witness);
            // console.log(witness);
            // console.log(witness[1], witness[2], witness[3], witness[4]);
            await circuit.assertOut(witness, { selector: selector });
        }

        await assertOutput(0, [1, 0, 0, 0]);
        await assertOutput(1, [0, 1, 0, 0]);
        await assertOutput(2, [0, 0, 1, 0]);
        await assertOutput(3, [0, 0, 0, 1]);
    });

    it("IndexSelector_4_notags out-of-range", async() => {
        const circuit = await wasm_tester(
            path.join(__dirname, "IndexSelector_4_notags.circom"),
            {
                "prime": "bn128",
                "O": 1,
                "include": [ path.join(__dirname, "../../../src/circuits/") ],
            },
        );

        // The idx will be maliciously tagged as < 4, and we want to ensure that
        // the success === 1 constraint will not be satisfiable in this case
        try {
            let _ = await circuit.calculateWitness({ "idx": 4 }, true);
            
            expect.fail("Expected to throw due to idx being too large, but it didn't");
        } catch (err) {
            expect(err.message).to.include("Error: Assert Failed");
            expect(err.message).to.include("Error in template IndexSelector_0 line");
        }

        // Tests that makes sure that the idx is at the correct location

        // e.g., correct example for idx == 0
        witness = [1, 1, 0, 0, 0, 0];
        await circuit.checkConstraints(witness);
        // e.g., correct example for idx == 1
        witness = [1, 0, 1, 0, 0, 1];
        await circuit.checkConstraints(witness);
        // e.g., correct example for idx == 1
        witness = [1, 0, 0, 1, 0, 2];
        await circuit.checkConstraints(witness);

        // if idx == 1, then selector[1] has to be 1
        // this tests that the constraints fail when all selector[i]'s are 0
        try {
            witness = [1, 0, 0, 0, 0, 1];
            //               ^
            //                \--- selector[1]
            await circuit.checkConstraints(witness);
            
            expect.fail("Expected to throw due to incorrect selector[1], but it didn't");
        } catch (err) {
            expect(err.message).to.include("Constraint doesn't match");
        }

        // if idx == 1, then selector[1] has to be 1
        // this tests that the constraints fail when selector[1] = 0 but selector[2] = 1
        try {
            witness = [1, 0, 0, 1, 0, 1];
            //               ^  ^
            //                \  \--- selector[2]
            //                 \
            //                  \--- selector[1]
            await circuit.checkConstraints(witness);
            
            expect.fail("Expected to throw due to incorrect selector[1], but it didn't");
        } catch (err) {
            expect(err.message).to.include("Constraint doesn't match");
        }
    });
});