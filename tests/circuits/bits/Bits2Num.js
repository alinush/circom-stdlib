const chai = require("chai");
const path = require("path");
const F1Field = require("ffjavascript").F1Field;
const Scalar = require("ffjavascript").Scalar;
// BN254's prime p, but it doesn't affect circom_tester's config; need to manually pass in the prime
// exports.p = Scalar.fromString("21888242871839275222246405745257275088548364400416034343698204186575808495617");
//const Fr = new F1Field(exports.p);

const wasm_tester = require("circom_tester").wasm;

const assert = chai.assert;
const expect = chai.expect;

describe("Bits2Num test", function ()  {
    this.timeout(100000);
    
    let INCLUDE_PATH = path.join(__dirname, "../../../src/circuits/");

    it("compilation", async() => {
        const circuit = await wasm_tester(
            path.join(__dirname, "Bits2Num_253.circom"),
            { 
                "prime": "bn128",
                "include": [ INCLUDE_PATH ],
            },
        );
    });
});
