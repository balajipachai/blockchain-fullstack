// SPDX-License-Identifier: MIT
pragma solidity 0.7.5;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

/// @title NFTGiveaway
/// @notice Contract for distributing NFTs
contract NFTGiveaway is Ownable {
    using Address for address;

    mapping(address => bool) public isNFTWhiteListed;
    mapping(address => uint256[]) public distributedNFTs;

    /**
     * @dev To whitelist an NFT contract address
     *
     * Requirements:
     *
     * - can only be invoked by the owner of the contract
     */
    function whitelistNFT(address nftContract) external onlyOwner {
        require(nftContract != address(0), "Contract cannot be zero address");
        require(
            nftContract.isContract(),
            "Provided address is not a contract address"
        );
        require(!isNFTWhiteListed[nftContract], "Already whitelisted");
        isNFTWhiteListed[nftContract] = true;
    }

    /**
     * @dev To distribute NFTs to wallet addresses
     */
    function distributeNFTs(
        address from,
        address nftContract,
        address[] memory receivers,
        uint256[] memory tokenIds
    ) external {
        require(
            isNFTWhiteListed[nftContract],
            "Cannot distribute: not a whitelisted NFT"
        );
        require(
            receivers.length == tokenIds.length,
            "Cannot distribute: unequal params"
        );
        for (uint256 i = 0; i < receivers.length; i++) {
            IERC721(nftContract).safeTransferFrom(
                from,
                receivers[i],
                tokenIds[i]
            );
            distributedNFTs[nftContract].push(tokenIds[i]);
        }
    }

    /**
     * @dev Returns the list of tokenIds distributed as per the nftContract
     */
    function getDistributedNFTs(address nftContract)
        external
        view
        returns (uint256[] memory _distributedNFTs)
    {
        _distributedNFTs = new uint256[](distributedNFTs[nftContract].length);
        for (uint256 i = 0; i < distributedNFTs[nftContract].length; i++) {
            _distributedNFTs[i] = distributedNFTs[nftContract][i];
        }
    }
}
