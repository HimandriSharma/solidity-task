// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./PaymentToken.sol";
import "./ChampionNFT.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GuessingGame is Ownable {
    PaymentToken public token;
    ChampionNFT public nft;
    uint256 public entranceFee;
    address public previousPlayer;
    uint256 public previousGuess;
    bool public gameStarted;

    mapping(address => bool) public hasPlayed;

    event GameStarted(uint256 guess);
    event PlayerGuessed(address player, uint256 guess, bool won);

    constructor(address _token, address _nft) Ownable(msg.sender) {
        token = PaymentToken(_token);
        nft = ChampionNFT(_nft);
    }

    function setEntranceFee(uint256 _fee) external onlyOwner {
        entranceFee = _fee;
    }

    function startGame(uint256 guessNumber) external onlyOwner {
        require(!gameStarted, "Game already started");
        previousPlayer = msg.sender;
        previousGuess = guessNumber;
        gameStarted = true;
        emit GameStarted(guessNumber);
    }

    function guess(uint256 color) external {

        require(gameStarted, "Game not started");
        require(!hasPlayed[msg.sender], "Player can only play once");
        
        require (color<2, "Invalid color");

        hasPlayed[msg.sender] = true;
        require(
            token.transferFrom(msg.sender, address(this), entranceFee),
            "Entrance fee required"
        );

        if (
            previousGuess == color
        ) {
            // Previous player wins
            token.transfer(previousPlayer, entranceFee * 2);
            nft.mint(previousPlayer);
            emit PlayerGuessed(previousPlayer, previousGuess, true);
        } else {
            // Previous player loses
            emit PlayerGuessed(previousPlayer, previousGuess, false);
        }

        // Set current player as previous player for next round
        previousPlayer = msg.sender;
        previousGuess = color;
    }
}
