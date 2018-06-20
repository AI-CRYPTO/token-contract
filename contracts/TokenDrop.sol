pragma solidity ^0.4.21;

import "./Moduler.sol";

import "./LockableToken.sol";

contract TokenDrop is Moduler {

    constructor(LockableToken _token) 
        public
        Moduler(_token)
    {
    }

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
            token.transferWithLock(_toList[i], _amountEach, _expiresAtList);
        }

        return true;
    }

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
