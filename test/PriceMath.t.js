const { expect, assert } = require("chai");
const hre = require("hardhat");
const {
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { assertHardhatInvariant } = require("hardhat/internal/core/errors");

describe("PriceMath Library", function () {
  async function PriceMathFixture() {
    const priceMath = await ethers.deployContract("TestPriceMath");
    return { priceMath };
  }
  describe("absDiff", function () {
    it("Should return the absolute difference between two unsigned integers", async function () {
      const { priceMath } = await loadFixture(PriceMathFixture);
      const bigNumber = 15;
      const smallNumber = 10;
      const result = await priceMath.absDiff(smallNumber, bigNumber);
      assert.equal(result, bigNumber - smallNumber);
    });
  });
  describe("relChange", function () {
    it("Should return the relative change from one value to another", async function () {
      const { priceMath } = await loadFixture(PriceMathFixture);
      const baseValue = 500e18;
      const relativeChange = 0.1; // 10%
      const newValue = baseValue - baseValue * relativeChange;
      const result = await priceMath.relChange(
        baseValue.toString(), // Passing strings for uint256 values is fun
        newValue.toString(), // Cmon try it sometime
        true
      );
      // 1000 bps = 10%, 50 is 10% of 500
      assert.equal(result, 1000);
    });
  });
  describe("signedRelChange", function () {
    it("Should return the signed relative change from one value to another", async function () {
      const { priceMath } = await loadFixture(PriceMathFixture);
      const baseValue = 500e18;
      const relativeChange = 0.1; // 10%
      const newValue = baseValue - baseValue * relativeChange;
      const result = await priceMath.signedRelChange(
        baseValue.toString(), // Passing strings for uint256 values is fun
        newValue.toString(), // Cmon try it sometime
        true
      );
      // 1000 bps = -10%, 50 is 10% of 500
      assert.equal(result, -1000);
    });
  });
  describe("addPerc", function () {
    it("Should return the value of an unsigned integer, `a`, after being increased by `p` percent (bps)", async function () {
      const { priceMath } = await loadFixture(PriceMathFixture);
      const baseValue = 500e18;
      const basisPoints = 1000; // Used when interacting with PriceMath functions
      const relativeChange = 0.1; // Used to be explicit
      const expectedValue = baseValue + baseValue * relativeChange;
      const result = await priceMath.addPerc(baseValue.toString(), basisPoints);
      // 1000 bps = -10%, 50 is 10% of 500
      assert.equal(result, expectedValue);
    });
  });
  describe("subPerc", function () {
    it("Should return the value of an unsigned integer, `a`, after being decreased by `p` percent (bps)", async function () {
      const { priceMath } = await loadFixture(PriceMathFixture);
      const baseValue = 500e18;
      const basisPoints = 1000;
      const relativeChange = 0.1;
      const expectedValue = baseValue - baseValue * relativeChange;
      const result = await priceMath.subPerc(baseValue.toString(), basisPoints);
      // 1000 bps = -10%, 50 is 10% of 500
      assert.equal(result, expectedValue);
    });
  });
});
