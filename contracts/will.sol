// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

/// @title Contract for automated type of blockchain based 'will'
/// @author spaceconcepts@gmail.com
/// @notice Allows a user to set up, and maintain a will. 
/// @notice Allows distribution to beneficary if no 'proof of life' received and interval time met.
/// @dev This contract is used by WillFactory to create unique will instances.
/// @dev This contract assumes the 'drivers' of the will are, in fact, the beneficaries. Hence code calls them 'drivers', not 'beneficaries'.
contract Will {

    /// @notice owner address. Owner of will instance.
    /// @dev Used to restrict functions to only will owner.
    address public willOwner;

    /// @notice name string.  Name of will instance. 
    /// @dev Used to help customer identify will instance.
    string public name;

    /// @notice address of will instance.
    /// @dev Used to send funds to will instance account.  
    address public willAddr;

    /// @notice Address of first 'power of attoney'. Not implemented in UI.
    /// @dev to be used for transferring owner or allowing multisig distribution. 
    address public POA1;

    /// @notice Address of second 'power of attoney'. Not implemented in UI.
    /// @dev to be used for transferring owner or allowing multisig distribution. 
    address public POA2;

    /// @notice Array of beneficiary addresses
    /// @dev Used for collection of beneficiaries for a given will.
    address [] public drivers;

    /// @notice Counter for number of beneficiaries.
    /// @dev Used as a helper when iterating available beneficiaries.
    uint public driverCounter=0;

    /// @notice  Property to hold balance within contract.
    /// @dev Used as a helper when receiving funds and calculating distribution.
    uint public balance = 0;

    /// @notice Property to hold balance within contract to calculate shares.
    /// @dev Used as a helper when calculating distribution shares.
    uint willAmount;

    /// @notice 'Per sterpis' share where each beneficiary is to receive an equal share.
    uint share;

    // /// @notice Unix timestamp
    // /// @dev Used as a helper to determine if funds are eligible for release.
    // uint public timestamp = block.timestamp;

    /// @notice Unix timestamp
    /// @dev Used as a helper to determine if funds are eligible for release.
    uint public lastAlive;

    // /// @notice List of all property ids.
    // /// @dev Used as a helper when iterating available properties in frontend client.
    // uint public timeNow;

    /// @notice Interval to add to last 'proff of life' to see if will is eligible for distribution.
    /// @dev Future: each will owner can determine their own 'wait' interval, e.g. month, year, etc...
    uint public interval = 300;  // five minutes hardcoded for instruction purposes.
    
    constructor(address _creator, string memory _name) public payable {
        willOwner = _creator;
        name = _name;
        willAddr = address(this);
        lastAlive = block.timestamp;   //sets initial 'proof of life'.
        // POA1 = _POA1;               // Future: Power of Attorney capability
        // POA2 = _POA2;
    }
    
    /// @notice Adds a primary Power of Attorney for the will
    /// @param _new  Address of the primary Power of Attorney
    /// @dev Possible to use as 'power of atty'or multisig. Not used currently
    function setPOA1(address _new) public {
        POA1 = _new;
    }
    
    /// @notice Adds a secondary Power of Attorney for the will
    /// @param _new  Address of the secondary Power of Attorney
    /// @dev Possible to use as 'power of atty' or multisig. Not used currently
    function setPOA2(address _new) public {
        POA2 = _new;
    }
    
    /// @notice Adds a beneficiary to a given will
    /// @param _newDriver Property to which the beneficary address is added as a tenant
    /// @dev Check for exact payment sum to avoid having to send ETH back to sender
    function setDriver(address _newDriver) public  {
        drivers.push(_newDriver);
        driverCounter++;
    }
    
    /// @notice  Gets a beneficary by index number. 
    /// @param  _index Property by which the beneficary is identified in array.
    /// @return  Returns address of beneficary given array index.
    function getDriver(uint _index) public view returns(address){
        return drivers[_index];
    }


    /// @notice Deletes a beneficary by index number.
    /// @param _index Property by which the beneficary is identified in array.
    /// @dev Remove array element by shifting elements from right to left
    function removeDriver(uint _index) public {
        require(_index < drivers.length, "index out of bound");

        for (uint i = _index; i < drivers.length - 1; i++) {
            drivers[i] = drivers[i + 1];
        }
        drivers.pop();
        driverCounter--;
    }


    /// @notice Adds a tenant to a given property id
    /// @return  Returns array of beneficary addresses.

    function getAllDrivers() public view returns(address[] memory){
        ///
        address[] memory arr;        
        for (uint i = 0; i < driverCounter; i++) {
          arr[i] = drivers[i];
        }
        return arr;
  
    }


    /// @notice get Driver count
    /// @return  Returns count of beneficaries.
    function getDriverCount() public view returns(uint){
        return driverCounter;  
    }


    // working
    /// @notice Allows benefactor (will owner) to withdraw all funds deposited for beneficiaries.
    function sendEther() external {                                     
        address payable _to = address(uint160(willOwner));
        // address payable _to = address(uint160(owner()));
        // address payable _to = owner();
        _to.transfer(balance);
        balance = 0;
    }


    /// @notice get the time interval (in seconds) to wait before allowing distribuition to beneficaries.
    /// @dev Check interval. Currently five minutes (300 seconds).  Future: allow user to select wait interval.
    function getInterval() public view returns(uint){
        return interval;
    }


    /// @notice  Get the timestamp for last owner 'proof of life'.
    /// @return  Returns timestamp from last 'alive' message.
    function getLastAlive() public view returns(uint){
        return lastAlive;
    }


    /// @notice  Set the timestamp for last owner 'proof of life'.
    /// @param  _timeAlive  Property containing timestamp to renew 'proof of life'
    function setLastAlive(uint _timeAlive) public  {
        lastAlive = _timeAlive;
    }


    /// @notice  Distributes fund amount deposited by benefactor to all beneficiaries 'per stirpes' (equal share).
    /// @dev Check for exact payment sum to avoid having to send ETH back to sender
    /// @return  Returns true if complete.
    function distributeBenefits() public payable returns (bool) {
        // 1. get contract balance.  
        // 2. divide by num of beneficiaries
        // 3. transfer shares to beneficiaries
        // 4. clear beneficaries & count
        willAmount = balance;
        share = willAmount / driverCounter;
     
        for (uint i = 0; i < driverCounter; i++) {
        address beneAddr = drivers[i];
        //address payable _to = payable(beneAddr); // Correct since Solidity >= 0.6.0
        address payable _to = address(uint160(beneAddr)); // Correct since Solidity >= 0.5.0
        _to.transfer(share);
        balance = balance - share;
        }
        resetBeneficiariesMapping();
        driverCounter = 0;
        return true;
  }

    /// @notice  Clear all beneficiaries and reset beneficiary counter
    /// @dev  Delete does not change the array length. Pop will decrease the array length by 1.
    function resetBeneficiariesMapping() private {
      for (uint i=0; i< driverCounter ; i++){
          //delete drivers[i];
          drivers.pop();
      }
    }

    /// @notice Fallback function so will contract can receive funds.
    /// @dev    Maintains 'helper' balance property on receipt of funds.
    function () external payable {
      // emit Receive(msg.sender, msg.value);
      balance += msg.value;
    }       
    
}
