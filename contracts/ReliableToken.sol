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
  modifier whenNotExceedLock(address _granted, uint256 _value) {
    uint256 lockedAmount = lockedAmountOf(_granted);
    uint256 balance = balanceOf(_granted);

    require(balance > lockedAmount && balance.sub(lockedAmount) >= _value);
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

    uint256 lockCount = _expiresAtList.length;
    if (lockCount > 0) {
      (uint256 lockAmountEach, uint256 remainder) = _lockAmount.divRemain(lockCount);
      if (lockAmountEach > 0) {
        for (uint i = 0; i < lockCount; i++) {
          if (i == (lockCount - 1) && remainder > 0)
            lockAmountEach = lockAmountEach.add(remainder);

          lock(_to, lockAmountEach, _expiresAtList[i]);  
        }
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

    uint256 lockCount = _expiresAtList.length;
    if (lockCount > 0) {
      (uint256 lockAmountEach, uint256 remainder) = _lockAmount.divRemain(lockCount);
      if (lockAmountEach > 0) {
        for (uint i = 0; i < lockCount; i++) {
          if (i == (lockCount - 1) && remainder > 0)
            lockAmountEach = lockAmountEach.add(remainder);

          lock(_to, lockAmountEach, _expiresAtList[i]);  
        }
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
