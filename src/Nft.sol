// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {ERC721} from "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {Base64} from "../lib/openzeppelin-contracts/contracts/utils/Base64.sol";
import {Strings} from "../lib/openzeppelin-contracts/contracts/utils/Strings.sol";
import "./Vault.sol";

contract MyToken is ERC721 {
    uint256 private tokenIdCounter;

    mapping(uint256 => address) private vaultsAddress; // tokenId → vault
    mapping(address => uint256) private vaultTokenId; // vault → tokenId

    constructor() ERC721("VaultNFT", "VT") {}

    function safeMint(address to, address _vault) public {
        vaultsAddress[tokenIdCounter] = _vault;
        vaultTokenId[_vault] = tokenIdCounter;
        _mint(to, tokenIdCounter);
        tokenIdCounter++;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        address vaultAddr = vaultsAddress[tokenId];

        (
            string memory tokenName,
            string memory tokenSymbol,
            uint8 decimals,
            uint256 totalDeposits,
            address vaultAddress
        ) = Vault(vaultAddr).vaultInfo();

        string memory svg = _buildSVG(tokenName, tokenSymbol, decimals, totalDeposits, vaultAddress, tokenId);

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name":"',
                        tokenSymbol,
                        " Vault #",
                        Strings.toString(tokenId),
                        '",',
                        '"description":"On-chain vault for ',
                        tokenName,
                        '",',
                        '"image":"data:image/svg+xml;base64,',
                        Base64.encode(bytes(svg)),
                        '"}'
                    )
                )
            )
        );

        return string(abi.encodePacked("data:application/json;base64,", json));
    }

    function _buildSVG(
        string memory tokenName,
        string memory tokenSymbol,
        uint8 decimals,
        uint256 totalDeposits,
        address vaultAddress,
        uint256 tokenId
    ) internal pure returns (string memory) {
        return string(
            abi.encodePacked(
                '<svg xmlns="http://www.w3.org/2000/svg" width="400" height="240">',
                '<rect width="400" height="240" fill="#1a1a2e" rx="16"/>',
                '<text x="20" y="50" fill="white" font-size="24" font-weight="bold">',
                tokenSymbol,
                " Vault</text>",
                '<text x="20" y="80" fill="#aaa" font-size="13">',
                tokenName,
                "</text>",
                '<text x="20" y="130" fill="white" font-size="12">Total Deposits: ',
                Strings.toString(totalDeposits),
                "</text>",
                '<text x="20" y="160" fill="white" font-size="12">Decimals: ',
                Strings.toString(decimals),
                "</text>",
                '<text x="20" y="190" fill="#888" font-size="10">Vault: ',
                Strings.toHexString(uint160(vaultAddress), 20),
                "</text>",
                '<text x="20" y="220" fill="#555" font-size="10">NFT #',
                Strings.toString(tokenId),
                "</text>",
                "</svg>"
            )
        );
    }
}
