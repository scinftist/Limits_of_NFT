// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "@openzeppelin/contracts@4.7.0/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts@4.7.0/token/ERC721/extensions/IERC721Enumerable.sol";
import "@openzeppelin/contracts@4.7.0/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts@4.7.0/access/Ownable.sol";

interface IERC721Receiver {
    /**
     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
     * by `operator` from `from`, this function is called.
     *
     * It must return its Solidity selector to confirm the token transfer.
     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
     *
     * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
     */
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

contract ERC721Holder is IERC721Receiver,Ownable {
    /**
     * @dev See {IERC721Receiver-onERC721Received}.
     *
     * Always returns `IERC721Receiver.onERC721Received.selector`.
     */
    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }
}

contract giver is ERC721Holder, ReentrancyGuard {
    address private cont;

    function setCont(address _cont) public nonReentrant onlyOwner {
        require(cont == address(0));
        cont = _cont;
    }

    function getThisAddress() public view returns (address) {
        return address(this);
    }

    function getToken() public nonReentrant {
        address creator = getThisAddress();
        IERC721 tok = IERC721(cont);
        IERC721Enumerable tok2 = IERC721Enumerable(cont);
        uint256 id = tok2.tokenOfOwnerByIndex(creator, 0);
        tok.safeTransferFrom(creator, msg.sender, id);
    }

    function getTokenInd(uint256 _ind) public nonReentrant {
        address creator = getThisAddress();
        IERC721 tok = IERC721(cont);
        IERC721Enumerable tok2 = IERC721Enumerable(cont);
        uint256 id = tok2.tokenOfOwnerByIndex(creator, _ind);
        tok.safeTransferFrom(creator, msg.sender, id);
    }
}
