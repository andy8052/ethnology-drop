// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MintPass is ERC1155, Ownable {
    using Strings for uint256;

    string private baseURI;
    mapping(address => bool) public minters;
    mapping(uint256 => uint256) private _totalSupply;

    uint256 public count = 0;

    constructor() ERC1155("") {}

    modifier onlyMinter() {
        require(minters[msg.sender], "not minter");
        _;
    }

    /// Owner Functions ///

    function addMinter(address minter) external onlyOwner {
        minters[minter] = true;
    }

    function removeMinter(address minter) external onlyOwner {
        minters[minter] = false;
    }

    function updateBaseUri(string calldata base) external onlyOwner {
        baseURI = base;
    }

    /// Minter Function ///

    function mint(
        address to,
        uint256 id,
        uint256 amount
    ) external onlyMinter {
        _mint(to, id, amount, "0");
        _totalSupply[id] += amount;
    }

    function burn(
        address account,
        uint256 id,
        uint256 value
    ) public {
        require(
            account == _msgSender() || isApprovedForAll(account, _msgSender()),
            "ERC1155: caller is not owner nor approved"
        );
        _burn(account, id, value);
        _totalSupply[id] -= value;
    }

    /// Public Functions ///

    function totalSupply(uint256 id) public view returns (uint256) {
        return _totalSupply[id];
    }

    function uri(uint256 id) public view override returns (string memory) {
        return
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, id.toString()))
                : baseURI;
    }
}
