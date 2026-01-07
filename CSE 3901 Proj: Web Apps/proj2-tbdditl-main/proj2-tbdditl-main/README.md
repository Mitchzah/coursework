# A Game of Set
Welcome to the terminal implementation of the card game Set! The main goal is for the players to identify as many sets of 3 as possible all while making sure the 4 attributes are all the same or all different.

## Authors:
TBDDITL
- Julio Sica-Perez
- Mitch Zahner
- Aashka Baruah
- Mark Ling

## Game rules:
→ Each card consists of four attributes. They are as follows:
- Number   : [1, 2, 3]
- Color    : [Red, Green, Purple]
- Shape    : [Diamond, Squiggle, Oval]
- Shading  : [Solid, Stripped, Empty]

→ In order to determine a set..
- There must be three chosen cards.
- All card attributes must be the same or all card attributes must be   different.

## How to play:
1. The player is dealt 12 cards facing up. 
2. The player choses 3 cards they deem to be a set.
3. The program determines whether it is a set.
4. In the case of a set, the dealt cards repopulates to make deck of 12.
5. The player is prompted to enter potential sets until the main deck runs out or the player quits by entering 'stop'.

## To Run:
1.  Clone the repository to your local machine:
    ```
    git clone https://github.com/cse3901-2025au-1020/proj2-tbdditl.git
    ```
2.  Navigate into the project directory:
    ```
    cd proj2-tbdditl
    ```
3.  Install all necessary gems, including the **colorize** gem, using Bundler:
    ```
    bundle install
    ```
4.  Run the game's main file:
    ```
    ruby set_game.rb
    ```

## Features:

Main Features:

- The game generates a deck of 81 cards from which 12 cards are displayed to  the player in a sequential order with its attributes listed. There will be 27 possible sets.
- The player is able to choose three cards at a time to test for a set. 
- If the player is able to successfully make a set, the program makes record of these cards and populates the current deck with more cards from the main deck.

Additional Features:

- Adds more cards to dealt deck if not sets are detected.
- Text for the Color Attributes are colorized with their corresponding colors.
- A timer that starts from the begining of the program.

## Project Structure:
- 'set_game.rb'     : the main loop
- 'card.rb'         : Card attributes
- 'card_handler'    : Method file
- 'prompt.rb'       : Instructions set
