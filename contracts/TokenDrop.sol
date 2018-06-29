pragma solidity ^0.4.24;

import "./Moduler.sol";

import "./ReliableToken.sol";

/**
 * @title TokenDrop
 * @dev TokenDrop is a token holder contract that will spread
 * locked tokens multiply
 */
contract TokenDrop is Moduler {

    /**
    * @dev Creates a contract that drop its initication balances of locked ERC20 token for gift
    * @param _token token of ERC20 token which is being managed
    */
    constructor(ReliableToken _token) 
        public
        Moduler(_token)
    {
    }

    /**
    * @dev Transfers tokens held by timelock to recipients multiply.
    * @param _toList address of the recipients to whom received tokens 
    * @param _amountEach uint256 the amount of tokens to be transferred
    * #param _expiresAtList release times
    */
    function spreadConditional(
        address[] _toList,
        uint256 _amountEach,
        uint256[] _expiresAtList
    )
        public
        onlyOwner
        returns (bool)
    {
        require(_toList.length > 0);
        require(_amountEach.mul(_toList.length) <= token.balanceOf(this));
        require(hasTokenOwnership());

        for (uint i = 0; i < _toList.length; i++ ) {
            token.transferLocked(_toList[i], _amountEach, _expiresAtList);
        }

        return true;
    }

    /**
    * @dev Transfers tokens to recipients multiply.
    * @param _toList address of the recipients to whom received tokens 
    * @param _amountEach uint256 the amount of tokens to be transferred
    */
    function spread(
        address[] _toList,
        uint256 _amountEach
    )
        public
        returns (bool)
    {
        require(_toList.length > 0);
        require(_amountEach.mul(_toList.length) <= token.balanceOf(this));

        for (uint i = 0; i < _toList.length; i++ ) {
            token.transfer(_toList[i], _amountEach);
        }

        return true;
    }

    /**
    * @dev Validate spread without condition.
    */
    function spreadValidation(
        address[] _toList,
        uint256 _amountEach
    )
        public
        view
        returns (bool)
    {
        return _toList.length > 0 && _amountEach.mul(_toList.length) <= token.balanceOf(this);
    }

    /**
    * @dev Validate spread with condition.
    */
    function spreadConditionalValidation(
        address[] _toList,
        uint256 _amountEach
    )
        public
        view
        returns (bool)
    {
        return spreadValidation(_toList, _amountEach) && hasTokenOwnership();
    }
}
