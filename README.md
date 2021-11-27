## Features

'Block Will' similar to a will, where a benefactor creates a will contract which is specific to that user (the user's ETH wallet address) and allows deposits.

After registration, the benefactor names the wallet (e.g. family name) and may deposit a sum to the new blockwill smart contract. The benefactor may then create a list of beneficiaries addresses (also ETH wallet addresses), which is to be paid out to the beneficiaries if a 'proof-of-life validation' is not received by the will contract within a specified interval period (for the sake of illustration here, this is hardcoded at 5 min).

Interact with the WillFactory and Will contracts
'Set-Up':

- Register as Block Will user
- Name your will instance
- Deposit ETH into your will contract
- Add beneficiaries to your will contract

Services:

- Withdraw all funds
- Check for distribution eligibility (proof of life).
- Check last 'proof of life' received
- If 'no life' and appropriate interval passed, distribute funds to beneficiaries.

## Requirements

Requirements

- NPM (v7.4.1)
- NodeJs (v8.10.0)
- ganache-cli (Ganache CLI v6.12.2 (ganache-core: 2.13.2))
- truffle (v5.4.11)
- parcel (v1.12.5)

For the latest stable release of ganache-cli, and parcel:

```console
$ npm install ganache-cli@latest --global
$ npm install -g parcel-bundler
```

Once installed globally, you can start ganache right from your command line. Development is configured on port 7545:

```console
$ ganache-cli --port 7545

```

## Command line use

You must first clone the repository in empty directory:

```console
$ git clone https://github.com/politeStudent/blockchain-developer-bootcamp-final-project.git
```

Compile the smart contracts

```console
$ truffle compile
```

#### Compile the contracts

```console
Compiling your contracts...
===========================
> Compiling ./contracts/Migrations.sol
> Compiling ./contracts/WillFactory.sol
> Compiling ./contracts/will.sol

> Artifacts written to /mnt/e/dev/consensys/distTest/testClone1/blockchain-developer-bootcamp-final-project/build/contracts
> Compiled successfully using:
   - solc: 0.5.16+commit.9c3226ce.Emscripten.clang
```

### Deploy the contracts

```console
$ truffle deploy
  .
  .
  .
  Deploying 'WillFactory'
   -----------------------
   > transaction hash:    0xbd7f71d8ae72e62338f0b4d7aef1b488c2765837910ffefcff99e9d97db0479a
   > Blocks: 0            Seconds: 0
   > contract address:    0x5bDB281a3260F40b30Ba4d605a39A3E1155d6fb3
   > block number:        4
   > block timestamp:     1637938995
   > account:             0xC4b171da7eDBECC76d55156b96D3cD933Df91cb0
   > balance:             99.91246632
   > gas used:            3173826 (0x306dc2)
   > gas price:           20 gwei
   > value sent:          0 ETH
   > total cost:          0.06347652 ETH

```

NOTE: The WillFactory contract deployment has the hardcoded contract address needed for the UI. Get get the WillFactory contract address (here, the example is 0x5bDB281a3260F40b30Ba4d605a39A3E1155d6fb3). In a text editor, add the WillFactory contract address to environment env.json file:

```console
$ nano env.json
```

Edit the file to modify the deployed WillFactory contract address in env.json:

```json
{
  "DEPLOYEDCONTRACTID": "0x5bDB281a3260F40b30Ba4d605a39A3E1155d6fb3"
}
```

Then start the application user interface using parcel:

```console
$ parcel index.html

```

From there, the application is available in your browser for use:

```console
Server running at http://localhost:1234
✨  Built in 4.81s.
```
