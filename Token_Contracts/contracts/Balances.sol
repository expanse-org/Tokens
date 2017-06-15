pragma solidity ^0.4.8;

contract Balances {
  // GLOBAL VARS
  address public root;

  uint public totalSupply;

  // EVENTS
  event BalanceAdj(address indexed Module, address indexed Account, uint Amount, string Polarity);
  event ModuleSet(address indexed Module, bool indexed Set);

  // MAPPINGS
  mapping(address=>bool) public modules;
  mapping(address=>uint) public balances;
  mapping (address => mapping (address => uint256)) allowed;

  // MODIFIERS
  modifier onlyModule(){
    if(modules[msg.sender] == true){ _ ;} else { throw; }
  }

  modifier onlyRoot(){
    if(root == msg.sender){ _ ;} else { throw; }
  }

  function () {
      //if ether is sent to this address, send it back.
      throw;
  }

  function Balances(uint256 _initialAmount){
    root = msg.sender;
    balances[msg.sender] = _initialAmount;
    totalSupply+=_initialAmount;
  }

  // GET BALANCE
  function getBalance(address _acct) returns(uint balance){
    return balances[_acct];
  }

  // UPDATE BALANCE FUNCTIONS
  function incBalance(address _acct, uint _val) onlyModule returns(bool success){
    balances[_acct]+=_val;
    BalanceAdj(msg.sender, _acct, _val, "+");
    return true;
  }

  function decBalance(address _acct, uint _val) onlyModule returns(bool success){
    balances[_acct]-=_val;
    BalanceAdj(msg.sender, _acct, _val, "-");
    return true;
  }

  // ALLOWED
  function getAllowance(address _owner, address _spender) returns(uint remaining){
    return allowed[_owner][_spender];
  }

  function setApprove(address _sender, address _spender, uint256 _value) onlyModule returns (bool success) {
      allowed[_sender][_spender] = _value;
      return true;
  }

  function decApprove(address _from, address _spender, uint _value) onlyModule returns (bool success){
    allowed[_from][_spender] -= _value;
    return true;
  }

  // GET MODULE
  function getModule(address _acct) returns (bool success){
    return modules[_acct];
  }

  // SET MODULE
  function setModule(address _acct, bool _set) onlyRoot returns(bool success){
    modules[_acct] = _set;
    ModuleSet(_acct, _set);
    return true;
  }

  function getTotalSupply() returns(uint){
      return totalSupply;
  }

  function incTotalSupply(uint _val) onlyRoot returns(bool success){
      totalSupply+=_val;
      return true;
  }

  function decTotalSupply(uint _val) onlyRoot returns(bool success){
      totalSupply-=_val;
      return true;
  }

  /* Administration Functions */

 function empty(address _sendTo) onlyRoot { if(!_sendTo.send(this.balance)) throw; }
 function kill() onlyRoot { selfdestruct(root); }
 function transferRoot(address _newOwner) onlyRoot { root = _newOwner; }

}
