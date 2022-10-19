// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <= 0.9.0;

import "./sdt-token.sol";

contract stakeSDT {    
    SDTToken public token = SDTToken(0x6cB911EDA0E4D07F21Ae2F735450DEDBe0387463);
    address public immutable stakeVault;
    address vault = 0x246897C43c988A198B47703E0D3D7803835DD78A;
    constructor() {
        stakeVault = msg.sender;
    } 

    address[] public ethStakers;
    address[] public ethLenders;
    uint[] public functionTime;

    bool public borrowCalled;

    mapping(address => uint) public stakeVaultInfo;  
    mapping(address => bool) public stakersRegister;
    mapping(address => bool) public lendersRegister;
    mapping(address => uint) public lenderVaultInfo;
    mapping(address => uint) stakersReward;
    mapping(address => uint) repaymentTime;
    error message(string);
    
    function stake(address staker, address to, uint amount) external {
        uint limit = 1000;
        require(amount >= limit);
        require(to == vault);
        address spender = msg.sender;
        stakeVaultInfo[staker] = amount;
        ethStakers.push(staker);
        stakersRegister[staker] = true;
        lendersRegister[staker] = false;
        token.transferFrom(staker, to, amount);
    }  

    function getSDTBal(address account) external view returns(uint) {
     return token.balanceOf(account);
    } 

     

    function getStakingBal() external view returns(uint) {
        return stakeVaultInfo[msg.sender];
    } 

     uint time;
    function borrow(uint amount, address borrower, uint repayTime) external {
        uint interval = 0 seconds;
        time = repayTime + interval;
        require(borrower == msg.sender, 'wrong borrower');
        require(stakersRegister[borrower] == true, 'not a staker');
        require(amount <= stakeVaultInfo[borrower] * 2, 'cant borrow');
        ethLenders.push(borrower);
        borrowCalled = true;
        lenderVaultInfo[borrower] = amount;
        repaymentTime[borrower] = block.timestamp + time;
    }
    

    function lend(address _vault, uint amount, address payable lender) external {
        require(borrowCalled == true);
        require(_vault == vault);
        require(lenderVaultInfo[lender] == amount);
        for(uint i = 0; i < ethLenders.length; i++) {
             if(ethLenders[i] == lender) {
                 token.transferFrom(_vault, lender, amount);
                 borrowCalled = false;
             }
         }
    }

    function repayment(address pVault,address payingLender, uint amount) public {
        require(amount == lenderVaultInfo[payingLender]);
        require(block.timestamp >= repaymentTime[payingLender]);        
        for(uint i = 0; i < ethLenders.length; i++) {
            if(ethLenders[i] == payingLender) {
                token.transferFrom(payingLender,pVault,amount);
                delete ethLenders[i];
            }
        }      
    }

    function getReward() external view returns(uint) {
        return stakersReward[msg.sender];
    }
    
    function rewardStaker(uint amount, address payable recipent) external payable {
        amount = msg.value;
        require(msg.sender == vault);
        functionTime.push(block.timestamp);
     if(functionTime.length > 2) {
            require(block.timestamp >= functionTime[functionTime.length-2] + 30 seconds);
        if(stakeVaultInfo[recipent] >= 1000 || stakeVaultInfo[recipent] <= 4999) {
            amount = 1000;
            stakersReward[recipent] = msg.value;
            recipent.transfer(msg.value);           
        } else if(stakeVaultInfo[recipent] >= 5000 || stakeVaultInfo[recipent] <= 19999) {
            amount = 5000;
            recipent.transfer(msg.value);
            stakersReward[recipent] = stakersReward[recipent] + msg.value;
        } else if(stakeVaultInfo[recipent] >= 20000 || stakeVaultInfo[recipent] <= 49999) {
            amount = 10000;
            recipent.transfer(msg.value);
            stakersReward[recipent] = stakersReward[recipent] + msg.value; 
        } else if(stakeVaultInfo[recipent] >= 50000) {
            amount = 25000;
            recipent.transfer(msg.value);
            stakersReward[recipent] = stakersReward[recipent] + msg.value; 
        }
      } else {
           if(stakeVaultInfo[recipent] >= 1000 || stakeVaultInfo[recipent] <= 4999) {
            amount = 1000;
            recipent.transfer(msg.value);   
            stakersReward[recipent] = stakersReward[recipent] + msg.value;        
        } else if(stakeVaultInfo[recipent] >= 5000 || stakeVaultInfo[recipent] <= 19999) {
            amount = 5000;
            recipent.transfer(msg.value); 
            stakersReward[recipent] = stakersReward[recipent] + msg.value;
        } else if(stakeVaultInfo[recipent] >= 20000 || stakeVaultInfo[recipent] <= 49999) {
            amount = 10000;
            recipent.transfer(msg.value);
            stakersReward[recipent] = stakersReward[recipent] + msg.value; 
        } else if(stakeVaultInfo[recipent] >= 50000) {
            amount = 25000;
            recipent.transfer(msg.value); 
            stakersReward[recipent] = stakersReward[recipent] + msg.value;
        }
      }
    }
}
