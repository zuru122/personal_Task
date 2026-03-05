// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.33;

import {Test, console2} from "forge-std/Test.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";
import {NumberFactory} from "../src/NumberFactoryAssembly.sol";

contract FactoryTestAssembly is Test {
    NumberFactory nFactory;

    function setUp() public {
        vm.prank(address(0xdead), address(0xdead));
        nFactory = new NumberFactory();
    }

    function testChildDep() external {
        vm.prank(address(0xdead), address(0xdead));
        nFactory.registerNumber(123456);
    }
}
