// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/1.GuessTheNumber.sol";

contract CounterTest is Test {
    GuessTheNumber public target;
    address player = vm.addr(1);

    function setUp() public {
        target = new GuessTheNumber{value: 1 ether}();
        vm.label(player, "Player");
        vm.label(address(target), "Target");
        vm.deal(player, 1 ether);
    }

    function testGuess() public {
        vm.startPrank(player);
        target.guess{value: 1 ether}(42);
        assertTrue(target.isComplete());
    }
}
