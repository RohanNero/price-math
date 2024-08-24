## Price Math

This repo consists of a Solidity library called `PriceMath.sol`. This library contains a handful of arithmetic functions to aide developers when handling prices.

### absDiff

Returns the absolute change between two unsigned integers

```solidity
absDiff(uint256 a, uint256 b) returns(uint256) {};
```

### relChange

Returns the relative change between two unsigned integers

```solidity
relChange(uint256 a, uint256 b) returns(uint256)
```

### signedRelChange

Returns the signed relative change between two unsigned integers

```solidity
signedRelChange(uint256 a, uint256 b) returns(int256)
```

### addPerc

Increases an amount by a given percentage

```solidity
addPerc(uint256 a, uint256 p) returns(uint256)
```

### subPerc

Decreases an amount by a given percentage

```solidity
subPerc(uint256 a, uint256 p) returns(uint256)
```
