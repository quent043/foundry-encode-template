// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { console2 } from "forge-std/console2.sol";
import { console } from "forge-std/console.sol";
import { StdCheats } from "forge-std/StdCheats.sol";

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

/// @dev If this is your first time with Forge, see the "Writing Tests" tutorial in the Foundry Book.
/// https://book.getfoundry.sh/forge/writing-tests
contract FooTest is PRBTest, StdCheats {
    // the identifiers of the forks
    uint256 mainnetFork;
    uint256 mumbaiFork;



    /// @dev An optional function invoked before each test case is run.
    function setUp() public virtual {
//        string memory MAINNET_RPC_URL= "https://polygon-mainnet.g.alchemy.com/v2/TLevGYGkgSJMkGlVIRjKxuesPxBAuOTl";
        string memory MAINNET_RPC_URL = vm.envString("MAINNET_RPC_URL");
//        string memory MUMBAI_RPC_URL= "https://polygon-mumbai.g.alchemy.com/v2/8Zh_BF24uWRT84xumSimgG39vOYeC7rq";
        string memory MUMBAI_RPC_URL = vm.envString("MUMBAI_RPC_URL");
        // solhint-disable-previous-line no-empty-blocks
        mainnetFork = vm.createFork(MAINNET_RPC_URL);
        mumbaiFork = vm.createFork(MUMBAI_RPC_URL);
    }

    // demonstrate fork ids are unique
    function testForkIdDiffer() public {
        assert(mainnetFork != mumbaiFork);
    }

    // select a specific fork
    function testCanSelectFork() public {
        // select the fork
        vm.selectFork(mainnetFork);
        assertEq(vm.activeFork(), mainnetFork);
        // from here on data is fetched from the `mainnetFork` if the EVM
        // requests it and written to the storage of `mainnetFork`
    }

    // manage multiple forks in the same test
    function testCanSwitchForks() public {
        vm.selectFork(mainnetFork);
        assertEq(vm.activeFork(), mainnetFork);
        vm.selectFork(mumbaiFork);
        assertEq(vm.activeFork(), mumbaiFork);
    }

    // forks can be created at all times
    function testCanCreateAndSelectForkInOneStep() public {
        // creates a new fork and also selects it
        string memory MAINNET_RPC_URL = vm.envString("MAINNET_RPC_URL");
        uint256 anotherFork = vm.createSelectFork(MAINNET_RPC_URL);
        assertEq(vm.activeFork(), anotherFork);
    }

    // set `block.timestamp` of a fork
    function testCanSetForkBlockTimestamp() public {
        vm.selectFork(mainnetFork);
        vm.rollFork(1_337_000);
        assertEq(block.number, 1_337_000);
    }

    /// @dev Basic test. Run it with `-vvv` to see the console log.
    function test_Example() external {
        console2.log("Hello World");
        assertTrue(true);
    }

    /// @dev Fuzz test that provides random values for an unsigned integer, but it rejects zero as an input.
    /// If you need more sophisticated input validation, use the `bound` utility instead.
    /// See https://twitter.com/PaulRBerg/status/1622558791685242880
    function testFuzz_Example(uint256 x) external {
        vm.assume(x != 0); // or x = bound(x, 1, 100)
        assertGt(x, 0);
    }

    /// @dev Fork test that runs against an Ethereum Mainnet fork. For this to work, you need to set `API_KEY_ALCHEMY`
    /// in your environment You can get an API key for free at https://alchemy.com.
    function testFork_Example() external {
        // Silently pass this test if there is no API key.
        string memory alchemyApiKey = vm.envOr("API_KEY_ALCHEMY", string(""));
        if (bytes(alchemyApiKey).length == 0) {
            return;
        }

        // Otherwise, run the test against the mainnet fork.
        vm.selectFork(mainnetFork);
//        vm.createSelectFork({ urlOrAlias: "mainnet", blockNumber: 16_428_000 });
        address usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
        address holder = 0x7713974908Be4BEd47172370115e8b1219F4A5f0;
//        uint256 actualBalance = IERC20(usdc).balanceOf(holder);
//        uint256 expectedBalance = 123307714860457;
//        assertEq(actualBalance, expectedBalance);
//        console2.log("balance", actualBalance);

        //Change Block Number
        vm.rollFork(16_428_000);
        assertEq(block.number, 16_428_000);
        uint256 oldBalance = IERC20(usdc).balanceOf(holder);
        console2.log("oldBalance", oldBalance);
        uint256 expectedOldBalance = 196_307_713.810457e6;
        assertEq(oldBalance, expectedOldBalance);
    }
}
