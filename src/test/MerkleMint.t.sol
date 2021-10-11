// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./utils/MerkleTest.sol";

contract Merkle is MerkleTest {
    function test_mintPresale() public {
        minter.mintPresale{value: 0.4 ether}(
            presaleProof.amount,
            presaleProof.index,
            presaleProof.account,
            presaleProof.proof
        );
        assertEq(5, pass.balanceOf(presaleProof.account, 0));
    }

    function testFail_mintPresale() public {
        minter.mintPresale(
            saleProof.amount,
            saleProof.index,
            saleProof.account,
            saleProof.proof
        );
    }

    function test_mintSale() public {
        hevm.warp(1634140801 + 1 days);
        minter.mintPresale{value: 0.4 ether}(
            presaleProof.amount,
            presaleProof.index,
            presaleProof.account,
            presaleProof.proof
        );
        minter.mint{value: 0.24 ether}(
            saleProof.amount,
            saleProof.index,
            saleProof.account,
            saleProof.proof
        );
        assertEq(5, pass.balanceOf(presaleProof.account, 0));
        assertEq(3, pass.balanceOf(saleProof.account, 0));
    }

    function testFail_mintSale() public {
        hevm.warp(1634140801 + 1 days);
        minter.mintLeftover{value: 0.4 ether}(5);
    }

    function test_mintEnd() public {
        hevm.warp(1634140801 + 2 days);
        minter.mintPresale{value: 0.4 ether}(
            presaleProof.amount,
            presaleProof.index,
            presaleProof.account,
            presaleProof.proof
        );
        minter.mint{value: 0.24 ether}(
            saleProof.amount,
            saleProof.index,
            saleProof.account,
            saleProof.proof
        );
        minter.mintLeftover{value: 0.8 ether}(10);
        assertEq(5, pass.balanceOf(presaleProof.account, 0));
        assertEq(3, pass.balanceOf(saleProof.account, 0));
        assertEq(10, pass.balanceOf(address(this), 0));
    }

    function testFail_mintEnd() public {
        hevm.warp(1634140801 + 2 days);
        minter.mintLeftover{value: 236 ether}(2950);
    }

    function test_devMint() public {
        minter.devMint(4);
        assertEq(4, pass.balanceOf(address(this), 0));
    }

    function test_withdraw() public {
        minter.mintPresale{value: 0.4 ether}(
            presaleProof.amount,
            presaleProof.index,
            presaleProof.account,
            presaleProof.proof
        );
        uint256 balance = address(this).balance;
        minter.withdraw();
        assertEq(balance + 0.4 ether, address(this).balance);
    }
}
