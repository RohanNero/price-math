//SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.26;

/**@title PriceMath
 * @author Rohan Nero
 * @notice This library contains a handful of arithmetic functions to aid developers when handling prices */
library PriceMath {
    /**@notice Returns the absolute change between two unsigned integers */
    function absDiff(uint256 a, uint256 b) public pure returns (uint256) {
        return a > b ? a - b : b - a;
    }

    /**@notice Returns the relative change between two unsigned integers
     *@dev Maximum change = 99.99% (9999 return value) Minimum change(excluding no change) = .01% (1 return value)
     *@param a The base Value
     *@param b The new value
     * @return The percentage change from a to b, scaled by 1e4 (basis points)
     */
    // function relChange(uint256 a, uint256 b) public pure returns (uint256) {
    //     uint diff = absDiff(a, b);
    //     return (diff * 1e4) / a;
    // }
    /**
     * @notice Calculates the relative change between two values
     * @dev Returns the percentage change in basis points (1/100th of a percent)
     * @dev Loss of precision can occur when using small integers (a < 10,000)
     * @param a The original value
     * @param b The new value
     * @param roundUp If true, round up the result by 0.01%
     * @return The relative change as a percentage in basis points
     */
    function relChange(
        uint256 a,
        uint256 b,
        bool roundUp
    ) public pure returns (uint256) {
        uint256 diff = absDiff(a, b);
        uint256 result = (diff * 1e4) / a;
        if (roundUp && (diff * 1e4) % a != 0) {
            result += 1;
        }
        return result;
    }

    /**
     * @notice Returns the signed relative change between two unsigned integers
     * @dev This function returns how much b has changed relative to the value of a
     * @dev A positive result indicates an increase, while a negative result indicates a decrease
     * @dev Maximum positive change = 99.99% (9999 return value) Maximum negative change = -99.99% (-9999 return value)
     * @param a The base value
     * @param b The new value
     * @param roundUp If true, round up the result by 0.01%
     * @return The percentage change from a to b, scaled by 1e4 (basis points)
     */
    // function signedRelChange(
    //     uint256 a,
    //     uint256 b
    // ) public pure returns (int256) {
    //     if (a == 0) {
    //         return b > 0 ? int256(type(int256).max) : int256(0);
    //     }
    //     int256 diff = int256(b) - int256(a);
    //     return (diff * 1e4) / int256(a);
    // }
    function signedRelChange(
        uint256 a,
        uint256 b,
        bool roundUp
    ) public pure returns (int256) {
        if (a == 0) {
            return b > 0 ? int256(type(int256).max) : int256(0);
        }

        int256 diff = int256(b) - int256(a);
        int256 result = (diff * 1e4) / int256(a);

        if (roundUp) {
            // Check if there's a remainder to decide if rounding is needed
            int256 remainder = (diff * 1e4) % int256(a);
            if (remainder != 0) {
                // If rounding up, consider whether diff is positive or negative
                if (
                    (diff > 0 && remainder > 0) || (diff < 0 && remainder < 0)
                ) {
                    result > 0 ? result += 1 : result -= 1;
                }
            }
        }

        return result;
    }

    /**
     * @notice Increases an amount by a given percentage
     * @dev The percentage is expressed as basis points (1/100th of a percent)
     * @param a The base amount
     * @param p The percentage to increase by, in basis points (1% = 100, 100% = 10000)
     * @return The amount increased by the specified percentage
     */
    function addPerc(uint256 a, uint256 p) public pure returns (uint256) {
        if (p == 0) return a;
        return a + ((a * p) / 10000);
    }

    /**
     * @notice Decreases an amount by a given percentage
     * @dev The percentage is expressed as basis points (1/100th of a percent)
     * @dev Can revert/overflow if value of `a * p` exceeds `type(uint256).max`
     * @param a The base amount
     * @param p The percentage to decrease by, in basis points (1% = 100, 100% = 10000)
     * @return The amount decreased by the specified percentage
     */
    function subPerc(uint256 a, uint256 p) public pure returns (uint256) {
        if (p == 0) return a;
        return a - ((a * p) / 10000);
    }
}
