// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/2.GuessTheSecretNumber.sol";

contract CounterTest is Test {
    GuessTheSecretNumber public target;
    address player = vm.addr(1);

    function setUp() public {
        target = new GuessTheSecretNumber{value: 1 ether}();
        vm.label(address(target), "Target");
        vm.label(player, "Player");
        vm.deal(player, 1 ether);
    }

    function testGuess() public {
        bytes32 answerHash = 0xdb81b4d58595fbbbb592d3661a34cdca14d7ab379441400cbfa1b78bc447c365;
        uint8 answer;
        for (uint8 i; i < type(uint8).max; ++i) {
            if (keccak256(abi.encodePacked(i)) == answerHash) {
                answer = i;
                break;
            }
        }
        vm.startPrank(player);
        target.guess{value: 1 ether}(answer);
        assertTrue(target.isComplete());
    }
}
