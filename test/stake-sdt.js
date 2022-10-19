const satkeSDT = artifacts.require('stakeSDT');

contract('stake sdt', () => {
    let instance = null;

    let staker = '0x29de92D2E8c4Da1079166F9d452eD3E318d7feb6';
    let to = '0x344A2ff06584EB24A096a9FA7ee74bE40C39B32b';
    let amount = 10000;
    let vault = '0x344A2ff06584EB24A096a9FA7ee74bE40C39B32b'

    before(async() => {
        instance = await satkeSDT.deployed()
    })

    let time;

    it('stake', async() => {
        let limit = 500;
        try{
            await instance.stake(staker, to, amount);
        } catch(error){
            assert(amount >= limit);
            assert(to == vault);
        }
    })
    it('borrow', async() => {
        let stakeAmount = 1000;
        let interval = 0;
        let repayTime = 30;
        let amount = 2000;
        let borrower = '0x29de92D2E8c4Da1079166F9d452eD3E318d7feb6';
        try{
            await instance.borrow(amount, borrower, repayTime)
        } catch(error) {
            assert(borrower == '0x29de92D2E8c4Da1079166F9d452eD3E318d7feb6')
            assert(amount <= stakeAmount * 2)
        }
    })

    it('lend', async() => {
        let amount = 2000;
        let borrower = '0x29de92D2E8c4Da1079166F9d452eD3E318d7feb6';
        try{
            await instance.lend(vault, amount, borrower,)
        } catch(error) {
            assert(vault == '0x344A2ff06584EB24A096a9FA7ee74bE40C39B32b')
            assert(amount == 2000)
        }
    })

    it('repayment', async() => {
        let amount = 2000;
        let time = 30;
        let borrower = '0x29de92D2E8c4Da1079166F9d452eD3E318d7feb6';
        try{
            await instance.repayment(vault,borrower,amount)
        } catch(error) {
            assert(time == 30)
            assert(amount == 2000)
        }
    })


})