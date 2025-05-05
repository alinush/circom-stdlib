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

describe("PrefixSelector test", function ()  {
    this.timeout(100000);

    it("PrefixSelector_4", async() => {
        const circuit = await wasm_tester(
            path.join(__dirname, "PrefixSelector_4_notags.circom"),
            {
                "prime": "bn128",
                "O": 1,
                "include": [ path.join(__dirname, "../../../src/circuits/") ],
            },
        );

        async function assertOutput(idx, selector) {
            // console.log("PrefixSelector_4(", idx, ")");

            let witness = await circuit.calculateWitness({ "idx": idx }, true);
            await circuit.checkConstraints(witness);
            // console.log("---");
            
            // console.log("%d constraints, %d vars", circuit.constraints.length, circuit.nVars);
            // console.log(await circuit.getDecoratedOutput(witness));
            // console.log(witness);
            
            // console.log("---");
            await circuit.assertOut(witness, { selector: selector });
        };

        // await assertOutput(0, [0, 0, 0, 0]);
        // await assertOutput(1, [1, 0, 0, 0]);
        // await assertOutput(2, [1, 1, 0, 0]);
        // await assertOutput(3, [1, 1, 1, 0]);
        await assertOutput(4, [1, 1, 1, 1]);

        // Test some bad witnesses
        //
        // The order of the variables in the witness
        // Example for idx = 4
        // [0] ==> 1
        // [1] ==> main.selector[0] --> 1
        // [2] ==> main.selector[1] --> 1
        // [3] ==> main.selector[2] --> 1
        // [4] ==> main.selector[3] --> 1
        // [5] ==> main.idx --> 4
        // [6] ==> main.PrefixSelector_14_289.idxSelectorNeg[0] --> 0
        // [7] ==> main.PrefixSelector_14_289.idxSelectorNeg[1] --> 0
        // [8] ==> main.PrefixSelector_14_289.idxSelectorNeg[2] --> 0
        // [9] ==> main.PrefixSelector_14_289.idxSelectorNeg[3] --> 0
        // [10] ==> main.PrefixSelector_14_289.success --> 0
        //          \---> = \sum_{i=0}^3 idxSelectorNeg[i]
        // [11] ==> main.PrefixSelector_14_289.idxIsN --> 1
        // [12] ==> main.PrefixSelector_14_289.IsEqual_71_2222.IsZero_20_401.in --> 0
        //          \---> idx - N
        // [13] ==> main.PrefixSelector_14_289.IsEqual_71_2222.IsZero_20_401.inv --> 0
        //
        // e.g., confirming below
        //           |   |
        //           v   v
        let witness = [
            1, 1, 1, 1, 1, 4,
            0, 0, 0, 0, 0, 1,
            0, 0
        ];
        assert(witness.length == 14);
        await circuit.checkConstraints(witness);

        let badWitnesses = [
            [1, 0, 1, 1, 1, 4, 0, 0, 0, 0, 0, 1, 0, 0],
            //   ^                            ^
            //    \                            \---> idxIsN == true 
            //     \---- selector[0] mis-set to 0
            [1, 1, 1, 1, 1, 5, 0, 0, 0, 0, 0, 0, Fr.e("-1"), Fr.e("-1")],
            //                             ^  ^
            //                              \  \---> idxIsN == false
            //                               \-----> success == 0
        ];
        
        for(const [i, witness] of badWitnesses.entries()) {
            try {
                // console.log("Bad witness[", i, "]:", witness);
                await circuit.checkConstraints(witness);
                
                expect.fail("Expected to throw due to bad witness");
            } catch (err) {
                expect(err.message).to.include("Constraint doesn't match");
            }
        }
    });
});