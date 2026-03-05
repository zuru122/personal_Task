// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.33;

import {Test, console2} from "forge-std/Test.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";
import {ProofOfExistence} from "../src/ProofOfExistence.sol";

contract ProofOfExistenceTest is Test {
    ProofOfExistence proofOfExistence;
    address bob = makeAddr("Bob");
    address alice = makeAddr("Alice");

    bytes32 myDocHash = keccak256(abi.encodePacked("Hello World"));

    function setUp() public {
        proofOfExistence = new ProofOfExistence();
        console.logBytes32(myDocHash);
    }

    function testAddDocument() public {
        vm.prank(bob);
        proofOfExistence.addDocument(myDocHash, "My first document");

        vm.prank(bob);
        assertTrue(proofOfExistence.verifyDocumentExistence(myDocHash));
    }

    function testGetDocument() public {
        vm.prank(alice);
        proofOfExistence.addDocument(myDocHash, "Alice's document");

        // vm.prank(alice);
        // ProofOfExistence.Document[] memory aliceDocs = proofOfExistence.getDocument();

        // assertEq(aliceDocs.length, 1);
        // assertEq(aliceDocs[0].description, "Alice's document");

        vm.prank(alice);
        ProofOfExistence.Document[] memory aliceDocs = proofOfExistence.getDocument();

        assertEq(aliceDocs.length, 1);
        assertEq(aliceDocs[0].description, "Alice's document");
    }
}
