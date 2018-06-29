pragma solidity ^0.4.24;

import "./MintableToken.sol";
import "./BurnableToken.sol";

import "./contraint/Lockable.sol";
import "./lifecycle/Pausable.sol";

import "./math/SafeMath.sol";

/**
 * @title Lockable token
 * @dev ReliableTokenToken modified with lockable transfers.
 **/
contract ReliableToken is MintableToken, BurnableToken, Pausable, Lockable {

  using SafeMath for uint256;

  /**
   * @dev Modifier to make a function callable only when the contract is not paused.
   */
  modifier whenNotExceedLock(address _granted, uint256 _amount) {
    uint256 lockedAmount = lockedAmountOf(_granted);
    uint256 balanceAmount = balanceOf(_granted);

    require(balanceAmount > lockedAmount && balanceAmount.sub(lockedAmount) >= _amount);
    _;
  }

  function transfer
  (
    address _to,
    uint256 _value
  )
    public
    whenNotPaused
    whenNotExceedLock(msg.sender, _value)
    returns (bool)
  {
    return super.transfer(_to, _value);
  }

  function transferLocked
  (
    address _to, 
    uint256 _value,
    uint256 _lockAmount,
    uint256[] _expiresAtList
  ) 
    public 
    whenNotPaused
    whenNotExceedLock(msg.sender, _value)
    onlyOwnerOrAdmin(ROLE_LOCKUP)
    returns (bool) 
  {
    require(_value >= _lockAmount);

    uint256 count = _expiresAtList.length;
    if (count > 0) {
      uint256 devidedAmount = _lockAmount.div(count);
      for (uint i = 0; i < count; i++) {
        lock(_to, devidedAmount, _expiresAtList[i]);  
      }
    }

    return transfer(_to, _value);
  }

  function transferFrom
  (
    address _from,
    address _to,
    uint256 _value
  )
    public
    whenNotPaused
    whenNotExceedLock(_from, _value)
    returns (bool)
  {
    return super.transferFrom(_from, _to, _value);
  }

  function transferLockedFrom
  (
    address _from,
    address _to, 
    uint256 _value,
    uint256 _lockAmount,
    uint256[] _expiresAtList
  ) 
    public 
    whenNotPaused
    whenNotExceedLock(_from, _value)
    onlyOwnerOrAdmin(ROLE_LOCKUP)
    returns (bool) 
  {
    require(_value >= _lockAmount);

    uint256 count = _expiresAtList.length;
    if (count > 0) {
      uint256 devidedValue = _value.div(count);
      for (uint i = 0; i < count; i++) {
        lock(_to, devidedValue, _expiresAtList[i]);  
      }
    }

    return transferFrom(_from, _to, _value);
  }

  function approve
  (
    address _spender,
    uint256 _value
  )
    public
    whenNotPaused
    returns (bool)
  {
    return super.approve(_spender, _value);
  }

  function increaseApproval
  (
    address _spender,
    uint _addedValue
  )
    public
    whenNotPaused
    returns (bool success)
  {
    return super.increaseApproval(_spender, _addedValue);
  }

  function decreaseApproval
  (
    address _spender,
    uint _subtractedValue
  )
    public
    whenNotPaused
    returns (bool success)
  {
    return super.decreaseApproval(_spender, _subtractedValue);
  }

  function () external payable 
  {
    revert();
  }
}
