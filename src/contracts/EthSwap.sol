pragma solidity ^0.5.16;

import "./Token.sol";

contract EthSwap {
   string public name = "EthSwap.Instant.Exchange";
   Token public token;
   uint public rate = 100;

event TokensPurchased(
  address account,
  address token,
  uint amount,
  uint rate
);

event TokensSold(
  address account,
  address token,
  uint amount,
  uint rate
);

   constructor(Token _token) public {
     token = _token;
   }

   function buyTokens() public payable {
     //calculate the number of tokens to buy
     uint tokenAmount = msg.value * rate;

     //require that EthSwaphas enough tokens
     require(token.balanceOf(address(this)) >= tokenAmount);

     //transfer token to the user
     token.transfer(msg.sender, tokenAmount);

     //Emit an event
     emit TokensPurchased(msg.sender, address(token), tokenAmount, rate);

   }

   function sellTokens(uint _amount) public {
      //user cant sell tokens than they have
      require(token.balanceOf(msg.sender) >= _amount);

      //calculate the amount of Ether to redeem
      uint etherAmount = _amount / rate;

       //require that EthSwaphas enough tokens
      require(address(this).balance >= etherAmount);

      // perform sale
      token.transferFrom(msg.sender, address(this), _amount);
      msg.sender.transfer(etherAmount);

      //Emit an event
      emit TokensSold(msg.sender, address(token), _amount, rate);
   }
}
