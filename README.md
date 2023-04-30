# Solidity-Lottery

This a Lottery smart contract. 

Manager: initiates a lottery draw and starts a new game.

Participant:  pays an entry fee and enters the lottery.  A 4-digit ticket number is assigned to each participant. A participant can vote for drawing the lottery or to wait. 

Bettor: bets on a single digit number. One bettor can bet only once. A bettor can be a participant or a member in the blockchain network.

Smart contract:  When a manager initiates lottery draw, smart contract checks if the number of participants is greater than 3 and if the majority of the participants have voted for lottery draw.  If these conditions are not met, the lottery is not drawn. If the conditions are met, the lottery draw process continues. A random single digit number is selected.  Any bettor to have bet on this number gets a reward.  All participants who have this digit in their ticket number get a reward.  Randomly a final winner is selected among all the participants.  This participant is declared as the winner of the lottery. 
The manager starts the lottery process all over again with new participants and new bettors.
