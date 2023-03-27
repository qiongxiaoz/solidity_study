// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IBaseERC20Token.sol";

contract ERC20Token is IBaseERC20Token{

    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;

    string private _symbol;

    constructor(){
        _name = "BETH";
        _symbol = "BETH";
        address account = msg.sender;
        uint256 amount = 1000000*10**18;
        _mint(account,amount);
    }

    function name() public view override returns (string memory) {
        return _name;
    }

    function symbol() public view override returns(string memory){
        return _symbol;
    }

    function decimals() public pure override returns(uint8){
        return 18;
    }

    function totalSupply() public view override returns(uint256){
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns(uint256){
        return _balances[account];
    }

    function transfer(address to ,uint256 amount) public override returns(bool){
        address owner = msg.sender;
        _transfer(owner,to,amount);
        return true;
    }

    function _transfer(address from, address to ,uint256 amount) internal returns(bool){
        require(from != address(0),"error");
        require(to != address(0),"address error");
        require(_balances[from] >= amount,"token not enough");
        unchecked {
            _balances[from] -= amount;
            _balances[to] += amount;
        }
        emit Transfer(from,to,amount);
        return true;
    }

    function allowance(address owner,address spender) public view override returns(uint256){
        return _allowances[owner][spender];
    }

    function approve(address spender,uint256 amount) public override returns(bool){
        address owner = msg.sender;
        _approve(owner,spender,amount);
        return true;
    }

    function _approve(address owner,address spender,uint256 amount) internal returns(bool){
        require(owner != address(0),"from zero address");
        require(spender != address(0),"spender zero address");
      
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
        return true;
    }

    function transferFrom(address from,address to,uint256 amount) public override returns(bool){
        address spender = msg.sender;
        _spendAllowance(from,spender,amount);
        _transfer(from,to,amount);
        return true;
    }

    function _spendAllowance(address from,address spender,uint256 amount) internal{
        uint256 balance = allowance(from,spender);
        if(balance != type(uint256).max){
        require(balance >= amount,"amount not enough");
            _approve(from,spender,balance - amount);
        }

    }

    function _mint(address account,uint256 amount) internal virtual{
        require(account != address(0),"mint to the zero address");
        _totalSupply += amount;
        unchecked {
            _balances[account] += amount;
        }
        emit Transfer(address(0), account, amount);
    }

     function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");
        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
            // Overflow not possible: amount <= accountBalance <= totalSupply.
            _totalSupply -= amount;
        }
        emit Transfer(account, address(0), amount);
    }

  
}