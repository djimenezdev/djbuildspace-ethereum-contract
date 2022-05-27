// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.4;
import "hardhat/console.sol";

contract WavePortal {
    uint256 public totalWaves;
    /*
     * We will be using this below to help generate a random number
     */
    uint256 private seed;
    mapping(address => uint256) private wavesToAddress;
    mapping(address => uint256) private minutesToWave;

    event NewWave(
        address indexed from,
        uint256 timestamp,
        string message,
        string winWon
    );

    /*
     * I created a struct here named Wave.
     * A struct is basically a custom datatype where we can customize what we want to hold inside it.
     */
    struct Wave {
        address waver; // The address of the user who waved.
        string message; // The message the user sent.
        uint256 timestamp; // The timestamp when the user waved.
        string wonWave;
    }

    Wave[] private waves;

    constructor() payable {
        console.log("Yo yo, I am a contract and I am smart");
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _message) public {
        require(
            minutesToWave[msg.sender] + 4 minutes < block.timestamp,
            "Wait 4 minutes before you can wave again"
        );
        minutesToWave[msg.sender] = block.timestamp;
        totalWaves += 1;
        wavesToAddress[msg.sender]++;
        seed = (block.difficulty + block.timestamp + seed) % 100;
        if (seed <= 20) {
            console.log("%s won!", msg.sender);
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            address payable waveSender = payable(msg.sender);
            waveSender.transfer(prizeAmount);
            waves.push(
                Wave(
                    msg.sender,
                    _message,
                    block.timestamp,
                    "won the prize of 0.0001 ether"
                )
            );
            emit NewWave(
                msg.sender,
                block.timestamp,
                _message,
                "won the prize of 0.0001 ether" 
            );
        } else {
            waves.push(
                Wave(msg.sender, _message, block.timestamp, "didn't win")
            );
            emit NewWave(msg.sender, block.timestamp, _message, "didn't win");
        }
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }

    function getWalletWaves() public view returns (uint256) {
        console.log("You have %d total waves", wavesToAddress[msg.sender]);
        return wavesToAddress[msg.sender];
    }

    function getWavesMessages() public view returns (Wave[] memory) {
        return waves;
    }

    function getWaveWaitTime() public view returns (uint256) {
        return minutesToWave[msg.sender];
    }
}
