// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

contract NumberFactory {
    event YYY(address n);

    function registerNumber(uint256 _no) external {
        // deploy  clone
        bytes32 y = keccak256(abi.encodePacked(_no));
        NumberChildren n = new NumberChildren{salt: y}(_no);
        emit YYY(address(n));
    }
}

contract NumberChildren {
    uint256 ownerNumber;

    constructor(uint256 _no) {
        ownerNumber = _no;
    }

    function checkHash() public view returns (bytes32 r) {
        r = keccak256(abi.encodePacked(ownerNumber));
    }
}
