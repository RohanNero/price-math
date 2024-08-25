## Price Math

This repo consists of a Solidity library called `PriceMath.sol`. This library contains a handful of arithmetic functions to aid developers when handling prices.

## Tests

There are foundry and hardhat unit tests, as well as some foundry fuzz tests.

Foundry:

```bash
forge test
```

Hardhat:

```bash
npx hardhat test
```

## Functions

Listed below are all of the functions inside `PriceMath`, which are all marked `internal pure`.

### absDiff

Returns the absolute change between two unsigned integers

```solidity
absDiff(uint256 a, uint256 b) returns(uint256)
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

## Considerations

Some functions, such as `addPerc` and `subPerc` are susceptible to overflow when provided large integer values. We could circumvent this issue by dividing the integers by a `1eX` value, the only trade-off is we lose some precision.
