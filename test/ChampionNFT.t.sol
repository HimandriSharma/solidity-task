// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import "forge-std/Test.sol";
import "./TestSetup.sol";

contract ChampionNFTTest is TestSetup {
    

    function setUp() public {
        setUpTest();
    }

    function testMinting() public {
        vm.startPrank(address(game));
        nft.mint(user);
        assertEq(nft.ownerOf(0), user);
        vm.stopPrank();
    }

    function testNonTransferability() public {
        vm.startPrank(address(game));
        nft.mint(user);
        vm.stopPrank();
        vm.startPrank(user);
        vm.expectRevert("Transfer of NFT not allowed");
        nft.transferFrom(user, user2, 0);
        vm.stopPrank();
    }
}
