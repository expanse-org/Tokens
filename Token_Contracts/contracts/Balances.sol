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
    if(modules[msg.sender] == true){ _ ;} else { revert(); }
  }

  modifier onlyRoot(){
    if(root == msg.sender){ _ ;} else { revert(); }
  }

  constructor(address reserve, uint premine) public {
    root = msg.sender;

    uint premineInWei = premine * 1 ether;

    incBalance(reserve, premineInWei);
    incTotalSupply(premineInWei);

  }

  // GET BALANCE
  function getBalance(address _acct) view public returns(uint balance){
    return balances[_acct];
  }

  // UPDATE BALANCE FUNCTIONS
  function incBalance(address _acct, uint _val) public onlyModule returns(bool success){
    balances[_acct]+=_val;
    emit BalanceAdj(msg.sender, _acct, _val, "+");
    return true;
  }

  function decBalance(address _acct, uint _val) public onlyModule returns(bool success){
    balances[_acct]-=_val;
    emit BalanceAdj(msg.sender, _acct, _val, "-");
    return true;
  }

  // ALLOWED
  function getAllowance(address _owner, address _spender) view public returns(uint remaining){
    return allowed[_owner][_spender];
  }

  function setApprove(address _sender, address _spender, uint256 _value) public onlyModule returns (bool success) {
      allowed[_sender][_spender] = _value;
      return true;
  }

  function decApprove(address _from, address _spender, uint _value) public onlyModule returns (bool success){
    allowed[_from][_spender] -= _value;
    return true;
  }

  // GET MODULE
  function getModule(address _acct) view public returns (bool){
    return modules[_acct];
  }

  // SET MODULE
  function setModule(address _acct, bool _set) public onlyRoot returns(bool success, address module, bool set){
    modules[_acct] = _set;
    emit ModuleSet(_acct, _set);
    return (true, _acct, _set);
  }

  function getTotalSupply() view public returns(uint){
      return totalSupply;
  }

  function incTotalSupply(uint _val) public onlyModule returns(bool success){
      totalSupply+=_val;
      return true;
  }

  function decTotalSupply(uint _val) public onlyModule returns(bool success){
      totalSupply-=_val;
      return true;
  }

  /* Administration Functions */

 function empty(address _sendTo) public onlyRoot { if(!_sendTo.send(address(this).balance)) revert(); }
 function kill() public onlyRoot { selfdestruct(root); }
 function transferRoot(address _newOwner) public onlyRoot { root = _newOwner; }

}
