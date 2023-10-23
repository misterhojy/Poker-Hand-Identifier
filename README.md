# Poker-Hand-Identifier
Identify Poker hands in Low Level Assembly. MIPS. 




The P operation expects the second command-line argument to be a string of exactly five characters that encodes a non-standard, five-card hand from draw poker. All cards in the hand are unique.

The program must be able to identify some of the non-standard hands of five-card draw poker and print a message indicating which one it found. If the hand can be matched with two or more hands, the hand of highest rank is printed. If none of these four ranked hands is identified, the program prints the string at the label unknown_hand_str. 

You may assume that when the P operation has been provided, the second argument always contains exactly 5 characters and that the 5 characters represent valid playing cards. For the purposes of this assignment, an Ace is always treated as a low card (i.e., less than 2), never as a high card (i.e., higher than King). The hand ranks from highest-to-lowest, along with the relevant MIPS string to print, are:

Rank
Hand name
Label for string to print
Output on screen
1
Straight (only consider the rank; ignore the suit)
straight_str
STRAIGHT_HAND
2
Four of a kind (four cards of the same rank)
four_str
FOUR_OF_A_KIND_HAND
3
Two pair (two pairs of cards of different ranks)
pair_str
TWO_PAIR_HAND
4
Everything else
unknown_hand_str
UNKNOWN_HAND


We will not distinguish between simple straights, straight flushes and royal flushes. Treat all such hands as straights. A straight may not wrap-around (e.g., JQKA2 is not a straight).

A single card is encoded as an ASCII character. Specifically, the ASCII code ranges employed are:
0x31 - 0x3D represent the A through K of Clubs
0x41 - 0x4D represent the A through K of Spades
0x51 - 0x5D represent the A through K of Diamonds
0x61 - 0x6D represent the A through K of Hearts

Note that the left hexadecimal digit encodes the suit, and the right digit encodes the rank. Valid ranks range 1 - 13 (0x1 - 0xD). Note that 11, 12 and 13 (0xB, 0xC, 0xD) correspond with Jack, Queen and King, respectively.

For example, 0x63 represents the 3 of Hearts and corresponds with the ASCII character ‘c’. Likewise, 0x4B represents the Jack of Spades and corresponds with the ASCII character ‘K’.

An example of a valid hand would be the string “bHKaT”, which have ASCII codes:
0x62 = 2 of Hearts
0x48 = 8 of Spades
0x4B = Jack of Spades
0x61 = Ace of Hearts
0x54 = 4 of Diamonds
