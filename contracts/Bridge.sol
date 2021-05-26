// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SigVerifier.sol";
import "./Token.sol";
import '@openzeppelin/contracts/access/Ownable.sol';

contract Bridge is SigVerifier,  Ownable{
  Token public token;  

  enum Action{Burn, Mint}
  event TransferAccrossChain(address indexed _from, address indexed _to, Action action, bytes indexed sig, uint256 _amount, uint256 _nonce);

  constructor(address _token) {
    token = Token(_token);
  }


  function sendAccrossChain(bytes memory signature, uint256 amount, address _to, uint256 nonce) public returns (bool) {
    address _from = msg.sender;
    require(verifySignature(_to, _from, amount, nonce, signature), "Bridge: unauthorized signature");

    token.burn(_from, amount);
    emit TransferAccrossChain(_from, _to, Action.Burn, signature, amount, nonce);
    return true;
  }

  function mint(bytes memory signature, uint256 amount, address _to, uint256 nonce) public onlyOwner() returns (bool) {
    address _from = msg.sender;
    require(verifySignature(_to, _from, amount, nonce, signature), "Bridge: unauthorized signature");

    token.mint(_to, amount);
    emit TransferAccrossChain(_from, _to, Action.Mint, signature, amount, nonce);
    return true;
  }
}