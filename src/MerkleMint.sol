// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

interface IERC1155 {
    function mint(address, uint256, uint256) external;
    function totalSupply(uint256) external view returns (uint256);
}

contract MerkleMint is Ownable, ReentrancyGuard {
    IERC1155 public immutable token;
    uint256 public immutable id;
    bytes32 public immutable merkleRootPresale;
    bytes32 public immutable merkleRoot;
    uint256 public constant PRICE = 0.08 ether;
    uint256 public constant START = 1634140800;
    uint256 public constant MAX = 2949;

    // This is a packed array of booleans.
    mapping(uint256 => uint256) private claimedBitMapPresale;
    mapping(uint256 => uint256) private claimedBitMap;

    event Minted(uint256 index, address account, uint256 amount);

    constructor(
        address _token,
        uint256 _id,
        bytes32 _merkleRoot, 
        bytes32 _merkleRootPresale
    ) {
        token = IERC1155(_token);
        id = _id;
        merkleRoot = _merkleRoot;
        merkleRootPresale = _merkleRootPresale;
    }

    function amountLeft() public view returns(uint256) {
        return MAX - token.totalSupply(id);
    }

    function isMintedPresale(uint256 index) public view returns (bool) {
        uint256 claimedWordIndex = index / 256;
        uint256 claimedBitIndex = index % 256;
        uint256 claimedWord = claimedBitMapPresale[claimedWordIndex];
        uint256 mask = (1 << claimedBitIndex);
        return claimedWord & mask == mask;
    }

    function _setMintedPresale(uint256 index) private {
        uint256 claimedWordIndex = index / 256;
        uint256 claimedBitIndex = index % 256;
        claimedBitMapPresale[claimedWordIndex] =
            claimedBitMapPresale[claimedWordIndex] |
            (1 << claimedBitIndex);
    }

    function isMinted(uint256 index) public view returns (bool) {
        uint256 claimedWordIndex = index / 256;
        uint256 claimedBitIndex = index % 256;
        uint256 claimedWord = claimedBitMap[claimedWordIndex];
        uint256 mask = (1 << claimedBitIndex);
        return claimedWord & mask == mask;
    }

    function _setMinted(uint256 index) private {
        uint256 claimedWordIndex = index / 256;
        uint256 claimedBitIndex = index % 256;
        claimedBitMap[claimedWordIndex] =
            claimedBitMap[claimedWordIndex] |
            (1 << claimedBitIndex);
    }

    function mintPresale(
        uint256 amount,
        uint256 index,
        address account,
        bytes32[] calldata merkleProof
    ) external payable nonReentrant() {
        require(block.timestamp > START, "too soon");
        require(msg.value == amount * PRICE, "wrong price");
        require(!isMintedPresale(index), "already minted");

        // Verify the merkle proof.
        bytes32 node = keccak256(abi.encodePacked(index, account, amount));
        require(
            MerkleProof.verify(merkleProof, merkleRootPresale, node),
            "invalid proof"
        );

        // Mark it claimed and send the token.
        _setMintedPresale(index);
        _mint(account, amount, index);
    }

    function mint(
        uint256 amount,
        uint256 index,
        address account,
        bytes32[] calldata merkleProof
    ) external payable nonReentrant() {
        require(amount < 6, "too many");
        require(!isMinted(index), "already minted");
        require(block.timestamp > START + 1 days, "too soon");

        // Verify the merkle proof.
        bytes32 node = keccak256(abi.encodePacked(index, account, uint256(1)));
        require(
            MerkleProof.verify(merkleProof, merkleRoot, node),
            "invalid proof"
        );

        // Mark it claimed and send the token.
        _setMinted(index);
        _mint(account, amount, index);
    }

    function mintLeftover(uint256 amount) external payable nonReentrant() {
        require(block.timestamp > START + 2 days, "too soon");
        _mint(msg.sender, amount, 99999);
    }

    function _mint(address to, uint256 amount, uint256 index) internal {
        require(amount <= amountLeft(), "too many");
        require(msg.value == amount * PRICE, "wrong price");
        token.mint(to, id, amount);
        emit Minted(index, msg.sender, amount);
    }

    function devMint(uint256 amount) external onlyOwner {
        token.mint(owner(), 0, amount);
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
