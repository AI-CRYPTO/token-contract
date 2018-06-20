pragma solidity ^0.4.21;

import "./lifecycle/Destructible.sol";

import "./LockableToken.sol";
import "./math/SafeMath.sol";

contract Moduler is Destructible {
    using SafeMath for uint256;

    event Confiscated(address _recipient, uint256 _refund);

    LockableToken public token;

    constructor(LockableToken _token) 
        public
    {
        token = _token;
    }

    function setToken(address _tokenAddr) 
        external 
        onlyOwner
    {
        require(_tokenAddr != 0x0);

        token = LockableToken(_tokenAddr);
    }

    function getTokenBalance() 
        external
        view
        onlyOwner
        returns(uint256)
    {
        return token.balanceOf(this);
    }

    function getTokenOwner()
        public
        view
        returns(address)
    {
        return token.owner();
    }

    function hasTokenOwnership()
        public
        view
        returns (bool)
    {
        return token.owner() == address(this);
    }

    function reclaimOwnership()
        public
        onlyOwner
        returns(bool)
    {
        return reclaimOwnershipTo(owner);
    }

    function reclaimOwnershipTo(address _recipient)
        public
        onlyOwner
        returns(bool)
    {
        token.transferOwnership(_recipient);
        return true;
    }

    function reclaimFunds()
        public
        onlyOwner
        returns(bool)
    {
        return reclaimFundsTo(owner);
    }

    function reclaimFundsTo(address _recipient)
        public
        onlyOwner
        returns(bool)
    {
        require(_recipient != 0x0);

        token.transfer(_recipient, token.balanceOf(this));
        return true;
    }

    function destroyWithRelease() 
        public 
        onlyOwner
        returns(bool)
    {
        destroyWithReleaseTo(owner);
        return true;
    }

    function destroyWithReleaseTo(address _recipient) 
        public 
        onlyOwner
        returns(bool)
    {
        require(_recipient != 0x0);

        reclaimOwnershipTo(_recipient);
        reclaimFundsTo(_recipient);
        destroyAndSend(_recipient);
        
        return true;
    }

    /**
    * @dev Transfers the current balance to the owner and terminates the contract.
    */
    function destroy() 
        public 
        onlyOwner
    {
        super.destroy();
    }

    function destroyAndSend(address _recipient)  
        public 
        onlyOwner 
    {
        super.destroyAndSend(_recipient);
    }
}
