/// Using local network
const Web3 = require('web3');
const web3 = new Web3(new Web3.providers.WebsocketProvider('ws://localhost:8545'))

/// Artifact of smart contracts 
const MStableYieldSource = artifacts.require("MStableYieldSource")
const MUSDToken = artifacts.require("MUSDToken")
const ISavingsContractV2 = artifacts.require("ISavingsContractV2")  /// [Note]: save contract also works as xmUSD
const RNGMStableHarness = artifacts.require("RNGMStableHarness")
const PoolWithMultipleWinnersBuilder = artifacts.require("PoolWithMultipleWinnersBuilder")
const YieldSourcePrizePool = artifacts.require("YieldSourcePrizePool")  /// Used for the PrizePool
const MultipleWinners = artifacts.require("MultipleWinners")            /// Used for the PrizeStorategy

/// Import deployed-addresses
const contractAddressList = require("../../migrations/addressesList/contractAddress/contractAddress.js")


/**
 * @notice - This is the test of MStableYieldSource.sol
 * @notice - [Execution command]: $ truffle test ./test/test-local/MStableYieldSource.test.js
 * @notice - [Using mainnet-fork with Ganache-CLI and Infura]: Please reference from README
 */
contract("MStableYieldSource", function(accounts) {
    /// Acccounts
    let deployer = accounts[0]
    let user1 = accounts[1]
    let user2 = accounts[2]
    let user3 = accounts[3]

    /// Global contract instance
    let mStableYieldSource
    let mUSD
    let save
    let rngMStableHarness
    let poolWithMultipleWinnersBuilder
    let prizePool
    let prizeStrategy

    /// Global variable for each contract addresses
    let MSTABLE_YIELD_SOURCE
    let MUSD
    let SAVE = contractAddressList["Mainnet"]["mStable"]["mUSD SAVE (imUSD)"]
    let NEXUS = contractAddressList["Mainnet"]["mStable"]["Nexus"]
    let RNG_MSTABLE_HARNESS
    let POOL_WITH_MULTIPLE_WINNERS_BUILDER = contractAddressList["Mainnet"]["PoolTogether"]["PoolWithMultipleWinnersBuilder"]

    /// Global parameters for PoolTogether
    let yieldSourcePrizePoolConfig
    let multipleWinnersConfig
    let decimals = 9

    async function getEvents(contractInstance, eventName) {
        /// [Note]: Retrieve an event log of eventName (via web3.js v1.0.0)
        let events = await contractInstance.getPastEvents(eventName, {
            filter: {},
            fromBlock: 12093507,  /// [Note]: Please specify the latest blockNumber of mainnet as "fromBlock". Otherwise, it takes long time to retrieve the result of events
            //fromBlock: 0,
            toBlock: 'latest'
        })
        //console.log(`\n=== [Event log]: ${ eventName } ===`, events[0].returnValues)
        return events[0].returnValues
    } 

    describe("Setup smart-contracts", () => {
        it("Deploy the mUSD contract instance", async () => {
            mUSD = await MUSDToken.new({ from: deployer })
            MUSD = mUSD.address
        })

        it("Create the SavingsContract contract instance (that deal with imUSD)", async () => {
            save = await ISavingsContractV2.at(SAVE, { from: deployer })
        })

        it("Deploy the MStableYieldSource contract instance", async () => {
            mStableYieldSource = await MStableYieldSource.new(MUSD, SAVE, { from: deployer })
            MSTABLE_YIELD_SOURCE = mStableYieldSource.address

            /// [Note]: Currently, this is commentouted because of that it takes long time to retrieve the result of event in case of using mainnet-fork approach.
            // let event = await getEvents(mStableYieldSource, "ImUSDYieldSourceInitialized")
        })

        it("Deploy the RNGMStableHarness contract instance", async () => {
            rngMStableHarness = await RNGMStableHarness.new({ from: deployer })
            RNG_MSTABLE_HARNESS = rngMStableHarness.address
        })

        it("[Log]: Deployed-contracts addresses", async () => {
            console.log("\n=== MUSD ===", MUSD)
            console.log("=== SAVE ===", SAVE)
            console.log("=== MSTABLE_YIELD_SOURCE ===", MSTABLE_YIELD_SOURCE)
        })
    })

    describe("Preparations", () => {
        it("Setup parameter of yieldSourcePrizePool", async () => {
            yieldSourcePrizePoolConfig = {
                yieldSource: MSTABLE_YIELD_SOURCE,
                maxExitFeeMantissa: web3.utils.toWei("0.5", "ether"),
                maxTimelockDuration: 1000,
            }
        })

        it("Setup parameter of multipleWinners", async () => {
            multipleWinnersConfig = {
                proxyAdmin: "0x0000000000000000000000000000000000000000",
                rngService: RNG_MSTABLE_HARNESS,
                prizePeriodStart: 0,
                prizePeriodSeconds: 100,
                ticketName: "mUSD Pass",
                ticketSymbol: "musdp",
                sponsorshipName: "mUSD Sponsor",
                sponsorshipSymbol: "musdsp",
                ticketCreditLimitMantissa: web3.utils.toWei("0.1", "ether"),
                ticketCreditRateMantissa: web3.utils.toWei("0.1", "ether"),
                externalERC20Awards: [],
                numberOfWinners: 1,
            }
        })

        it("Create the PoolWithMultipleWinnersBuilder contract instance", async () => {
            /// Assign deployed-address of the PoolWithMultipleWinnersBuilder contract
            poolWithMultipleWinnersBuilder = await PoolWithMultipleWinnersBuilder.at(POOL_WITH_MULTIPLE_WINNERS_BUILDER, { from: deployer })
        })
    })

    describe("Create yield source multiple winners", () => {
        it("Execute createYieldSourceMultipleWinners() method of the PoolWithMultipleWinnersBuilder contract", async () => {
            let txReceipt = await poolWithMultipleWinnersBuilder.createYieldSourceMultipleWinners(
                yieldSourcePrizePoolConfig,
                multipleWinnersConfig,
                decimals
            )
        })

        it("Retrieve the 'YieldSourcePrizePoolWithMultipleWinnersCreated' event of createYieldSourceMultipleWinners() method", async () => {
            let event = await getEvents(poolWithMultipleWinnersBuilder, "YieldSourcePrizePoolWithMultipleWinnersCreated")
            console.log('=== [Event log]: YieldSourcePrizePoolWithMultipleWinnersCreated ===', event)

            /// Assign each address from the event log retrieved above
            PRIZE_POOL = event.prizePool
            PRIZE_STORATEGY = event.prizeStrategy
            console.log(`\n=== PRIZE_POOL: ${ PRIZE_POOL } ===`)
            console.log(`=== PRIZE_STORATEGY: ${ PRIZE_STORATEGY } ===\n`)
        })

        it("Create instances of prizePool and prizeStrategy", async () => {
            prizePool = await YieldSourcePrizePool.at(PRIZE_POOL, { from: deployer })
            prizeStrategy = await MultipleWinners.at(PRIZE_STORATEGY, { from: deployer })
        })

        it("mUSD balance of deployer should be 100000000", async () => {
            const _mUSDBalance = await mUSD.balanceOf(deployer)
            const mUSDBalance = String(web3.utils.fromWei(_mUSDBalance, 'ether'))
            console.log('\n=== mUSDBalance ===', mUSDBalance)
            assert.equal(mUSDBalance, "100000000", "mUSD balance of deployer should be 100000000")
        })

        it("Transfer 1000 mUSD from deployer to user1", async () => {
            const amount = web3.utils.toWei('1000', 'ether')
            const txReceipt = await mUSD.transfer(user1, amount, { from: deployer })
        })
    })

    describe("Process from deposit to withdraw by using the PrizePool and the PrizeStorategy", () => {
        it("Token address should be mUSD's contract address", async function () {
            assert.equal(await mStableYieldSource.token(), MUSD, "Token address should be mUSD's contract address")
        })

        it("Underlying asset (mUSD) should be deposited into the PrizePool", async function () {
            // @notice - Returned value of prizePool.tokens() is an array of the Tokens controlled by the Prize Pool (ie. Tickets, Sponsorship)
            let [token] = await prizePool.tokens()

            const depositAmount = web3.utils.toWei('100', 'ether')
            let txReceipt1 = await mUSD.approve(PRIZE_POOL, depositAmount, { from: user1 });

            const to = deployer
            //const to = PRIZE_POOL
            const controlledToken = token
            console.log(`\n=== controlledToken: ${ controlledToken } ===`)
            const referrer = user1
            let txReceipt2 = await prizePool.depositTo(to, depositAmount, controlledToken, referrer, { from: user1 })
        })

        it("Deposited-underlying asset (mUSD) should be withdrawn with some interest", async function () {
            // @notice - Returned value of prizePool.tokens() is an array of the Tokens controlled by the Prize Pool (ie. Tickets, Sponsorship)
            let [token] = await prizePool.tokens()

            const balanceBefore = await mUSD.balanceOf(PRIZE_POOL);

            const fromAddr = deployer
            //const fromAddr = PRIZE_POOL
            const withdrawAmount = web3.utils.toWei('1', 'ether')
            const controlledToken = token
            const maximumExitFee = web3.utils.toWei('1000', 'ether')
            let txReceipt2 = await prizePool.withdrawInstantlyFrom(fromAddr, withdrawAmount, controlledToken, maximumExitFee, { from: user1 })
            expect((await mUSD.balanceOf(PRIZE_POOL)) > balanceBefore)  /// [Note]: expect() is chai only?
        })
    })

})
