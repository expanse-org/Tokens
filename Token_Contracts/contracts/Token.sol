/*
Implements modular EIP20 token standard ERC644: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
.*/


pragma solidity ^0.4.21;

import"./Balances.sol";

contract ERC644 {

    // solhint-disable-next-line no-simple-event-func-name
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    uint256 constant private MAX_UINT256 = 2**256 - 1;

    Balances public balances;

    string public name;                   //fancy name: eg Franko Bucks
    uint8 public decimals;                //How many decimals to show.
    string public symbol;                 //An identifier: eg FRK

    constructor(address _balances, string _name, string _symbol, uint8 _dec) public {
        balances = Balances(_balances);
        name = _name;                                   // Set the name for display purposes
        decimals = _dec;                            // Amount of decimals for display purposes
        symbol = _symbol;                               // Set the symbol for display purposes
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balances.getBalance(msg.sender) >= _value);
        balances.decBalance(msg.sender, _value);
        balances.incBalance(_to, _value);
        emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        uint256 allowance = balances.getAllowance(_from, msg.sender);
        require(balances.getBalance(_from) >= _value && allowance >= _value);
        balances.incBalance(_to, _value);
        balances.decBalance(_from, _value);
        if (allowance < MAX_UINT256) {
            balances.decApprove(_from, msg.sender, _value);
        }
        emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
        return true;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances.getBalance(_owner);
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
      //allowed[msg.sender][_spender] = _value;
      balances.setApprove(msg.sender, _spender, _value);
      emit Approval(msg.sender, _spender, _value);
      return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
      return balances.getAllowance(_owner, _spender);
    }

    function totalSupply() public view returns(uint256){
      return balances.getTotalSupply();
    }
}
