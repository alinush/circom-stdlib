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

describe("arrays benches", function ()  {
    this.timeout(100000);

    it("constraints", async() => {
        let files = [
            "ArrayGet_10_notags.circom",
            "ArrayGet_20_notags.circom",
            "IndexSelector_10_notags.circom",
            "IndexSelector_20_notags.circom",
            "SuffixSelector_10_notags.circom",
            "SuffixSelector_20_notags.circom",
            "PrefixSelector_10_notags.circom",
            "PrefixSelector_20_notags.circom",
        ];
        for(let fileIdx in files) {
            const circuit = await wasm_tester(
                path.join(__dirname, files[fileIdx]),
                {
                    "prime": "bn128",
                    "O": 1,
                    "include": [ path.join(__dirname, "../../../src/circuits/") ],
                },
            );
            
            await circuit.loadConstraints();
            console.log("%s: %d constraints, %d vars", files[fileIdx], circuit.constraints.length, circuit.nVars);
            // console.log();
        }
    });
});