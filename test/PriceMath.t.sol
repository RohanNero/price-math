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
        result = PriceMath.relChange(10, 30, false);
        assertEq(
            result,
            20000,
            "The relative change from 10 to 30 should be 20000 basis points (200%)"
        );
    }

    /**@notice Uses any integer and a 5% increase from that integer's value as input: (x, x + (x * 5%)) or (x, x * 1.05)
     * @dev Since we increase x by 5%, the relative change should always equal 5% (500 bps)
     */
    function testFuzz_RelChange(uint x) public pure {
        ///@dev Bound lower `x` value to 10,000 since loss of precision can occur with smaller integers
        ///@dev Bound upper `x` value to `max value - 5%` to prevent overflow when increasing `x` by 5% for `z`
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
    // function testFuzz_SignedRelChange(uint x) public pure {
    //     ///@dev Bound lower `x` value to 10,000 since loss of precision can occur with smaller integers
    //     ///@dev Bound upper `x` value to `max value - 5%` to prevent overflow when increasing `x` by 5% for `z`
    //     uint256 y = bound(x, 10000, type(uint256).max / 1000);
    //     uint256 z = PriceMath.addPerc(y, 500);
    //     int256 result = PriceMath.signedRelChange(z, y, true);
    //     assertEq(-500, result, "Relative change should always be 5%");
    // }
}
