const main = async () => {
  const [owner, randomPerson, randomPerson2] = await hre.ethers.getSigners();
  const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
  const waveContract = await waveContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.001"),
  });
  await waveContract.deployed();
  console.log("Contract deployed to:", waveContract.address);
  console.log("Contract deployed by:", owner.address);

  let waveCount;
  waveCount = await waveContract.getTotalWaves();

  let waveTxn = await waveContract.wave("Hello this is a message!");
  await waveTxn.wait();

  waveCount = await waveContract.getTotalWaves();
  console.log("waves stored in waveCount: %s", waveCount);

  // a wave from a random person
  waveTxn = await waveContract
    .connect(randomPerson)
    .wave("Message from another user!");
  await waveTxn.wait();

  waveCount = await waveContract.getTotalWaves();

  // return waves from a specific user randomPerson2 via mapping
  waveTxn = await waveContract
    .connect(randomPerson2)
    .wave("Hey! I'll be able to see how many times I've waved to you!");
  await waveTxn.wait();

  let userWaveCount = await waveContract
    .connect(randomPerson2)
    .getWalletWaves();

  // get all wave messages

  let allWaves = await waveContract.getWavesMessages();
  console.log(allWaves);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0); // exit Node process without error
  } catch (error) {
    console.log(error);
    process.exit(1); // exit Node process while indicating 'Uncaught Fatal Exception' error
  }
  // Read more about Node exit ('process.exit(num)') status codes here: https://stackoverflow.com/a/47163396/7974948
};

runMain();
