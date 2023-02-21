// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/3.GuessTheRandomNumber.sol";

contract CounterTest is Test {
    GuessTheRandomNumber public target;
    address player = vm.addr(1);

    function setUp() public {
        target = new GuessTheRandomNumber{value: 1 ether}();
        vm.label(address(target), "Target");
        vm.label(player, "Player");
        vm.deal(player, 1 ether);
    }

    function testGuess() public {
        uint8 answer = uint8(uint256(vm.load(address(target), 0)));
        vm.startPrank(address(player));
        target.guess{value: 1 ether}(answer);
        assertTrue(target.isComplete());
    }
}
