// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract ChampionNFT is ERC721, Ownable {
    uint256 public nextTokenId;
    mapping(uint256 => address) public tokenOwners;

    constructor() ERC721("ChampionNFT", "CNFT") {}

    function mint(address to) external onlyOwner {
        uint256 tokenId = nextTokenId;
        _mint(to, tokenId);
        tokenOwners[tokenId] = to;
        nextTokenId++;
    }

    function _update(address from, address to, uint256 tokenId) internal virtual{
        require(from == address(0), "Transfer of NFT not allowed");
        super._update(from, tokenId, to);
    }
}
