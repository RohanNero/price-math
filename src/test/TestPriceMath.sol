//SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.26;

import "../PriceMath.sol";

contract TestPriceMath {
    using PriceMath for uint256;

    function absDiff(uint256 a, uint256 b) public pure returns (uint256) {
        return PriceMath.absDiff(a, b);
    }

    function test(uint256 x) public pure returns (uint) {
        return x.absDiff(10);
    }

    function relChange(
        uint256 a,
        uint256 b,
        bool c
    ) public pure returns (uint256) {
        return PriceMath.relChange(a, b, c);
    }

    function signedRelChange(
        uint256 a,
        uint256 b,
        bool c
    ) public pure returns (int256) {
        return PriceMath.signedRelChange(a, b, c);
    }

    function addPerc(uint256 a, uint256 p) public pure returns (uint256) {
        return PriceMath.addPerc(a, p);
    }

    function subPerc(uint256 a, uint256 p) public pure returns (uint256) {
        return PriceMath.subPerc(a, p);
    }
}
