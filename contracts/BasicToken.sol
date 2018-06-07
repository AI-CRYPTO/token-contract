pragma solidity ^0.4.21;

import "./ERC20Basic.sol";
import "./SafeMath.sol";

contract BasicToken is ERC20Basic {
    using SafeMath for uint256;

    mapping(address => uint256) balances;

    uint256 totalSupply_;

    /**
    * @dev total number of tokens in exsitence
    */
    function totalSupply() public view returns (uint256) {
        return totalSupply_;
    }

    function msgSender() 
        public
        view
        returns (address)
    {
        return msg.sender;
    }

    function transfer(
        address _to, 
        uint256 _value
    ) 
        public 
        returns (bool) 
    {
        require(_to != address(0));
        require(_to != msg.sender);
        require(_value <= balances[msg.sender]);
        
        _preValidateTransfer(msg.sender, _to, _value);

        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    /**
     * @dev Gets the balance of the specified address.
     * @return An uint256 representing the amount owned by the passed address.
     */
    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    }

    function _preValidateTransfer(
        address _from, 
        address _to, 
        uint256 _value
    ) 
        internal 
    {

    }
}