pragma solidity ^0.4.23;

import "../ownership/Administrable.sol";

import "../math/SafeMath.sol";

/**
 * @title Lockable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
contract Lockable is Administrable {

  using SafeMath for uint256;

  event Locked(address _granted, uint256 _amount, uint256 _expiresAt);
  event UnlockedAll(address _granted);

  /**
  * @dev Lock defines a lock of token
  */
  struct Lock {
    uint256 amount;
    uint256 expiresAt;
  }

  // granted to locks;
  mapping (address => Lock[]) public grantedLocks;
  

  /**
   * @dev called by the owner to lock, triggers stopped state
   */
  function lock
  (
    address _granted, 
    uint256 _amount, 
    uint256 _expiresAt
  ) 
    onlyOwnerOrAdmin(ROLE_LOCKUP) 
    public 
  {
    require(_amount > 0);
    require(_expiresAt > now);

    grantedLocks[_granted].push(Lock(_amount, _expiresAt));

    emit Locked(_granted, _amount, _expiresAt);
  }

  /**
   * @dev called by the owner to unlock, returns to normal state
   */
  function unlock
  (
    address _granted
  ) 
    onlyOwnerOrAdmin(ROLE_LOCKUP) 
    public 
  {
    require(grantedLocks[_granted].length > 0);
    
    delete grantedLocks[_granted];
    emit UnlockedAll(_granted);
  }

  function lockedAmountOf
  (
    address _granted
  ) 
    public
    view
    returns(uint256)
  {
    require(_granted != address(0));
    
    uint256 lockedAmount = 0;
    uint256 lockedCount = grantedLocks[_granted].length;
    if (lockedCount > 0) {
      Lock[] storage locks = grantedLocks[_granted];
      for (uint i = 0; i < locks.length; i++) {
        if (now < locks[i].expiresAt) {
          lockedAmount = lockedAmount.add(locks[i].amount);
        } 
      }
    }

    return lockedAmount;
  }
}
