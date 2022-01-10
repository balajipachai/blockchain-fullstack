// SPDX-License-Identifier: MIT
pragma solidity 0.7.5;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

/* @title CryptoTrophies
 * @notice Smart contract for minting unique CryptoTrophies Award
 */
contract CryptoTrophies is ERC721, Ownable {
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    // Mapping to get user owned tokens without using for loop
    mapping(address => uint256[]) private userOwnedTokens;

    // Truth
    string public constant TRUTH = "You are an exceptional contributor";

    /**
     * @dev Sets the values {baseURI}.
     *
     * baseURI value is immutable: it can only be set once during construction.
     */
    constructor(string memory __baseURI)
        public
        ERC721("CryptoTrophies", "CRYPT")
    {
        setBaseURI(__baseURI);
    }

    /**
     * @dev Contract might receive/hold ETH as part of the maintenance process.
     * The receive function is executed on a call to the contract with empty calldata.
     */
    // solhint-disable-next-line no-empty-blocks
    receive() external payable {}

    /**
     * @dev The fallback function is executed on a call to the contract if
     * none of the other functions match the given function signature.
     */
    fallback() external payable {}

    /**
     * @dev To giveaway CryptoTrophies (CryptoTrophies) to the developers/community
     *
     * Requirements:
     * - giveaway CryptoTrophies cannot exceed 30.
     * - invocation can be done, only by the contract owner.
     */
    function mineCryptoTrophies(address[] memory _receivers)
        external
        onlyOwner
    {
        uint256 receiverLength = _receivers.length;
        uint256 mintIndex;
        // Reserved for people who helped this project
        for (uint256 i = 0; i < receiverLength; i++) {
            //solhint-disable-next-line reason-string
            require(
                _receivers[i] != address(0),
                "mineCryptoTrophies: receiver cannot be address zero"
            );
            mintIndex = _tokenIds.current();
            userOwnedTokens[_receivers[i]].push(mintIndex);
            // THIS ENSURES THAT TOKEN_ID IS ALWAYS UNIQUE
            _safeMint(owner(), mintIndex);
            _tokenIds.increment();
        }
    }

    /**
     * @dev To transfer all ETHs from `this contract` to `owner`
     *
     * Requirements:
     * - invocation can be done, only by the contract owner.
     */
    function withdrawContractEth() external onlyOwner {
        //solhint-disable-next-line avoid-low-level-calls
        (bool success, ) = payable(msg.sender).call{
            gas: 2300,
            value: address(this).balance
        }("");
        require(success, "Withdraw failed");
    }

    /**
     * @dev To get all mined bravo awards
     */
    function totalCryptoTrophies() external view returns (uint256) {
        return totalSupply();
    }

    /**
     * @dev To get all mined bravo awards
     */
    function cryptoTrophiesOf(address _owner)
        external
        view
        returns (uint256[] memory)
    {
        return userOwnedTokens[_owner];
    }

    /**
     * @dev To check contracts ETH balance
     */
    function contractEthBalance() external view returns (uint256) {
        return address(this).balance;
    }

    /**
     * @dev To set/update the baseURI.
     *
     * Requirements:
     * - invocation can be done, only by the contract owner.
     */
    function setBaseURI(string memory _baseURI) public onlyOwner {
        _setBaseURI(_baseURI);
    }

    /**
     * @dev Overrides the default internal function
     */
    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override {
        // TO DENOTE THAT THE TOKEN HAS BEEN TRANSFERRED, YOU CAN USE ANY OTHER NUMBER
        userOwnedTokens[from][tokenId] = uint256(0);
        userOwnedTokens[to].push(tokenId);
        super._transfer(from, to, tokenId);
    }
}
