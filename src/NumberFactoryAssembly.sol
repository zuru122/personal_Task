// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

contract NumberFactory {
    event YYY(address n);

    function registerNumber(uint256 _no) external {
        // --- Step 1: Compute the salt using keccak256 of the number ---
        bytes32 salt;
        assembly {
            // Store _no in scratch memory at position 0x00, then hash it
            mstore(0x00, _no)
            salt := keccak256(0x00, 0x20)  // hash 32 bytes starting at 0x00
        }

        // --- Step 2: Get the creation bytecode of NumberChildren ---
        // We must ABI-encode the constructor arg (_no) and append it to the bytecode
        bytes memory bytecode = abi.encodePacked(
            type(NumberChildren).creationCode,
            abi.encode(_no)
        );

        // --- Step 3: Deploy using CREATE2 in assembly ---
        address deployed;
        assembly {
            deployed := create2(
                0,                   // 0 ETH sent to child on deploy
                add(bytecode, 0x20), // pointer to actual bytecode (skip 32-byte length prefix)
                mload(bytecode),     // length of bytecode
                salt                 // our computed salt
            )

            // If deployed address is zero, deployment failed → revert
            if iszero(deployed) {
                revert(0, 0)
            }
        }

        emit YYY(deployed);
    }
}

contract NumberChildren {
    uint256 ownerNumber;

    constructor(uint256 _no) {
        ownerNumber = _no;
    }

    function checkHash() public view returns (bytes32 r) {
        // Assembly version of: keccak256(abi.encodePacked(ownerNumber))
        assembly {
            // ownerNumber is at storage slot 0
            let val := sload(0)      // read ownerNumber from storage slot 0

            mstore(0x00, val)        // store the value in memory at 0x00
            r := keccak256(0x00, 0x20) // hash 32 bytes → same result as Solidity version
        }
    }
}