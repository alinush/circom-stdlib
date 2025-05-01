const chai = require("chai");
const path = require("path");
const F1Field = require("ffjavascript").F1Field;
const Scalar = require("ffjavascript").Scalar;
// exports.p = ;
// BN254's prime p
const Fr = new F1Field(Scalar.fromString("21888242871839275222246405745257275088548364400416034343698204186575808495617"));

const wasm_tester = require("circom_tester").wasm;

const assert = chai.assert;

describe("polynomials test", function ()  {
    this.timeout(100000);

    it("compilation tests", async() => {
        let files = [
            "PowersOfTau_4.circom",
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
});