// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

contract RockPaperScissors {
    enum Move { None, Rock, Paper, Scissors }

    struct Player {
        bytes32 commitment;
        Move move;
    }

    mapping(address => Player) public players;
    address public player1;
    address public player2;
    bool public gameEnded;

    event GameResult(address winner, Move move1, Move move2);

    constructor(address _player1, address _player2) {
        player1 = _player1;
        player2 = _player2;
    }

    function commitMove(Move _move, uint nonce) external {
        require(msg.sender == player1 || msg.sender == player2, "Not a player");
        require(players[msg.sender].commitment == 0, "Move already committed");

        bytes32 commitment = keccak256(abi.encode(_move, nonce));
        players[msg.sender].commitment = commitment;
    }

    function revealMove(Move _move, uint nonce) external {
        require(players[msg.sender].commitment != 0, "Move not committed");
        require(keccak256(abi.encode(_move, nonce)) == players[msg.sender].commitment, "Move does not match commitment");

        players[msg.sender].move = _move;

        if (players[player1].move != Move.None && players[player2].move != Move.None) {
            determineWinner();
        }
    }

    function determineWinner() private {
        require(!gameEnded, "Game already ended");

        Move move1 = players[player1].move;
        Move move2 = players[player2].move;

        address winner;

        if (move1 == move2) {
            winner = address(0);
        } else if ((move1 == Move.Rock && move2 == Move.Scissors) ||
                   (move1 == Move.Scissors && move2 == Move.Paper) ||
                   (move1 == Move.Paper && move2 == Move.Rock)) {
            winner = player1;
        } else {
            winner = player2;
        }

        gameEnded = true;
        emit GameResult(winner, move1, move2);
    }
}