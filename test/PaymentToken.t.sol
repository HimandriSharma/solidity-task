// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import "forge-std/Test.sol";
import "./TestSetup.sol";

contract PaymentTokenTest is TestSetup {
   

    function setUp() public {
        setUpTest();
    }

    function testInitialSupply() public {
        assertEq(token.totalSupply(), 100 ether);
    }

    function testMinting() public {
        vm.startPrank(user);
        token.mint{value: 10 ether}();
        assertEq(token.balanceOf(user), 10 ether);
        vm.stopPrank();
    }

    function testWithdraw() public {
        vm.startPrank(owner);
        uint256 initialBalance = address(owner).balance;
        token.withdraw();
        assertEq(address(owner).balance, initialBalance + 100 ether);
        vm.stopPrank();
    }
}
