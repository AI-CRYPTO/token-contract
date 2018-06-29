pragma solidity ^0.4.24;

import './ReliableToken.sol';

contract TestToken is ReliableToken {

  string public constant name = "Test Crypto";
  string public constant symbol = "TTC";
  uint32 public constant decimals = 18;

  uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));

  constructor(address initialAccount, uint initialBalance) public {
    balances[initialAccount] = initialBalance;
    totalSupply_ = initialBalance;
    emit Transfer(0x0, initialAccount, initialBalance);
  }
}
