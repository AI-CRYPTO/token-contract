pragma solidity ^0.4.24;

import "./StandardToken.sol";

import "./ownership/Administrable.sol";

contract MintableToken is StandardToken, Administrable {
    event Mint(address indexed to, uint256 amount);
    event MintStarted();
    event MintFinished();

    bool public mintingFinished = false;

    modifier canMint() {
        require(!mintingFinished);
        _;
    }

    modifier cantMint() {
        require(mintingFinished);
        _;
    }
   
    /**
    * @dev Function to mint tokens
    * @param _to The address that will receive the minted tokens.
    * @param _amount The amount of tokens to mint
    * @return A boolean that indicated if the operation was successful.
    */
    function mint(address _to, uint256 _amount) onlyOwnerOrAdmin(ROLE_MINT) canMint public returns (bool) {
        totalSupply_ = totalSupply_.add(_amount);
        balances[_to] = balances[_to].add(_amount);
        emit Mint(_to, _amount);
        emit Transfer(address(0), _to, _amount);
        return true;
    }

    /**
     * @dev Function to start minting new tokens.
     * @return True if the operation was successful. 
     */
    function startMinting() onlyOwner cantMint public returns (bool) {
        mintingFinished = false;
        emit MintStarted();
        return true;
    }

    /**
     * @dev Function to stop minting new tokens.
     * @return True if the operation was successful. 
     */
    function finishMinting() onlyOwner canMint public returns (bool) {
        mintingFinished = true;
        emit MintFinished();
        return true;
    }
}

