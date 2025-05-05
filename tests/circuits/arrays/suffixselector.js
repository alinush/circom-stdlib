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

describe("SuffixSelector test", function ()  {
    this.timeout(100000);

    it("SuffixSelector_4", async() => {
        const circuit = await wasm_tester(
            path.join(__dirname, "SuffixSelector_4_notags.circom"),
            {
                "prime": "bn128",
                "O": 1,
                "include": [ path.join(__dirname, "../../../src/circuits/") ],
            },
        );

        async function assertOutput(idx, selector) {
            // console.log("SuffixSelector_4(", idx, ")");

            let witness = await circuit.calculateWitness({ "idx": idx }, true);
            await circuit.checkConstraints(witness);
            // console.log("---");
            
            // console.log("%d constraints, %d vars", circuit.constraints.length, circuit.nVars);
            // console.log(await circuit.getDecoratedOutput(witness));
            // console.log(witness);
            
            // console.log("---");
            await circuit.assertOut(witness, { selector: selector });
        };

        await assertOutput(0, [1, 1, 1, 1]);
        await assertOutput(1, [0, 1, 1, 1]);
        await assertOutput(2, [0, 0, 1, 1]);
        await assertOutput(3, [0, 0, 0, 1]);
        await assertOutput(4, [0, 0, 0, 0]);

        // Test some bad witnesses
        //
        // The order of the variables in the witness
        // Example for idx = 4
        // [0] ==> 1
        // [1] ==> main.selector[0] --> 0
        // [2] ==> main.selector[1] --> 0
        // [3] ==> main.selector[2] --> 0
        // [4] ==> main.selector[3] --> 0
        // [5] ==> main.idx --> 4
        // [6] ==> main.SuffixSelector_14_289.idxSelector[1] --> 0
        // [7] ==> main.SuffixSelector_14_289.idxSelector[2] --> 0
        // [8] ==> main.SuffixSelector_14_289.idxSelector[3] --> 0
        // [9] ==> main.SuffixSelector_14_289.success --> 0
        //          \---> = selector[0] + \sum_{i=1}^3 idxSelector[i]
        // [10] ==> main.SuffixSelector_14_289.idxIsN --> 1
        // [11] ==> main.SuffixSelector_14_289.IsEqual_71_2222.IsZero_20_401.in --> 0
        //          \---> idx - N
        // [12] ==> main.SuffixSelector_14_289.IsEqual_71_2222.IsZero_20_401.inv --> 0
        //
        // e.g., confirming below
        //           |   |
        //           v   v
        let witness = [
            1, 0, 0, 0, 0, 4,
            0, 0, 0, 0, 1, 0,
            0
        ];
        assert(witness.length == 13);
        await circuit.checkConstraints(witness);

        let badWitnesses = [
            [1, 1, 0, 0, 0, 4, 0, 0, 0, 0, 1, 0, 0],
            //   ^                       ^
            //    \                       \---> sum should constrain selector[0]
            //     \---- selector[0] mis-set to 1
            [1, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, Fr.e("-1"), Fr.e("-1")],
            //                          ^  ^
            //                           \  \---> idxIsN == false
            //                            \-----> success == 0    
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