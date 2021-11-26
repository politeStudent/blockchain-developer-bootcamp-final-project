# blockchain-developer-bootcamp-final-project

Repository for Consensys Developer Bootcamp final project - Fall 2021 cohort

# Block Will

Create a financial instrument, similar to a will, where a deposit sum is made into a smart contract, having a list of beneficiaries addresses, which is to be paid out to the beneficiaries if a 'proof-of-life validation' is not received within a specified period. This would assume the contract owner is deceased or incapacitated.

As a fail-safe, another period may optionally be defined wherein the sum in the contract is released automatically after a longer period passes, regardless of whether or not any 'proof-of-life' validation is received (e.g. after 20 years).

### **'Proof-of-life'** - _To Be Determined_

Thoughts...One implementation may perhaps be achieved simply by sending a transaction to the contract. Another implementation may involve an oracle or interface to external api.

**Workflow**

1. User will somehow register
2. User will select will contract type
3. User will register beneficiaries
4. User will deposit a sum for later distribution in ETH
5. Contract will somehow 'listen' and receive 'proof-of-life' validation
6. If no 'proof-of-life' validation received within required period, the contract automatically distributes all funds and sends to beneficiaries.

**Optional functionality / Design Considerations:**

- Contract invests funds or 'yield farm' for relevant time period.
- Contract may optionally require the beneficiary 'proof-of-life' before any final distribution.
- In the above, the user may optionally set a DAO or non-profit as beneficiary, in the event no beneficiaries submit required 'proof-of-life'.
- Contract may be set with some time period for 'fail-safe' release, such as 20 years. If the 'fail-safe' period ends, the contract automatically distributes all funds and sends to beneficiaries.
- User may optionally set proportional distributions among many beneficiaries.

        For Example
        `Alice: 50%; Bob 20%; Carol 30%`
