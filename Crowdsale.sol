pragma solidity ^0.5.17;

import "./NextToken.sol";

contract NextCrowdsaleContract {
    address admin;
    NextToken public token;
    uint256 public tokenPrice;
    uint256 public tokensSold;

    event Sell(address _buyer, uint256 _amount);

    constructor (NextToken _token, uint256 _tokenPrice) public {
        admin = msg.sender;
        token = _token;
        tokenPrice = _tokenPrice;
    }

    function multiply(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x);
    }

    function buyTokens(uint256 _numberOfTokens) public payable {
        require(msg.value == multiply(_numberOfTokens, tokenPrice));
        require(tokenContract.balanceOf(this) >= _numberOfTokens);
        require(tokenContract.transfer(msg.sender, _numberOfTokens));

        tokensSold += _numberOfTokens;

        Sell(msg.sender, _numberOfTokens);
    }

    function endSale() public {
        require(msg.sender == admin);
        require(token.transfer(admin, token.balanceOf(this)));

        // Just transfer the balance to the admin
        admin.transfer(address(this).balance);
    }
}
