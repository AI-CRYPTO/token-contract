pragma solidity ^0.4.24;

import './BundableToken.sol';

contract TestToken is BundableToken {

  string public constant name = "Test Crypto";
  string public constant symbol = "TTC";
  uint32 public constant decimals = 18;

  constructor(address initialAccount, uint initialBalance) public {
    balances[initialAccount] = initialBalance;
    totalSupply_ = initialBalance;
    emit Transfer(0x0, initialAccount, initialBalance);
  }
}
