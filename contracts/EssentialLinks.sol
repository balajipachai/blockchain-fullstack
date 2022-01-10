// SPDX-License-Identifier: MIT
pragma solidity 0.7.5;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title EssentialLinks
/// @notice ERC-20 implementation of EssentialLinks token
contract EssentialLinks is ERC20, Ownable {
    uint8 public tokenDecimals;

    /**
     * @dev Sets the values for {name = EssentialLinks}, {totalSupply = 1000000000} and {symbol = EssentialLinks}.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(uint256 fixedSupply) ERC20("EssentialLinks", "ELT") {
        tokenDecimals = 18;
        super._mint(msg.sender, fixedSupply); // Since Total supply 210000
    }

    /**
     * @dev Contract might receive/hold ETH as part of the maintenance process.
     * The receive function is executed on a call to the contract with empty calldata.
     */
    // solhint-disable-next-line no-empty-blocks
    receive() external payable {}

    fallback() external payable {}

    /**
     * @dev To update number of decimals for a token
     *
     * Requirements:
     * - invocation can be done, only by the contract owner.
     */
    function updateDecimals(uint8 noOfDecimals) public onlyOwner {
        tokenDecimals = noOfDecimals;
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     * - invocation can be done, only by the contract owner.
     */
    function burn(address account, uint256 amount) public onlyOwner {
        _burn(account, amount);
    }

    /**
     * @dev To transfer all BNBs stored in the contract to the caller
     *
     * Requirements:
     * - invocation can be done, only by the contract owner.
     */
    function withdrawAll() public payable onlyOwner {
        require(
            payable(msg.sender).send(address(this).balance),
            "Withdraw failed"
        );
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless this function is
     * overridden;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view override returns (uint8) {
        return tokenDecimals;
    }
}
