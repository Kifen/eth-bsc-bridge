// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC1271.sol";

contract SigVerifier {

  function verifySignature(address recipient, address sender, uint256 amount, uint256 nonce, bytes memory signature) public view returns (bool) {
      // Recreate the message signed on the client
      bytes32 message = prefixed(keccak256(abi.encodePacked(sender, recipient, amount, nonce, this)));
      uint8 v;
      bytes32 r;
      bytes32 s;
      (v, r, s) = splitSignature(signature);
      address signerAddress = ecrecover(message, v, r, s);
      require(sender == signerAddress, "SigVerifier: Signer is not sender");
      return true;
  }

  function splitSignature(bytes memory _signature) internal pure returns (uint8, bytes32, bytes32) {
    require(_signature.length == 65, "SigVerifier: Invalid signature length");
    bytes32 r;
    bytes32 s;
    uint8 v;

    assembly {
      r := mload(add(_signature, 32))
      s := mload(add(_signature, 64))
      v := byte(0, mload(add(_signature, 96)))
    }

    return (v, r, s);
  }

  function prefixed(bytes32 hash) internal pure returns (bytes32) {
      return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
  }
}