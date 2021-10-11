// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "ds-test/test.sol";
import {MerkleMint} from "../../MerkleMint.sol";
import "../../MintPass.sol";
import "./Hevm.sol";

import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";

// contract User {
//     MerkleMint internal minter;

//     constructor(address _greeter) {
//         greeter = Greeter(_greeter);
//     }

//     function greet(string memory greeting) public {
//         greeter.greet(greeting);
//     }

//     function gm() public {
//         greeter.gm();
//     }
// }

abstract contract MerkleTest is DSTest, ERC1155Holder {
    Hevm internal constant hevm = Hevm(HEVM_ADDRESS);

    // contracts
    MerkleMint internal minter;
    MintPass internal pass;

    struct Proof {
        uint256 index;
        address account;
        uint256 amount;
        bytes32[] proof;
    }

    Proof internal presaleProof;
    Proof internal saleProof;
    Proof internal badProof;

    function setUp() public virtual {
        hevm.warp(1634140801);
        pass = new MintPass();
        minter = new MerkleMint(
            address(pass),
            0,
            bytes32(
                0x65d8f27675f91a320392ac31aeb23d813c53cde32c6f5021e76969eb4f2b0ac3
            ),
            bytes32(
                0xb6714e9f771b9c7714d6ed362b7d86ac7c06cadbb5085002c9985a97acaa45da
            )
        );
        pass.addMinter(address(minter));

        saleProof.index = 1;
        saleProof.account = address(0x54BE3a794282C030b15E43aE2bB182E14c409C5e);
        saleProof.amount = 3;
        saleProof.proof.push(bytes32(0x88ac22d2357698ec7d6df2755c5b76796ef3d89111131a41903a3e65d1d07011));
        saleProof.proof.push(bytes32(0x25512bcf7a960ba514771a56a9805e8f0fd4f1abdae9fafc937577a0e4362cde));
        saleProof.proof.push(bytes32(0xa25107227b2dc37ff885628081c145d17cff940daaba7423259116e02e26ae2f));
        saleProof.proof.push(bytes32(0xfc9e574b70ef2e5e28a5804d5c003036a01fa625746aaa3e0f409727031e1e93));
        saleProof.proof.push(bytes32(0xb01762ad4943842454bc83405de581993095b0d148d3d3dfd3e11b8d788628b2));
        saleProof.proof.push(bytes32(0x492949394cb7167a7442d3d376a8ba0d8e8da2c576d48d882b397389e40ef07c));
        saleProof.proof.push(bytes32(0xdad9c2afd6da0b1cba724dd2f9689c063763ff2dd4887e0401e1d36695720d6c));
        saleProof.proof.push(bytes32(0x1b3661f73cd50098c291a93dd6bea267fbfd538ecaa1b8265db65a6b76da0328));
        saleProof.proof.push(bytes32(0x696c1b070c0833647c177cc07a63980c1de747e5ef03304ad3833b379abbbb7d));
        saleProof.proof.push(bytes32(0x6b19ec1122dd40f7e34cf68aa10e4d093d8b6ee6253fec8768a76179d78d8ddf)); 
        saleProof.proof.push(bytes32(0x0f9b28f528de50ffff6f9d987e2f99478b2473ada951e9713a0e69351aa84b06));
        saleProof.proof.push(bytes32(0x75015c4db7207316a15dd4a3c1a91ad2dc8a22ebef10018bf38f8738d85cd4d2));   
        saleProof.proof.push(bytes32(0x7dbc6b75af1432439ed6aca1d29c77263d540b208981c5a2654dc4be48a7fcc7));
        saleProof.proof.push(bytes32(0x9dc00d0f59dbe46add99b4691cb1e00a1b8723a836dbdb3ded749f66f48464a1));  
        saleProof.proof.push(bytes32(0x557e8456749506799e789a5d5b6a13ac5f6e8850e2027fe1f6d12d88eb659fa4));   
        saleProof.proof.push(bytes32(0xa9a50dfa1350f4c9dc69aeceeec13e555445cb4c93d0e4d69d54d96dee687b0f));
        saleProof.proof.push(bytes32(0x714c76c32b431a142faf30fd98210ac6161046dd3837421af80a1924035cdbef));      
        
        presaleProof.index = 0;
        presaleProof.account = address(0x00669F9D9ff7F72E83d49F3D955fFb3e87C77971);
        presaleProof.amount = 5;
        presaleProof.proof.push(bytes32(0xb17fd63be0320ed54e659aae5389ad9a6a6d08364409b5ceda1a5b7e426e6f52));
        presaleProof.proof.push(bytes32(0x0332a8db8524877512be958466fc8ced38ada295511eb3073a8b24dd61227ae4));
        presaleProof.proof.push(bytes32(0xc46bc2dddd090af2e882eee2d468d6898bbd33e11f7aba6fdc8545bd64b8e352));
        presaleProof.proof.push(bytes32(0x4efbc4dfc64884943cdd2124e68ad14c2ab09f413217b01f6cb3537e07648c3f));
        presaleProof.proof.push(bytes32(0x5aac0030d00c98de528ae2f090c6100b4b0ec6ba2cbe48eeed335a3db7a54e85));
        presaleProof.proof.push(bytes32(0xed59f13098cf69862d6c110a78bf6798b50595fdea1e42ada1a47f1ffc0fa3c9));
        presaleProof.proof.push(bytes32(0xfaffa9f9663e86d817be7869e935b3d66a6e5addbcb4d7c115df5feb3ac4fe89));
        presaleProof.proof.push(bytes32(0x70a32d791c218c229f009e150f41d73464490d64ebe0f709840c97b2dd14d543));
        presaleProof.proof.push(bytes32(0x6fda1b6395e30cc9b663cb464a60fdfcc9057e1fd751742d4ca8737aa0114bc1));
        presaleProof.proof.push(bytes32(0xf0936c1d11078e4f0bf51870452ae6f0f4a212e280ba5d0130c47ff02783b90a));    

        badProof.index = 0;
        badProof.account = address(0x00669F9D9ff7F72E83d49F3D955fFb3e87C77971);
        badProof.amount = 5;
        badProof.proof.push(bytes32(0xb17fd63be0320ed54e659aae5389ad9a6a6d08364409b5ceda1a5b7e426e6f52));
        badProof.proof.push(bytes32(0xb17fd63be0320ed54e659aae5389ad9a6a6d08364409b5ceda1a5b7e426e6f52));
        badProof.proof.push(bytes32(0xb17fd63be0320ed54e659aae5389ad9a6a6d08364409b5ceda1a5b7e426e6f52));
        badProof.proof.push(bytes32(0x4efbc4dfc64884943cdd2124e68ad14c2ab09f413217b01f6cb3537e07648c3f));
        badProof.proof.push(bytes32(0x5aac0030d00c98de528ae2f090c6100b4b0ec6ba2cbe48eeed335a3db7a54e85));
        badProof.proof.push(bytes32(0xed59f13098cf69862d6c110a78bf6798b50595fdea1e42ada1a47f1ffc0fa3c9));
        badProof.proof.push(bytes32(0xfaffa9f9663e86d817be7869e935b3d66a6e5addbcb4d7c115df5feb3ac4fe89));
        badProof.proof.push(bytes32(0x70a32d791c218c229f009e150f41d73464490d64ebe0f709840c97b2dd14d543));
        badProof.proof.push(bytes32(0x6fda1b6395e30cc9b663cb464a60fdfcc9057e1fd751742d4ca8737aa0114bc1));
        badProof.proof.push(bytes32(0xf0936c1d11078e4f0bf51870452ae6f0f4a212e280ba5d0130c47ff02783b90a));    
    }

    receive() external payable {}
}
