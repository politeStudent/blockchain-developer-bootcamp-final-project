const env = require("../env.json");
const blockWillAddr = env.DEPLOYEDCONTRACTID;
var web3 = new Web3(window.ethereum);
var ssABI = [];

window.addEventListener("load", function () {
  // for parcel
  const data = require("/build/contracts/willFactory.json");
  ssABI.push(data.abi); // Only the abi is needed.
  //console.log("abi from fetch...");
  //console.log(ssABI);

  // // for VS code 'Go Live'
  // fetch("./build/contracts/will.json")
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
      var web3 = new Web3(window.ethereum);
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

// withdraw and close out
const ssWithdraw = document.getElementById("ss-withdraw-button");
ssWithdraw.onclick = async () => {
  var web3 = new Web3(window.ethereum);
  const blockWill = new web3.eth.Contract(ssABI[0], blockWillAddr);
  blockWill.setProvider(window.ethereum);
  var cust = await blockWill.methods.get(ethereum.selectedAddress).call();
  //console.log("custWillID ", cust);
  var value = await blockWill.methods
    .withdraw(cust)
    .send({ from: ethereum.selectedAddress });

  //console.log("value ", JSON.stringify(value));
};

const ssGetLife = document.getElementById("ss-check4life");
ssGetLife.onclick = async () => {
  var web3 = new Web3(window.ethereum);
  const blockWill = new web3.eth.Contract(ssABI[0], blockWillAddr);
  blockWill.setProvider(window.ethereum);
  var cust = await blockWill.methods.get(ethereum.selectedAddress).call();
  var value = await blockWill.methods.check4Life(cust).call();
  //console.log(value);
  const ssDisplayValue = document.getElementById("ss-display-life");
  ssDisplayValue.innerHTML = "#: " + value;
  // make button visible
  let element = document.getElementById("ss-distribute-button");
  if (value == "OK to distribute") {
    element.removeAttribute("hidden");
  } else {
    element.setAttribute("hidden", "hidden");
  }
};

// get lastAlive
const ssGetLastAlive = document.getElementById("ss-get-life");
ssGetLastAlive.onclick = async () => {
  var web3 = new Web3(window.ethereum);
  const blockWill = new web3.eth.Contract(ssABI[0], blockWillAddr);
  blockWill.setProvider(window.ethereum);
  var cust = await blockWill.methods.get(ethereum.selectedAddress).call();
  var value = await blockWill.methods.getLastAlive(cust).call();
  //console.log(value);
  var formattedTime = timeConverter(value);
  const ssDisplayValue = document.getElementById("ss-display-lastAlive");
  ssDisplayValue.innerHTML = "Last Alive time: " + formattedTime;
};

// mark alive:
const ssLife = document.getElementById("ss-set-life");
ssLife.onclick = async () => {
  var web3 = new Web3(window.ethereum);
  const blockWill = new web3.eth.Contract(ssABI[0], blockWillAddr);
  blockWill.setProvider(window.ethereum);
  var cust = await blockWill.methods.get(ethereum.selectedAddress).call();
  await blockWill.methods
    .setLastAlive(cust)
    .send({ from: ethereum.selectedAddress });
  document.getElementById("ss-display-life").value = "ok";
};

// distribute to beneficiaries
const ssDistribute = document.getElementById("ss-distribute-button");
ssDistribute.onclick = async () => {
  var web3 = new Web3(window.ethereum);
  const blockWill = new web3.eth.Contract(ssABI[0], blockWillAddr);
  blockWill.setProvider(window.ethereum);
  var cust = await blockWill.methods.get(ethereum.selectedAddress).call();
  var value = await blockWill.methods
    .distributeBenefits(cust)
    .send({ from: ethereum.selectedAddress });
};

// time converter
function timeConverter(UNIX_timestamp) {
  var a = new Date(UNIX_timestamp * 1000);
  var months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];
  var year = a.getFullYear();
  var month = months[a.getMonth()];
  var date = a.getDate();
  var hour = a.getHours();
  var min = a.getMinutes();
  var sec = a.getSeconds();
  var time =
    date + " " + month + " " + year + " " + hour + ":" + min + ":" + sec;
  return time;
}
