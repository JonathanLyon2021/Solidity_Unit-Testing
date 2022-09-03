const Funding = artifacts.require("Funding");
const utils = require("./utils");

const SECONDS_IN_1_HOUR = 3600;
const HOURS_IN_A_DAY = 24;
const GWEI = 10 ** 9;

const DAY = SECONDS_IN_1_HOUR * HOURS_IN_A_DAY;

contract("Funding", async accounts => {
    const firstAccount = accounts[0];
    const secondAccount = accounts[1];
    const thirdAccount = accounts[2];
    let funding; // first account

    beforeEach(async () => {
        const goal = web3.utils.toHex(100000000 * GWEI);
        funding = await Funding.new(DAY, goal);
    });

    it("does not allow withdrawal if contract is not funded", async () => {
        try {
            await funding.withdraw();
            assert.fail();
        } catch (err) {
            assert.ok(/revert/.test(err.message));
    }
});

    it("disallow refund if account has no balance", async () => {
        await funding.donate({ from: secondAccount, value: 50000000 * GWEI});
        await utils.timeTravel(web3, DAY);

        try {
            const x = await funding.refund({ from: thirdAccount });
            assert.fail();
        } catch (err) {
            assert.ok(/revert/.test(err.message));
    }
});
