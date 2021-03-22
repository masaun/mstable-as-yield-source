/// Using local network
const Web3 = require('web3');
const web3 = new Web3(new Web3.providers.WebsocketProvider('ws://localhost:8545'))

/// Artifact of smart contracts 
const MStableYieldSource = artifacts.require("MStableYieldSource")
const MUSDToken = artifacts.require("MUSDToken")
const ISavingsContractV2 = artifacts.require("ISavingsContractV2")  /// [Note]: save contract also works as xmUSD

/// Import deployed-addresses
const contractAddressList = require("../../migrations/addressesList/contractAddress/contractAddress.js")


/**
 * @notice - This is the test of MStableYieldSource.sol
 * @notice - [Execution command]: $ truffle test ./test/test-local/MStableYieldSource.test.js
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

    /// Global variable for each contract addresses
    let MSTABLE_YIELD_SOURCE
    let MUSD
    let SAVE = contractAddressList["Mainnet"]["mStable"]["mUSD SAVE (imUSD)"]
    let NEXUS = contractAddressList["Mainnet"]["mStable"]["Nexus"]

    async function getEvents(contractInstance, eventName) {
        /// [Note]: Retrieve an event log of eventName (via web3.js v1.0.0)
        let events = await contractInstance.getPastEvents(eventName, {
            filter: {},  /// [Note]: If "index" is used for some event property, index number is specified
            fromBlock: 0,
            toBlock: 'latest'
        })
        console.log(`\n=== [Event log]: ${ eventName } ===`, events[0].returnValues)
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

        it("[Log]: Deployed-contracts addresses", async () => {
            console.log("\n=== MUSD ===", MUSD)
            console.log("=== SAVE ===", SAVE)
            console.log("=== MSTABLE_YIELD_SOURCE ===", MSTABLE_YIELD_SOURCE)
        })
    })

})
