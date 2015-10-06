# CLI Chess
## Overview
Chess game where two players can play on the command line. Game is written in Ruby and is broken up into Board, Game, Player and Pieces classes.

## Features
### Class Inheritance
Inheritance for pieces is established based on similarities in the way a piece moves. Sliding pieces and stepping pieces inherit from the Piece class. All stepping pieces inherit from SteppingPiece and all sliding pieces inherit from SlidingPiece.

### Validating Moves
In order to see if a move is valid, the board is deep duped to simulate the proposed move. If it's a valid move, the move is performed. On the contrary, if it's an invalid move, an error is raised and the player is asked to make a new move. 
