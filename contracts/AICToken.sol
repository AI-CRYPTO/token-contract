pragma solidity ^0.4.21;

import './LockableToken.sol';

contract AICToken is LockableToken {

  string public constant name = "AICRYPTO";
  string public constant symbol = "AIC";
  uint32 public constant decimals = 18;

  uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));

  /**
  * @dev Constructor that gives msg.sender all of existing tokens.
  */
  constructor() public {
    totalSupply_ = INITIAL_SUPPLY;
    balances[msg.sender] = INITIAL_SUPPLY;
    emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
  }
}
