const env = require("../env.json");
const blockWillAddr = env.DEPLOYEDCONTRACTID;
var currentAccount;
var willContractAddr = "";
var web3 = new Web3(window.ethereum);
var ssABI = [];
const createBtn = document.getElementById("ss-create-button");
const ssSubmit = document.getElementById("ss-input-button");
const ssAddDriver = document.getElementById("ss-driver-button");
const allDrivers = document.getElementById("ss-getAllDrivers-button");

getOwner = async () => {
  var web3 = new Web3(window.ethereum);
  const blockWill = new web3.eth.Contract(ssABI[0], blockWillAddr);
  blockWill.setProvider(window.ethereum);
  var value = await blockWill.methods.owner().call();
  //console.log("owner: ", value);
};

window.addEventListener("load", function () {
  //console.log("inside dapp");

  // for parcel
  const data = require("/build/contracts/willFactory.json");
  //console.log("data: ", data);
  ssABI.push(data.abi); // Only the abi is needed.
  //console.log("abi from fetch...");
  //console.log(ssABI);

  // for vscode -go live
  // fetch("./build/contracts/WillFactory.json")
  //   .then((response) => {
  //     return response.json();
  //   })
  //   .then((data) => {
  //     //console.log(data); // This is the entire contract
  //     ssABI.push(data.abi); // Only the abi is needed.
  //     //console.log("abi from fetch...");
  //     //console.log(ssABI);
  //   });

  if (typeof window.ethereum !== "undefined") {
    //console.log("window.ethereum is enabled");
    if (window.ethereum.isMetaMask === true) {
      //console.log("MetaMask is active");
      let mmDetected = document.getElementById("mm-detected");
      mmDetected.innerHTML += "MetaMask Is Available!";
    } else {
      //console.log("MetaMask is not available");
      let mmDetected = document.getElementById("mm-detected");
      mmDetected.innerHTML += "MetaMask Not Available!";
    }
  } else {
    //console.log("window.ethereum is not found");
    let mmDetected = document.getElementById("mm-detected");
    mmDetected.innerHTML += "<p>MetaMask Not Available!<p>";
  }
});

// 'Get Started'
var web3 = new Web3(window.ethereum);
const mmEnable = document.getElementById("mm-connect");
mmEnable.onclick = async () => {
  //console.log("inside mmEnable.onclick ...");
  currentAccount = await ethereum.request({ method: "eth_requestAccounts" });
  var web3 = new Web3(window.ethereum);
  const blockWill = new web3.eth.Contract(ssABI[0], blockWillAddr);
  blockWill.setProvider(window.ethereum);

  var Evalue = await blockWill.methods
    .enrolled(ethereum.selectedAddress)
    .call();
  //console.log("Evalue isEnrolled? ", Evalue);
  if (!Evalue) {
    //console.log("Not enrolled. Enrolling...");
    var x = await blockWill.methods
      .enroll()
      .send({ from: ethereum.selectedAddress });
  } else {
    //console.log("Already registered!");
    alert("Already Registered!" + "\nGetting Will..");
  }
  var custId = await blockWill.methods.get(ethereum.selectedAddress).call();
  //console.log("custId: ", custId);
  refreshSidebar(custId);
};

// create will
createBtn.onclick = async () => {
  //console.log("clicked createBtn...");
  ////console.log(ssABI);
  var web3 = new Web3(window.ethereum);
  const blockWill = new web3.eth.Contract(ssABI[0], blockWillAddr);
  blockWill.setProvider(window.ethereum);

  const ssInputValue = document.getElementById("ss-input-name").value;
  //console.log(ssInputValue);
  if (ssInputValue == "") {
    alert("Please Enter Will Name");
  }

  var willBool = await blockWill.methods
    .hasWill(ethereum.selectedAddress)
    .call();
  //console.log("create-Has will? willBool: ", willBool);

  // var value = await blockWill.methods.get(ethereum.selectedAddress).call();
  if (!willBool) {
    var value = await blockWill.methods
      .create(ethereum.selectedAddress, ssInputValue)
      .send({ from: ethereum.selectedAddress });
    //console.log("value ", value);
    // var ssDisplayValue = document.getElementById("ss-create-display");
    // ssDisplayValue.innerHTML = "" ;
    document.getElementById("ss-input-name").value = "";
    // willCreated = 1;
  } else {
    alert("You have a will. Currently, one will per address.");
    document.getElementById("ss-input-name").value = "";
    return;
  }
  refreshSidebar(ethereum.selectedAddress);
};

// deposit value
// grab the button for deposit input to a contract, and submit deposit:
ssSubmit.onclick = async () => {
  //console.log("inside send deposit value input...");
  //console.log("abi from var...");
  //console.log(ssABI);
  // get value from input
  const ssInputValue = document.getElementById("ss-input-box").value;
  //console.log(ssInputValue);
  var web3 = new Web3(window.ethereum);
  // instantiate smart contract instance
  const blockWill = new web3.eth.Contract(ssABI[0], blockWillAddr);
  blockWill.setProvider(window.ethereum);

  var toAddr = willContractAddr;
  await web3.eth.sendTransaction({
    to: toAddr,
    from: ethereum.selectedAddress,
    value: ssInputValue,
  });
  //  clear the input field
  document.getElementById("ss-input-box").value = "";
  refreshSidebar(ethereum.selectedAddress);
};

// Add Driver
ssAddDriver.onclick = async () => {
  //console.log("abi from var...");
  const ssInputValue = document.getElementById("ss-input-driver").value;
  //console.log(ssInputValue);
  var web3 = new Web3(window.ethereum);
  const blockWill = new web3.eth.Contract(ssABI[0], blockWillAddr);
  blockWill.setProvider(window.ethereum);
  var cust = await blockWill.methods.get(ethereum.selectedAddress).call();
  //console.log("custWillID ", cust);
  await blockWill.methods
    .setDriver(cust, ssInputValue)
    .send({ from: ethereum.selectedAddress });
  document.getElementById("ss-input-driver").value = "";
  refreshSidebar(ethereum.selectedAddress);
};

// get all drivers
allDrivers.onclick = async () => {
  //console.log("clicked ss-driverCount-button...");
  var web3 = new Web3(window.ethereum);
  const blockWill = new web3.eth.Contract(ssABI[0], blockWillAddr);
  blockWill.setProvider(window.ethereum);
  var cust = await blockWill.methods.get(ethereum.selectedAddress).call();
  //console.log("custWillID ", cust);
  var benefs = await blockWill.methods.getAllDrivers(cust).call();
  //console.log("value ", benefs);
  var ssDisplayValue = document.getElementById("ss-getAllDrivers-output");
  ssDisplayValue.innerHTML = "Beneficiaries: \n" + benefs;
};

async function refreshSidebar(custId) {
  //console.log("inside refresh ...");
  //console.log("custId: ", custId);

  var web3 = new Web3(window.ethereum);
  const blockWill = new web3.eth.Contract(ssABI[0], blockWillAddr);
  blockWill.setProvider(window.ethereum);

  var willBool = await blockWill.methods
    .hasWill(ethereum.selectedAddress)
    .call();
  //console.log("refresh- Has will? willBool: ", willBool);

  if (willBool) {
    var cust = await blockWill.methods.get(ethereum.selectedAddress).call();
    //console.log("custWillID ", cust);
    var beneCount = await blockWill.methods.getDriverCount(cust).call();
    var willInstance = await blockWill.methods
      .getWill(cust)
      .call({ from: ethereum.selectedAddress });

    //console.log("values ", willInstance);
    //console.log("owner ", willInstance.willOwner);
    //console.log("name ", willInstance.name);
    //console.log("willAddr ", willInstance.willAddr);
    willContractAddr = willInstance.willAddr;
    //console.log("balance ", willInstance.balance);
    //console.log(beneCount);
  } else {
    //console.log("No willBool ");
    //console.log(ethereum.selectedAddress);
    var willInstance = {};
    willInstance.name = "";
    willInstance.willOwner = ethereum.selectedAddress;
    willInstance.willAddr = "NA";
    willInstance.balance = "NA";
    //console.log(willInstance);
  }

  const willInfo = document.getElementById("sidebar");
  willInfo.innerHTML =
    "Will Name: " +
    willInstance.name +
    "<br>" +
    "Owner Address: " +
    willInstance.willOwner +
    "<br>" +
    "Cust ID: " +
    cust +
    "<br>" +
    "Will Contract Address: " +
    willInstance.willAddr +
    "<br>" +
    "Balance: " +
    willInstance.balance +
    "<br>" +
    "Beneficiaries: " +
    beneCount;
}
