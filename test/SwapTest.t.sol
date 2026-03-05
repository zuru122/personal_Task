// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.33;

// import {Test, console2} from "forge-std/Test.sol";

// contract SwapTest is Test {
//     IUniswapV2Router01 router;
//     IERC20 usdc;
//     IERC20 weth;

//     address constant ROUTER_ADDRESS = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
//     address constant USDC_ADDRESS = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
//     address constant WETH_ADDRESS = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
//     address constant USDC_HOLDER = 0xf584F8728B874a6a5c7A8d4d387C9aae9172D621;

//     uint256 constant SWAP_AMOUNT = 1000e6; // 1000 USDC (6 decimals)

//     function setUp() public {
//         // vm.createFork('http://0xrpc.io/eth')
//         vm.createSelectFork("https://eth-mainnet.g.alchemy.com/v2/ZE_JFcHdE8WB7w0eR_Zd3-W0zGmS74ZU");

//         router = IUniswapV2Router01(ROUTER_ADDRESS);
//         usdc = IERC20(USDC_ADDRESS);
//         weth = IERC20(WETH_ADDRESS);
//     }

//     function testSwap() public {
//         // --- Arrange ---
//         uint256 usdcBalanceBefore = usdc.balanceOf(USDC_HOLDER);
//         uint256 wethBalanceBefore = weth.balanceOf(USDC_HOLDER);

//         console2.log("-----Before Swap-----");
//         console2.log("USDC Balance:", usdcBalanceBefore);
//         console2.log("WETH Balance:", wethBalanceBefore);

//         // Make sure holder actually has enough USDC
//         assertGe(usdcBalanceBefore, SWAP_AMOUNT, "Holder does not have enough USDC");

//         address[] memory path = new address[](2);
//         path[0] = USDC_ADDRESS;
//         path[1] = WETH_ADDRESS;

//         // --- Act ---
//         vm.startPrank(USDC_HOLDER);

//         usdc.approve(ROUTER_ADDRESS, SWAP_AMOUNT);

//         // Confirm allowance set correctly
//         assertEq(usdc.allowance(USDC_HOLDER, ROUTER_ADDRESS), SWAP_AMOUNT, "Allowance not set");

//         router.swapExactTokensForTokens(
//             SWAP_AMOUNT,
//             0,                          // amountOutMin - 0 means no slippage protection
//             path,
//             USDC_HOLDER,
//             block.timestamp + 2 minutes
//         );

//         vm.stopPrank();

//         // --- Assert ---
//         uint256 usdcBalanceAfter = usdc.balanceOf(USDC_HOLDER);
//         uint256 wethBalanceAfter = weth.balanceOf(USDC_HOLDER);

//         console2.log("\n-----After Swap-----");
//         console2.log("USDC Balance:", usdcBalanceAfter);
//         console2.log("WETH Balance:", wethBalanceAfter);

//         // USDC should have decreased
//         assertLt(usdcBalanceAfter, usdcBalanceBefore, "USDC balance should have decreased");

//         // WETH should have increased
//         assertGt(wethBalanceAfter, wethBalanceBefore, "WETH balance should have increased");

//         // Exact USDC spent should equal SWAP_AMOUNT
//         assertEq(usdcBalanceBefore - usdcBalanceAfter, SWAP_AMOUNT, "Wrong USDC amount spent");
//     }
// }

// interface IUniswapV2Router01 {
//     function factory() external pure returns (address);
//     function WETH() external pure returns (address);
//     function swapExactTokensForTokens(
//         uint256 amountIn,
//         uint256 amountOutMin,
//         address[] calldata path,
//         address to,
//         uint256 deadline
//     ) external returns (uint256[] memory amounts);
//     function getAmountsOut(uint256 amountIn, address[] calldata path) external view returns (uint256[] memory amounts);
// }

// interface IERC20 {
//     function approve(address spender, uint256 amount) external returns (bool);
//     function balanceOf(address owner) external view returns (uint256);
//     function allowance(address owner, address spender) external view returns (uint256);
//     function transfer(address to, uint256 value) external returns (bool);
//     function transferFrom(address from, address to, uint256 value) external returns (bool);
// }
