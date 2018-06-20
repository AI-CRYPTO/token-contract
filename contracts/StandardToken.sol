pragma solidity ^0.4.21;

import "./BasicToken.sol";
import "./ERC20.sol";

import "./ownership/Ownable.sol";

contract StandardToken is ERC20, BasicToken, Ownable {

    mapping (address => mapping (address => uint256)) internal allowed;

    /**
    * @dev Transfer tokens from one address to another
    * @param _from address The address which you want to send tokens from
    * @param _to address the address which you want to transfer to
    * @param _value uint256 the amount of tokens to be transferred
    */
    function transferFrom(
        address _from, 
        address _to, 
        uint256 _value
    ) 
        public 
        returns (bool) 
    {
        require(_to != address(0));
        require(_value <= balances[_from]);
        require(_value <= allowed[_from][msg.sender]);

        _preValidateTransfer(_from, _to, _value);

        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].sub(_value);  
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        emit Transfer(_from, _to, _value);
        return true; 
    } 

    /**
    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
.   * @param _spender The address which will spend the funds.
    */
    function approve(address _spender, uint256 _value) public returns (bool) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    /**
     * @dev Function to check the amount of tokens that an owner allowed jto a spender. 
     */
    function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowed[_owner][_spender];
    }

/**
   * @dev Increase the amount of tokens that an owner allowed to a spender.
   *
   * approve should be called when allowed[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _addedValue The amount of tokens to increase the allowance by.
   */
    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }


    function decreseApproval(address _spender, uint _subtractedValue) public returns (bool) {
        uint oldValue = allowed[msg.sender][_spender];
        if (_subtractedValue > oldValue) {
            allowed[msg.sender][_spender] = 0;
        } else {
            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
        }

        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }

}