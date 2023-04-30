// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract Lottery{
 address public manager;
 address payable public winner;
 struct Player {
     address payable playadd;
     uint ticket;
     uint vote;
 }

 Player[] public players;

 struct Bettor {
     address payable betadd;
     uint bet;
 }

 Bettor[] public bettors;
 address payable[] public winp;
 address payable[] public winb;
 uint public digit;
 uint public start;

  constructor(){
      manager=msg.sender;
      start = 1;
  }

  function random() public view returns(uint){
      return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,players.length)));
  }

  function participate() public payable{
      require(start==1,"The game has not yet started");
      require(msg.value==1 ether,"Please pay 1 ether only");
      uint t = (random() % 9000)+1000;
      Player memory newp = Player(payable(msg.sender),t,1);
      players.push(newp);
  }

  function getBalance() public view returns(uint){
      require(manager==msg.sender,"You are not the manager");
      return address(this).balance;
  }

  function vote() public{
      for (uint i = 0; i < players.length; i++){
          if (players[i].playadd == msg.sender){
              players[i].vote = 1;
          }
      }
  }

  function unvote() public{
      for (uint i = 0; i < players.length; i++){
          if (players[i].playadd == msg.sender){
              players[i].vote = 0;
          }
      }
  }

  function bet(uint betnum) public payable{
      require(start==1,"The game has not yet started");
      uint repeat = 0;
      for (uint i = 0; i < bettors.length; i++){
          if (bettors[i].betadd == msg.sender){
              repeat = 1;
          }
      }
      require(repeat==0,"A bettor can bet for only one digit");
      require(betnum>=0 && betnum <=9,"Bettor can only bet on a single digit number");
      require(msg.value==1 ether,"Please pay 1 ether only");
      Bettor memory newb = Bettor(payable(msg.sender),betnum);
      bettors.push(newb);
  }

  function pickWinner() public{
      require(manager==msg.sender,"You are not the manager");
      require(start==1,"The game has not yet started");
      require(players.length>=3,"Players are less than 3");
      uint count = 0;
      for(uint i = 0; i < players.length; i++){
          if (players[i].vote == 1){
              count += 1;
          }
      }
      require(count>uint(players.length/2),"Majority of the players dont want to pick a winner");
      uint money = getBalance();
      uint r=random();
      digit = r % 10;
      for(uint i = 0; i < bettors.length; i++){
          if (bettors[i].bet == digit){
              winb.push(bettors[i].betadd);
              bettors[i].betadd.transfer(500000000000000000);
              money = money - 500000000000000000;
          }
      }  
      for (uint i = 0; i < players.length; i++){
          uint temp = players[i].ticket;
          while (temp > 0){
              if (temp%10 == digit){
                  winp.push(players[i].playadd);
                  players[i].playadd.transfer(500000000000000000);
                  money = money - 500000000000000000;
                  break;
              }
              temp = uint(temp/10);
          }
      }  
      uint index = r%players.length;
      winner=players[index].playadd;
      

      winner.transfer(money);
      start = 0;
  }

  function newgame()public {
      require(manager==msg.sender,"You are not the manager");
      require(start==0,"The game has already started");
      while (players.length > 0){
          players.pop();
      }
      while (bettors.length > 0){
          bettors.pop();
      }
      while (winp.length > 0){
          winp.pop();
      }
      while (winb.length > 0){
          winb.pop();
      }
      start = 1;
  }
}
