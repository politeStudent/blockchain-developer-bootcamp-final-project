// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;
import "./will.sol";


/// @title Factory contract to create blockchain based 'wills', specific for an ethereum address owner. 
/// @author spaceconcepts@gmail.com
/// @notice Allows a user to set up and fund a 'will' for their beneficaries.  
/// @notice If no 'proof of life' is received, and the interval (5 min) passed, funds are available for release. 
/// @dev This contract is uses will.sol to create new wills.

contract WillFactory {

    /// @notice Array of Will contracts. 
    /// @dev Used to track all wills created by factory.
    Will[] public wills;

    /// @notice Array of beneficiary addresses
    /// @dev Used as a helper when returning all beneficiaries
    address[] public myDrivers;

    /// @notice owner address. Owner of will instance. 
    /// @dev Used to restrict functions to onlyOwner, like adding beneficiaries.
    address public owner;

    // /// @notice List of all property ids.
    // /// @dev Used as a helper when iterating available properties in frontend client.
    // uint public numDrivers;

    mapping (address => bool) public enrolled;
    mapping(address => uint) public willId;
    mapping (address => bool) public hasWill;

    /// @notice number of wills created by factory
    uint public willCounter=0;

    /// @notice Emitted when a user account is enrolled
    /// @param accountAddress account address
    event LogEnrolled(address accountAddress);

    /// @notice Emitted when a will is created
    /// @param accountAddress account address
    event LogCreate(address accountAddress);

    /// @notice Emitted when owner withdraws all funds deposited in will
    /// @param custId  customer id
    /// @param newBalance balance after withdraw
    event LogWithdrawal(uint custId, uint newBalance);

    /// @notice Emitted when 'proof of life' received.
    /// @param accountAddress account address
    /// @param aTime Time the 'proof of life' message was received
    event LogAlive(address accountAddress, uint aTime);

    /// @notice Emitted when funds distributed to beneficiaries
    /// @param beneAddress beneficary address
    /// @param aTime Time the distribution was issued
    event LogDistribution(address beneAddress, uint aTime);

    /// @notice Emitted when a beneficary is deleted
    /// @param beneAddress beneficary address
    event LogDeleteDriver(address beneAddress);

    /// @notice Emitted when a beneficary is added
    /// @param custId  customer id
    /// @param beneAddress beneficary address
    event LogAddBeneficiary(uint custId, address beneAddress);
   
    constructor() public payable {
        owner = msg.sender;
    }


    /// @notice  Get the customer id associated with the given account address
    /// @param  _addr  Property to which the sender address is mapped to customer id.
    /// @return  Returns custId
    function get(address _addr) public view returns (uint) {
        return willId[_addr];
    }

    /// @notice  Sets the customer id associated with the given account address with next mapping sequence number.
    /// @param  _addr  Property to which the sender address is mapped to customer id.
    function set(address _addr) public {
        willId[_addr] = willCounter;
        willCounter++;
    }

    /// @notice  Resets (not removes) the given account address to the default value.
    /// @param  _addr  Property to which the sender address is mapped to customer id.
    function remove(address _addr) public {
        delete willId[_addr];
    }

    /// @notice  Enrolls the address as an member.  Assigns custId. Emits Enrollment event.
    /// @return  Returns bool as proof of enrollment.
    function enroll() public returns (bool){
      if (enrolled[msg.sender]){
        return false;
      }else{        
        set(msg.sender);
        enrolled[msg.sender] = true;
        emit LogEnrolled(msg.sender);
        return enrolled[msg.sender];
      }
    }

    /// @notice  Sends funds to appropriate receipient.
    /// @param  _receiver Receipent address of funds.
    /// @param  _amount   Amount to send receipient.
    function send(address payable _receiver, uint _amount) public {
      _receiver.call.value(_amount);
    }
  



    /// @notice  Creates new instance of will contract.
    /// @param  _owner  Property to which the sender address is added as the will owner (a.k.a. 'the benefactor').
    /// @param  _name  Property to which the sender can associate a name with the will (e.g. family name).
    /// @dev     Test for event emmited.
    function create(address _owner, string memory _name) public returns(bool) {
        Will will = new Will(_owner, _name);
        wills.push(will);
        hasWill[msg.sender] = true;
        emit LogCreate(_owner);
        return hasWill[msg.sender];

    }

    // Future function
    // @notice  Populate power of atty and deposit to will account during contract creation.   
    // function createAndSendEther(address _owner, string memory _name, address _POA1, address _POA2) public {
    //     Will will = (new Will)(_owner, _name);
    //     wills.push(will);
    // }


    /// @notice  Get Driver count
    /// @param  _custId  Customer id
    /// @return  owner of the will instance.
    /// @return  name of the will instance.
    /// @return  contract instance address.
    /// @return  first 'Power of Atty' address.
    /// @return  second 'Power of Atty' address.

    function getWill(uint _custId)
        public
        view
        returns (
            address willOwner,
            string memory name,
            address willAddr,
            address POA1,
            address POA2,
            uint balance
        )
    {
        Will will = wills[_custId];
        return (will.willOwner(), will.name(), will.willAddr(), will.POA1(), will.POA2(), address(will).balance);
    }
    

    /// @notice  Get the address of the contract instance for a given customer.
    /// @param  _custId Property to which customer is mapped to a will instance.
    /// @return  Returns address of will instance for a given customer.
        function getContractAddr(uint _custId)
        public
        view
        returns (
            address willAddr
        )
    {
        Will will = wills[_custId];
        return ( will.willAddr() );
    }


    /// @notice  Set primary power of atty
    /// @param  _custId Property to which customer is mapped to a will instance.
    /// @param  _newPOA Property to which customer is mapped to a will instance.
        function setPrimaryPOA(uint _custId, address _newPOA)
        public

    {
        wills[_custId].setPOA1(_newPOA);

    }

    /// @notice  Set secondary power of atty
    /// @param  _custId Property to which customer is mapped to a will instance.
    /// @param  _newPOA Property to which customer is mapped to a will instance.
    function setSecondaryPOA(uint _custId, address _newPOA)
        public

    {
        wills[_custId].setPOA2(_newPOA);

    }

    /// @notice  Set beneficiary for a given customer id.
    /// @param  _custId Property to which customer is mapped to a will instance.
    /// @param  _newDriver Property to which a new beneficiary added.
    /// @dev     Only owner of will contract instance can add beneficiaries to their contract.
    
    function setDriver(uint _custId, address _newDriver)
        public
    {   
        require(wills[_custId].willOwner() == msg.sender, "NOT THE OWNER!");
        wills[_custId].setDriver(_newDriver);
        emit LogAddBeneficiary(_custId, _newDriver);

    }

    /// @notice  Deletes beneficiary for a given customer id.
    /// @param  _custId Property to which customer is mapped to a will instance.
    /// @param  _delDriver Array index of beneficary to be deleted.
    /// @dev     Emits delete event.
    function deleteDriver(uint _custId, uint _delDriver)
        public
    {   Will will = wills[_custId];
        address temp = will.getDriver(_delDriver);
        
        wills[_custId].removeDriver(_delDriver);
        emit LogDeleteDriver(temp);
    }

    /// @notice get one beneficiary
    /// @param _custId Property to which customer is mapped to a will instance.
    /// @param _arrayIndex Property which the array index of beneficary
    /// @return  Returns address of beneficiary at a given position.
    function getDriver(uint _custId, uint _arrayIndex)
        public
        view
        returns(address driver)
    {
        Will will = wills[_custId];
        address temp = will.getDriver(_arrayIndex);
        return temp;
    }

    /// @notice get all beneficiaries for a given custId.
    /// @param _custId Property to which customer is mapped to a will instance.
    /// @return  Returns array of beneficiary addresses.
    function getAllDrivers(uint _custId)
        public
        returns (address[] memory)
    {
        Will will  = wills[_custId];
        uint dNum = getDriverCount(_custId);
        for (uint i = 0; i < dNum; i++) {
              myDrivers.push(will.getDriver(i));
            }
        return myDrivers;
    }

    /// @notice  Get count of beneficiaries.
    /// @param  _custId Property to which customer is mapped to a will instance.
    /// @return  Returns count (number of) beneficiary addresses.
    /// @dev     Emits delete event.
    function getDriverCount(uint _custId)
        public
        view
        returns(uint)
    {
        Will will = wills[_custId];
        // numDrivers = will.getDriverCount();
        return will.getDriverCount();
    }

    /// @notice  Allow contract creator to 'cancel' and withdraw all funds deposited.
    /// @param  _custId Property to which customer is mapped to a will instance.
    /// @dev     Emits withdraw event.
    function withdraw(uint _custId) public {   // working
        Will will = wills[_custId];
        will.sendEther();
        uint bal = will.balance();
        emit LogWithdrawal(_custId, bal);
    }   

    /// @notice get Driver count
    /// @param _custId Property to which the sender address is added as a tenant
    /// @dev Check for exact payment sum to avoid having to send ETH back to sender
    function check4Life(uint _custId) public view returns (string memory) {
        // Returns 'proof-of-life' as true or false
        Will will = wills[_custId];
        uint timeNow = block.timestamp;
        uint lastAlive = will.getLastAlive();
        uint interval = will.getInterval();
        // string memory la = uint2str(lastAlive);
        // string memory tn = uint2str(timeNow);
        // string memory zz1;
        // zz1 = string(abi.encodePacked(la, timeNow, tn, "ok"));
        //bool iAmAlive;
        //return timeNow;
        // if (timeNow > (timestamp + interval) ){

        if(timeNow > (lastAlive + interval) ){
        return "OK to distribute";
        }else {
        return "Not time yet!";
        }

        //return timeNow;
    }

    /// @notice  Get last alive timestamp
    /// @param  _custId Property to which the sender address is added as a tenant
    /// @return  Last alive timestamp.
    function getLastAlive(uint _custId) public view returns (uint) {
        Will will = wills[_custId];
        uint lastAlive = will.getLastAlive();
        return lastAlive;
    }

    /// @notice  Set last alive timestamp
    /// @param  _custId Property to which the sender address is added as a tenant
    /// @return  Last alive timestamp.
    function setLastAlive(uint _custId) public {
        // 
        Will will = wills[_custId];
        uint timeNow = block.timestamp;
        will.setLastAlive(timeNow);
        emit LogAlive(msg.sender, timeNow);

    }

    /// @notice get Driver count
    /// @param _custId Property to which the sender address is added as a tenant
    /// @dev Check for exact payment sum to avoid having to send ETH back to sender
    function distributeBenefits(uint _custId) public {
        Will will = wills[_custId];
        uint timeNow = block.timestamp;
        will.distributeBenefits();
        emit LogDistribution(msg.sender, timeNow);
    }

    

}
