// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/ChampionNFT.sol";
import "../src/GameLogic.sol";
import "../src/PaymentToken.sol";

contract TestSetup is Test {
    address public owner = vm.addr(1);
    address public player1 = vm.addr(2);
    address public player2 = vm.addr(3);
    address public user = vm.addr(4);
    address public user2 = vm.addr(5);
    ChampionNFT public nft;
    GuessingGame public game;
    PaymentToken public token;

    function setUpTest() public {
        vm.deal(owner, 100 ether);
        vm.deal(player1, 100 ether);
        vm.deal(player2, 100 ether);
        vm.deal(user, 100 ether);
        vm.deal(user2, 100 ether);

        vm.startPrank(owner);
        token = new PaymentToken();
        nft = new ChampionNFT();
        game = new GuessingGame(address(token), address(nft));
        nft.setGameLogicContractAddress(address(game));
        token.mint{value: 100 ether}();
        token.transfer(address(game), 3 ether);
        game.setEntranceFee(1 ether);
        vm.stopPrank();
    }
}
