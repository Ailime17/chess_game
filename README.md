# chess_game
Command line game of chess.

To view on replit.com: https://replit.com/@TOPstudent/gameofchess?v=1

Assignment from <a href="https://www.theodinproject.com">The Odin Project</a>:

1.Build a command line Chess game where two players can play against each other.
The game should be properly constrained – it should prevent players from making illegal moves and declare check or check mate in the correct situations.

2.Make it so you can save the board at any time (remember how to serialize?)

3.Write tests for the important parts. You don’t need to TDD it (unless you want to), but be sure to use RSpec tests for anything that you find yourself typing into the command line repeatedly.

4.Do your best to keep your classes modular and clean and your methods doing only one thing each. This is the largest program that you’ve written, so you’ll definitely start to see the benefits of good organization (and testing) when you start running into bugs.

5.Have fun! Check out the unicode characters for a little spice for your gameboard.

6.(Optional extension) Build a very simple AI computer player (perhaps who does a random legal move)


If I was to improve the project in the future, I would make these changes:
*** Improve speed of the program and preserve more memory:
a) Use symbols instead of strings wherever they can be replaced.
b) Use  .freeze  for strings, hashes & arrays that don't change during the game.
*** Tidy up inside the lib/ directory: Put all files with classes for the chess pieces in one folder (pieces/).
*** Improve the game against the computer experience: Implement the  sleep  method to make the computer make a move in a more realistic - slower - way.
*** Make code more elegant: Use  .dup  instead of copying square coordinates in a more complicated way.