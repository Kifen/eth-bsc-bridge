// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC20.sol";

contract Bridge {
  address public token;
  mapping(address => mapping(bytes32 => bool)) public crosssChainFills;
  event TransferAccrossChain(address indexed _from, address indexed _to, bytes32 indexed sig, uint256 _amount);

  constructor(address _token) {
    token = _token;
  }


  function sendAccrossChain(bytes32 signature, uint256 amount, address _to, uint256 nonce, address _contract) public returns (bool) {

  }
}