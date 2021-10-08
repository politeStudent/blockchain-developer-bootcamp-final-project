# blockchain-developer-bootcamp-final-project

Repository for Consensys Developer Bootcamp final project

# Block Will

Start to sketch the functions.

1.  Users will have to register themselves somehow on the contract.

```javascript
function registerBenefactor(address _benefactor) public {
// registers benefactor
};
```

2. They have to identify which contract type they desire.

```javascript
function registerContract(uint contractType) returns(uint contractID) {
// registers the contract type of the benefactor
// returns contractID
};
```

3. They'll have to register beneficiaries. If contract allows percentage allocations, these are also registered.

```javascript
function registerBeneficiaries(address beneficary, uint _percentage) {
// registers the address of beneficiary, and optionally, their percentage
};
```

4. User (benefactor) will deposit a sum for later distribution in ETH.

```javascript
function transfer(address _benefactor, address _beneficiary, uint _amount) private {
// Funds are transferred to contract
};
```

5. Contract will somehow 'listen' and receive 'proof-of-life' validation.

```javascript
function check4Life(address _benefactor) private returns (bool) {
// Returns 'proof-of-life' as true or false
};
```

6. If no 'proof-of-life' validation received within required period, the contract automatically distributes all funds and sends to beneficiaries.

```javascript
function distributeBenefits(address _benefactor, uint contractID) {
// get beneficaries
// forEach distribute proper amount
// close contract
};
```
