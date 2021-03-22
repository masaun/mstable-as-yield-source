# LP Token as a yield source for PoolTogether🎫🎟

***
## 【Introduction of the LP Token as a yield source for PoolTogether🎫🎟】
- This is a smart contract that: 
  - Custom Prize Strategy for PoolTogether

&nbsp;

***

## 【Workflow】
- Diagram of workflow  

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
$ ganache-cli --fork https://mainnet.infura.io/v3/{YOUR INFURA KEY}@{BLOCK_NUMBER}
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
