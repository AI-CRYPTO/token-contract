pragma solidity ^0.4.24;

import './BundableToken.sol';

contract EnhancedToken is BundableToken {
  /**
   * @dev Transfer tokens from one address to another forcibly with Owner authority 
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFromForcibly(
    address _from,
    address _to,
    uint256 _value
  )
    public
    onlyOwner
    returns (bool)
  {
    require(_to != address(0));
    require(_value <= balances[_from]);

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(_from, _to, _value);
    return true;
  }
}
