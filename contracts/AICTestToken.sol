pragma solidity ^0.4.24;

import './EnhancedToken.sol';

contract AICTestToken is EnhancedToken {

  string public constant name = "AICRYPTO";
  string public constant symbol = "AIX";
  uint32 public constant decimals = 18;

  uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));

  /**
  * @dev Constructor that gives msg.sender all of existing tokens.
  */
  constructor() public 
  {
    totalSupply_ = INITIAL_SUPPLY;
    balances[msg.sender] = INITIAL_SUPPLY;
    emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
  }
}
