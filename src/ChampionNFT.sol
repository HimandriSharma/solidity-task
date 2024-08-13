// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ChampionNFT is ERC721, Ownable {
    uint256 public nextTokenId;
    address public gameLogicContractAddress;
    mapping(uint256 => address) public tokenOwners;

    constructor() ERC721("ChampionNFT", "CNFT") Ownable(msg.sender) {
        // gameLogicContractAddress = _gameLogicContractAddress;
    }
    function setGameLogicContractAddress(address _gameLogicContractAddress) external onlyOwner {
        gameLogicContractAddress = _gameLogicContractAddress;
    }

    function mint(address to) external {
        require(msg.sender == gameLogicContractAddress, "Only game logic contract can mint NFTs");
        uint256 tokenId = nextTokenId;
        _mint(to, tokenId);
        tokenOwners[tokenId] = to;
        nextTokenId++;
    }

    function _update(address to, uint256 tokenId, address auth) internal override returns (address) {
        address from = _ownerOf(tokenId);
        require(from == address(0), "Transfer of NFT not allowed");
        super._update(to, tokenId, auth);
    }
}
