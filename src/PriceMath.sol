//SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.26;

/**@title PriceMath
 * @author Rohan Nero
 * @notice This library contains arithmetic related to prices */
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
    function relChange(uint256 a, uint256 b) public pure returns (uint256) {
        uint diff = absDiff(a, b);
        return (diff * 1e4) / a;
    }

    /**
     * @notice Returns the signed relative change between two unsigned integers
     * @dev This function returns how much b has changed relative to the value of a
     * @dev A positive result indicates an increase, while a negative result indicates a decrease
     * @dev Maximum positive change = 99.99% (9999 return value) Maximum negative change = -99.99% (-9999 return value)
     * @param a The base value
     * @param b The new value
     * @return The percentage change from a to b, scaled by 1e4 (basis points)
     */
    function signedRelChange(
        uint256 a,
        uint256 b
    ) public pure returns (int256) {
        if (a == 0) {
            return b > 0 ? int256(type(int256).max) : int256(0);
        }
        int256 diff = int256(b) - int256(a);
        return (diff * 1e4) / int256(a);
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
        return a + (a * p) / 10000;
    }

    /**
     * @notice Decreases an amount by a given percentage
     * @dev The percentage is expressed as basis points (1/100th of a percent)
     * @param a The base amount
     * @param p The percentage to decrease by, in basis points (1% = 100, 100% = 10000)
     * @return The amount decreased by the specified percentage
     */
    function subPerc(uint256 a, uint256 p) public pure returns (uint256) {
        if (p == 0) return a;
        return a - (a * p) / 10000;
    }
}
