// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <= 0.9.0;


interface IERC20 {

    function getSupply() external  view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function returnAllowance(address owner, address spender) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);


    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
// contract address 0x1D674e15261A9F1d2BAdB73685a02bBD475F0EE6
contract SDTToken is IERC20 {
    string name = 'SDT-token';
    string symbol = 'SDT';
    uint8 decimal = 18;
    uint totalSupply = 1000000;

    mapping(address => uint) public holdersRecord;
    mapping(address => mapping(address => uint)) public allowances;

    constructor() {
        holdersRecord[msg.sender] = totalSupply;
    }

    function getSupply() external override view returns(uint) {
        return totalSupply;
    }

    function balanceOf(address holder) external override view returns(uint) {
        return holdersRecord[holder];
    }

    function transfer(address recipent, uint amountToSend) external override returns(bool)  {
        require(holdersRecord[msg.sender] >= amountToSend);
        holdersRecord[recipent] =  holdersRecord[recipent] + amountToSend;
        holdersRecord[msg.sender] =  holdersRecord[msg.sender] - amountToSend;
        return true;
    }
    function getBal() external view returns(uint) {
        return holdersRecord[msg.sender];
    }

    function approve(address spender, uint allowanceAmount) external override returns(bool) {
        address owner = msg.sender;
        allowances[owner][spender] = allowanceAmount;
        return true;
    }

    function returnAllowance(address owner, address spender) external override view returns(uint) {
        return allowances[owner][spender];
    }

    function transferFrom(address from, address to, uint transferAmount) external override returns(bool) {
        address spender = msg.sender;
        spendAllowance(from, spender, transferAmount);
        holdersRecord[to] = holdersRecord[to] + transferAmount;
        holdersRecord[from] =  holdersRecord[from] - transferAmount;
        return true;
    }

    function spendAllowance(address owner, address spender, uint allowanceAmount) internal view {
        uint allowanceBalance = allowances[owner][spender];
        require(allowanceBalance >= allowanceAmount);
        allowanceBalance = allowanceBalance - allowanceAmount;
    }

}