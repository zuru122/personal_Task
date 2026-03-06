// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "../lib/forge-std/src/Test.sol";
import {console2} from "../lib/forge-std/src/console2.sol";
import "../src/VaultFactory.sol";
import "../src/Nft.sol";

contract VaultFactoryTest is Test {
    VaultFactory factory;
    MyToken nft;

    address USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    function setUp() public {
        vm.createSelectFork("https://eth-mainnet.g.alchemy.com/v2/ZE_JFcHdE8WB7w0eR_Zd3-W0zGmS74ZU");
        nft = new MyToken();
        factory = new VaultFactory(address(nft));
    }

    function testCreateVault() public {
        address predicted = factory.predictVaultAddress(USDC);

        address vault = factory.createVault(USDC);

        assertEq(predicted, vault);
    }

    function testDepositUSDC() public {
        address whale = 0x55FE002aefF02F77364de339a1292923A15844B8;

        address vault = factory.createVault(USDC);

        vm.startPrank(whale);

        IERC20(USDC).approve(vault, 1000e6);

        Vault(vault).deposit(1000e6);
        console2.log(nft.tokenURI(0));

        vm.stopPrank();
    }
}
