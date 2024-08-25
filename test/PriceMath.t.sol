// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {PriceMath} from "../src/PriceMath.sol";

/**@notice Tests to ensure the PriceMath library functions correctly */
contract PriceMathTest is Test {
    /**@notice Tests two pairs of hard-coded values */
    function testAbsDiff() public pure {
        uint256 result = PriceMath.absDiff(10, 15);
        assertEq(
            result,
            5,
            "The absolute difference between 10 and 15 should be 5"
        );
        result = PriceMath.absDiff(20, 10);
        assertEq(
            result,
            10,
            "The absolute difference between 20 and 10 should be 10"
        );
    }

    /**@notice Uses any unsigned integer and double that integers value as input: (x, 2x) */
    function testFuzz_AbsDiff(uint256 x) public pure {
        ///@dev Bound upper x value to `max value / 2` to prevent overflow when we multiply by 2 for `z`
        uint256 y = bound(x, 0, type(uint256).max / 2);
        uint256 z = y * 2;
        uint256 result = PriceMath.absDiff(y, z);
        assertEq(
            y,
            result,
            "The absolute difference between x and 2x should always be x"
        );
    }

    /**@notice Tests two pairs of hard-coded values */
    function testRelChange() public pure {
        uint256 result = PriceMath.relChange(100, 150, false);
        assertEq(
            result,
            5000,
            "The relative change from 100 to 150 should be 5000 basis points (50%)"
        );
        result = PriceMath.relChange(10, 50, false);
        assertEq(
            result,
            40000,
            "The relative change from 10 to 50 should be 40000 basis points (400%)"
        );
    }

    /**@notice Uses any integer and a 5% increase from that integer's value as input: (x, x + (x * 5%)) or (x, x * 1.05)
     * @dev Since we increase x by 5%, the relative change should always equal 5% (500 bps)
     */
    function testFuzz_RelChange(uint x) public pure {
        ///@dev Bound lower `x` value to 10,000 since loss of precision can occur with smaller integers
        ///@dev Bound upper `x` value to `max value / 1000` to prevent overflow when calling `addPerc()`
        uint256 y = bound(x, 10000, type(uint256).max / 1000);
        uint256 z = PriceMath.addPerc(y, 500);
        uint256 result = PriceMath.relChange(y, z, true);
        assertEq(500, result, "Relative change should always be 5%");
    }

    /**@notice Tests two pairs of hard-coded values
     * @dev sets `roundUp` to true
     */
    function testSignedRelChange() public pure {
        int256 result = PriceMath.signedRelChange(10, 30, true);
        assertEq(
            result,
            20000,
            "The percentage change from 10 to 30 should be 20000 basis points (200%)"
        );

        result = PriceMath.signedRelChange(30, 10, true);
        assertEq(
            result,
            -6667,
            "The percentage change from 30 to 10 should be -6667 basis points (-66.67%)"
        );
    }

    /**@notice Uses any integer and a 5% decrease from that integer's value as input: (x, x - (x * 5%)) or (x, x * -1.05)
     * @dev Since we decrease x by 5%, the relative change should always equal 5% (500 bps)
     */
    function testFuzz_SignedRelChange(uint x) public pure {
        ///@dev Bound lower `x` value to 10,000 since loss of precision can occur with smaller integers
        ///@dev Bound upper `x` value to `max value / 1000` to prevent overflow when calling `subPerc()`
        uint256 y = bound(x, 10000, type(uint256).max / 1000);
        uint256 z = PriceMath.subPerc(y, 500);
        int256 result = PriceMath.signedRelChange(y, z, true);
        assertEq(-500, result, "Relative change should always be 5%");
    }

    /**@notice Uses two pairs of hard-coded values */
    function test_addPerc() public pure {
        uint result = PriceMath.addPerc(100, 500);
        assertEq(105, result, "5% increase from 100 should equal 105");

        result = PriceMath.addPerc(2000, 2500);
        assertEq(2500, result, "25% increase from 2,000 should equal 2500");
    }

    /**@notice Tests `addPerc()` by asserting that `x` increased by `10000` (100%), will always equal 2x */
    function testFuzz_addPerc(uint256 x) public pure {
        ///@dev Bound upper x value to `max value / 10,000` to prevent `addPerc()` from overflowing
        ///@dev Bound lower x value to 1 since we are expecting `result` = 2x
        uint y = bound(x, 1, type(uint256).max / 10000);
        uint result = PriceMath.addPerc(y, 10000);
        assertEq(result, y * 2, "A 100% increase should double the value of x");
    }

    /**@notice Ues two pairs of hard-coded values */
    function test_subPerc() public pure {
        uint result = PriceMath.subPerc(100, 500);
        assertEq(result, 95, "100 decreased by 5% should equal 95");

        result = PriceMath.subPerc(4000000, 5000);
        assertEq(
            result,
            2000000,
            "4 million decreased by 50% should equal 2 million"
        );
    }

    /**@notice Tests `subPerc()` by asserting that `x` decreased by `2500` (25%), will always equal .25x */
    function testFuzz_subPerc(uint256 x) public pure {
        ///@dev Bound upper x value to `max value / 10,000` to prevent `subPerc` from overflowing
        ///@dev Bound lower x value to `4` since anything we decrease x by 25%
        uint y = bound(x, 2, type(uint256).max / 10000);
        uint z = y - (y / 4);
        uint result = PriceMath.subPerc(y, 2500);
        assertEq(result, z, "A 25% decrease should equal x - .25x");
    }
}
