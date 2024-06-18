// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract PaymentToken is ERC20, Ownable {
    constructor() ERC20("GameToken", "GT") {}

    function mint() external payable {
        require(msg.value > 0, "Must send ETH to mint tokens");
        _mint(msg.sender, msg.value);
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
