// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./TestSetup.sol";

contract GameLogicTest is TestSetup {
    function setUp() public {
        setUpTest();
        vm.prank(player1);
        token.mint{value: 50 ether}();
        vm.prank(player2);
        token.mint{value: 50 ether}();

        vm.startPrank(player1);
        token.approve(address(game), 5 ether);
        vm.stopPrank();

        vm.startPrank(player2);
        token.approve(address(game), 5 ether);
        vm.stopPrank();
    }

    function testSetEntranceFee() public {
        vm.startPrank(owner);
        game.setEntranceFee(1 ether);
        assertEq(game.entranceFee(), 1 ether);
        vm.stopPrank();
    }

    function testStartGame() public {
        vm.startPrank(owner);
        game.startGame(0); // Assuming 0 represents 'red'
        assertEq(game.previousPlayer(), owner);
        assertEq(game.previousGuess(), 0);
        vm.stopPrank();
    }

    function testPlayerWin() public {
        vm.startPrank(owner);
        game.startGame(0);
        vm.stopPrank();

        vm.startPrank(player1);
        game.guess(0);
        assertEq(token.balanceOf(player1), 51 ether); // Double the entrance fee
        assertEq(nft.ownerOf(0), player1); // Check if player1 received the NFT
        vm.stopPrank();
    }

    function testPlayerLose() public {
        vm.startPrank(owner);
        game.startGame(0);
        vm.stopPrank();

        vm.startPrank(player1);
        game.guess(1); //Assuming 1 represents 'black'
        assertEq(token.balanceOf(player1), 49 ether); // Should not lose tokens as it's a new game
        vm.stopPrank();
    }

    function testPlayerCanOnlyPlayOnce() public {
        vm.startPrank(owner);
        game.startGame(0);
        vm.stopPrank();

        vm.startPrank(player1);
        game.guess(0);
        vm.expectRevert("Player can only play once");
        game.guess(1); // Trying to play again
        vm.stopPrank();
    }

    function testOnlyOwnerCanStartGame() public {
        vm.expectRevert();
        vm.startPrank(player1);
        game.startGame(1);
        vm.stopPrank();
    }
}
