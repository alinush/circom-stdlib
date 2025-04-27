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

describe("Num2Bits test", function ()  {
    this.timeout(100000);
    
    let INCLUDE_PATH = path.join(__dirname, "../../../src/circuits/");

    it("BN254 works for 253 bits", async() => {
        const circuit = await wasm_tester(
            path.join(__dirname, "Num2Bits_253.circom"),
            { 
                "prime": "bn128",
                "include": [ INCLUDE_PATH ],
            },
        );
    });

    it("BN254 too small for 254 bits", async() => {
        try {
            await wasm_tester(
                path.join(__dirname, "Num2Bits_254.circom"),
                { 
                    "prime": "bn128",
                    "include": [ INCLUDE_PATH ],
                },
            );

            expect.fail("Expected to throw due to BN254 being too small, but it didn't");
        } catch (err) {
            expect(err.message).to.include("circom compiler error");
        }
    });

    it("BLS12-381 works for 254 bits", async() => {
        const circuit = await wasm_tester(
            path.join(__dirname, "Num2Bits_254.circom"),
            { 
                "prime": "bls12381",
                "include": [ INCLUDE_PATH ],
            },
        );
    });
});
