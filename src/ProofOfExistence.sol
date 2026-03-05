// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

contract ProofOfExistence {
    // store a document hash
    struct Document {
        uint16 id;
        bytes32 hashes;
        string description;
        uint256 stamp;
    }

    Document[] public documents;
    mapping(address => Document[]) public addressToDocuments;
    mapping(bytes32 => bool) public unique;
    mapping(bytes32 => mapping(address => bool)) public userDocumentExist;
    address[] public documentAddress;
    // mapping(address => bool) userExist;

    event Registered(uint256 timeStamp, address indexed _sender);

    function addDocument(bytes32 _documentHash, string memory _description) public {
        require(!unique[_documentHash], "User Document Exist");
        Document memory newDoc = Document({
            id: uint16(addressToDocuments[msg.sender].length + 1),
            hashes: bytes32(_documentHash),
            description: _description,
            stamp: block.timestamp
        });

        addressToDocuments[msg.sender].push(newDoc);
        documents.push(newDoc);
        unique[_documentHash] = true;
        userDocumentExist[_documentHash][msg.sender] = true;
    }

    function verifyDocumentExistence(bytes32 _documentHash) public view returns (bool) {
        require(userDocumentExist[_documentHash][msg.sender], "Document does not exist");
        return true;
    }

    function getDocument() public view returns (Document[] memory) {
        return addressToDocuments[msg.sender];
    }

    function getAllDocuments() public view returns (Document[] memory) {
        return documents;
    }
}
