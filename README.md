# mStable's mAsset (mUSD) as a yield source for PoolTogether🎫 🎟

***
## 【Introduction of the mStable's mAsset (mUSD) as a yield source for PoolTogether🎫 🎟】
- This is a smart contract that mStable's mAsset (mUSD) as a yield source for PoolTogether.

&nbsp;

***

## 【Workflow】
- Diagram of workflow  
![【Diagram】mStable's mAsset (mUSD) as a yield source for PoolTogether](https://user-images.githubusercontent.com/19357502/113303612-37e4e280-933c-11eb-9b6d-9a96837ec6a2.jpg)

&nbsp;

***

## 【Remarks】
- Version for following the `PoolTogether` smart contract
  - Solidity (Solc): v0.6.12
  - Truffle: v5.1.60
  - web3.js: v1.2.9
  - openzeppelin-solidity: v3.2.0
  - ganache-cli: v6.9.1 (ganache-core: 2.10.2)


&nbsp;

***

## 【Setup】
### ① Install modules
- Install npm modules in the root directory
```
$ npm install
```

<br>

### ② Compile & migrate contracts (on local)
```
$ npm run migrate:local
```

<br>

### ③ Test (Mainnet-fork approach)
- 1: Start ganache-cli with mainnet-fork
```
$ ganache-cli -d --fork https://mainnet.infura.io/v3/{YOUR INFURA KEY}@{BLOCK_NUMBER}
```
(※ `-d` option is the option in order to be able to use same address on Ganache-CLI every time)

<br>

- 2: Execute test of the smart-contracts (on the local)  
  - Test for the MStableYieldSource contract  
    `$ npm run test:MStableYieldSource`  
    ($ truffle test ./test/test-local/MStableYieldSource.test.js)  

<br>


***

## 【References】
- PoolTogether
  - Doc: https://docs.pooltogether.com/protocol/prize-strategy
  - Workshop: https://www.youtube.com/watch?v=sTsMt0zdOHY
  - GR9 Prize：https://github.com/pooltogether/Gitcoin_Grants_Round_9_Bounties

<br>

- mStable
  - Doc：https://docs.mstable.org/developers/introduction  
  - idea：https://docs.mstable.org/developers/introduction#bb4f  
  - Saving：https://docs.mstable.org/mstable-assets/massets/native-interest-rate 
  - Live dApp (Ropsten, Kovan)：https://docs.mstable.org/developers/introduction#live-apps 

<br>

- Deployed-addresses on Mainnet
  - PoolTogether：https://docs.pooltogether.com/networks/ethereum#builders
  - mStable：https://docs.mstable.org/developers/deployed-addresses

<br>

- GR9 Prize in Gitcoin
https://gitcoin.co/issue/pooltogether/Gitcoin_Grants_Round_9_Bounties/1/100025059
