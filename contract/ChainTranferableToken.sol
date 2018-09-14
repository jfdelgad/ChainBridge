pragma solidity ^0.4.24;


/******************************************************************************************************* */
library SafeMath {
  /** @dev Multiplies two numbers, throws on overflow.*/
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {return 0;}
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  /** @dev Integer division of two numbers, truncating the quotient.*/
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a / b;
    return c;
  }

  /**@dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).*/
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /** @dev Adds two numbers, throws on overflow.*/
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }

}




/******************************************************************************************************* */
/* App interface */
contract App {
  function receiveTransaction(address from, uint256 value, address tokenAddress, bytes param) public returns (bool);
}


/******************************************************************************************************* */

contract InterChainToken {
    
    
    using SafeMath for uint256;
    
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 private mult_dec;
    uint256 public currentSupply;
    uint256 private minPrice;
    uint256 public tokenPrice;
    uint256 public chaintranferId;
    address public admin;
    uint public interChainFee;
    
    mapping (address => uint256) public balances;               
    mapping (address => mapping (address => uint)) public allowance;
    
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);
    event SendChainTransfer(address from, address to, uint256 amount, uint256 id);
    event ReceiveChainTransfer(address from, address to, uint256 amount, uint256 id);
    
    constructor() public {
        name = "BasicToken";                                   
        symbol = "BT";                               
        decimals = 18;                                      
        mult_dec = 10**uint256(decimals);
        currentSupply = 0;
        minPrice = 1000000000000000;
        tokenPrice = minPrice;
        admin = msg.sender;
    }  
    

    function transfer(address _to, uint256 amount) public returns (bool) {
        require(_to != address(this) && _to != address(0));
        balances[msg.sender] = balances[msg.sender].sub(amount);
        balances[_to] = balances[_to].add(amount);   
        emit Transfer(msg.sender, _to, amount);
        return true;
    }
    

    function buy() public payable returns (bool) {
        uint256 quantity = msg.value.mul(mult_dec).div(tokenPrice);                            
        balances[msg.sender] = balances[msg.sender].add(quantity);                
        currentSupply = currentSupply.add(quantity);                                
        emit Transfer(this,msg.sender,quantity); 
        return true;                                       
    }
    

    function sell(uint256 amount) public returns (bool) {
        uint256 revenue = amount.mul(tokenPrice).div(mult_dec);                       
        balances[msg.sender] = balances[msg.sender].sub(amount);
        currentSupply = currentSupply.sub(amount);
        msg.sender.transfer(revenue); 
        return true;   
    }
    

    function approval(address _spender, uint amount) public returns (bool) {
        require(balances[msg.sender] >= amount);
        allowance[msg.sender][_spender] = allowance[msg.sender][_spender].add(amount);
        return true;
    }
    

    function approveAndCall(address appAddress, uint256 amount, bytes param) public returns(bool) {
        approval(appAddress, amount);
        App app = App(appAddress);
        app.receiveTransaction(msg.sender, amount, this, param);
        return true;
    }
    
    
    function transferFrom(address _from, address _to, uint256 amount) public returns (bool) {
        require(_to != address(this) && _to != address(0));
        require(allowance[_from][msg.sender] >= amount);    
        balances[_from] = balances[_from].sub(amount);
        balances[_to] = balances[_to].add(amount);
        emit Transfer(msg.sender, _to, amount);
        return true;
    }
    
    
    function sendChainTransfer(address _to, uint256 amount)  public returns(bool) {
        chaintranferId ++;
        require( _to != address(0));
        balances[msg.sender] = balances[msg.sender].sub(amount);
        emit SendChainTransfer(msg.sender, _to, amount, chaintranferId);
        return true;
    }

    function receiveChainTransfer(address _from, address _to, uint256 amount, uint256 id)  public returns(bool) {
        require(msg.sender == admin);
        currentSupply = currentSupply.add(amount);
        balances[_to] = balances[_to].add(amount.sub(interChainFee));
        balances[admin] = balances[admin].add(interChainFee);
        emit ReceiveChainTransfer(_from, _to, amount, id);
        return true;
    }
    function () public payable {}
    
}
