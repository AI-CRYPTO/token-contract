pragma solidity ^0.4.21;

import "./MintableToken.sol";

import "./SafeMath.sol";

contract LockableToken is MintableToken {

    using SafeMath for uint256;

    /**
     * @dev Lock defines a lock of token
     */
    struct Lock {
        uint256 amount;
        uint256 expiresAt;
    }

    // granted to locks;
    mapping (address => Lock[]) public grantedLocks;

    function addLock(
        address _granted, 
        uint256 _amount, 
        uint256 _expiresAt
    ) 
        public 
        onlyOwner 
    {
        require(_amount > 0);
        require(_expiresAt > now);

        grantedLocks[_granted].push(Lock(_amount, _expiresAt));
    }

    function deleteLock(
        address _granted, 
        uint8 _index
    ) 
        public 
        onlyOwner 
    {
        Lock storage lock = grantedLocks[_granted][_index];

        delete grantedLocks[_granted][_index];
        for (uint i = _index; i < grantedLocks[_granted].length - 1; i++) {
            grantedLocks[_granted][i] = grantedLocks[_granted][i+1];
        }
        grantedLocks[_granted].length--;

        if (grantedLocks[_granted].length == 0)
            delete grantedLocks[_granted];
    }

    function transferWithLock(
        address _to, 
        uint256 _value,
        uint256[] _expiresAtList
    ) 
        public 
        onlyOwner
        returns (bool) 
    {
        require(_to != address(0));
        require(_to != msg.sender);
        require(_value <= balances[msg.sender]);

        uint256 count = _expiresAtList.length;
        if (count > 0) {
            uint256 devidedValue = _value.div(count);
            for (uint i = 0; i < count; i++) {
                addLock(_to, devidedValue, _expiresAtList[i]);  
            }
        }

        return transfer(_to, _value);
    }

    /**
        @param _from - _granted
        @param _to - no usable
        @param _value - amount of transfer
     */
    function _preValidateTransfer(
        address _from, 
        address _to, 
        uint256 _value
    ) 
        internal
    {
        super._preValidateTransfer(_from, _to, _value);
        
        uint256 lockedAmount = getLockedAmount(_from);
        uint256 balanceAmount = balanceOf(_from);

        require(balanceAmount.sub(lockedAmount) >= _value);
    }


    function getLockedAmount(
        address _granted
    ) 
        public
        view
        returns(uint256)
    {

        uint256 lockedAmount = 0;

        Lock[] storage locks = grantedLocks[_granted];
        for (uint i = 0; i < locks.length; i++) {
            if (now < locks[i].expiresAt) {
                lockedAmount = lockedAmount.add(locks[i].amount);
            }
        }
        //uint256 balanceAmount = balanceOf(_granted);
        //return balanceAmount.sub(lockedAmount);

        return lockedAmount;
    }
    
}
