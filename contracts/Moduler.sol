pragma solidity ^0.4.21;

import "./lifecycle/Destructible.sol";

import "./LockableToken.sol";
import "./math/SafeMath.sol";

/**
 * @title Moduler
 * @dev Moduler is a base destructible contract 
 * to assist token managements
 */
contract Moduler is Destructible {
    using SafeMath for uint256;

    event Confiscated(address _recipient, uint256 _refund);

    // ERC20 basic token contract being held    
    LockableToken public token;

    constructor(LockableToken _token) 
        public
    {
        token = _token;
    }

    /**
    * @dev Replace token 
    * @param token address of ERC20 token which is being managed
    */
    function setToken(address _tokenAddr) 
        external 
        onlyOwner
    {
        require(_tokenAddr != 0x0);

        token = LockableToken(_tokenAddr);
    }

    /**
    * @dev Get current token balance of module
    */
    function getTokenBalance() 
        external
        view
        onlyOwner
        returns(uint256)
    {
        return token.balanceOf(this);
    }

    /**
    * @dev Get current token owner
    */
    function getTokenOwner()
        public
        view
        returns(address)
    {
        return token.owner();
    }

    /**
    * @dev Get ownership of token
    */
    function hasTokenOwnership()
        public
        view
        returns (bool)
    {
        return token.owner() == address(this);
    }

    /**
    * @dev Transfers the current ownership to the owner and terminates the contract.
    */
    function reclaimOwnership()
        public
        onlyOwner
        returns(bool)
    {
        return reclaimOwnershipTo(owner);
    }

    /**
    * @dev Transfers the current ownership to the specific recipient and terminates the contract.
    * @param _recipient address of the recipient to whom reclaimed token ownership
    */
    function reclaimOwnershipTo(address _recipient)
        public
        onlyOwner
        returns(bool)
    {
        token.transferOwnership(_recipient);
        return true;
    }

    /**
    * @dev Transfers the current balance to the owner and terminates the contract.
    */
    function reclaimFunds()
        public
        onlyOwner
        returns(bool)
    {
        return reclaimFundsTo(owner);
    }

    /**
    * @dev Transfers the current balance to the specific recipient and terminates the contract.
    * @param _recipient address of the recipient to whom reclaimed token ownership
    */
    function reclaimFundsTo(address _recipient)
        public
        onlyOwner
        returns(bool)
    {
        require(_recipient != 0x0);

        token.transfer(_recipient, token.balanceOf(this));
        return true;
    }

    /**
    * @dev Destory and Transfers the current balance, ownership to the owner and terminates the contract.
    */
    function destroyWithRelease() 
        public 
        onlyOwner
        returns(bool)
    {
        destroyWithReleaseTo(owner);
        return true;
    }

    /**
    * @dev Destroy and Transfers the current balance, ownership to the specific recipient and terminates the contract.
    * @param _recipient address of the recipient to whom reclaimed token ownership, fund
    */
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
     * @dev Destroy this contract
     */
    function destroy() 
        public 
        onlyOwner
    {
        super.destroy();
    }

    /**
     * @dev Destroy this contract
     */
    function destroyAndSend(address _recipient)  
        public 
        onlyOwner 
    {
        super.destroyAndSend(_recipient);
    }
}
