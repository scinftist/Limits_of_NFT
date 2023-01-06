// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC721FancyMintEnumRef.sol";

import "@openzeppelin/contracts@4.7.0/access/Ownable.sol";
import {Base64} from "@openzeppelin/contracts@4.7.0/utils/Base64.sol";


contract LimitOfNFT is ERC721FancyMintEnum, Ownable {
    using Strings for uint256;

    // mapping(uint256 => color) private colorMap;
    ///
    string private name_ = "Limits of NFT";
    string private symbol_ = "LONFT";
    uint256 private maxSupply_ = 1;

    address private preOwner_ = 0x65c94c08Dd504a199fE61C3D29ca01784C7081aF;
    uint256 private emitCounter = 1;
    //
    bool private notFinialized = true;
    string private head =
        '<svg width="900" height="600" viewBox="0 0 900 600" xmlns="http://www.w3.org/2000/svg"><rect width="900" height="600" style="fill:rgb(222,240,255);stroke-width:3;stroke:rgb(0,0,0)" /><text x="20" y="70" >';
    string private tail = "</text></svg>";

    constructor()
        ERC721FancyMintEnum(name_, symbol_, maxSupply_, preOwner_)
    {}

    // in case the marketplace need this
    function emitHandlerSingle() public {
        emit ConsecutiveTransfer(
            emitCounter * 5000,
            (maxSupply_ + 1) * 5000 - 1,
            address(0),
            preOwner_
        );
        emitCounter++;
    }

    function generateSVG(uint256 id) internal view returns (string memory) {
        // string memory _svgString = head;

        return string(abi.encodePacked(head, id.toString(), tail));
    }

    function constructTokenURI(uint256 id)
        internal
        view
        returns (string memory)
    {
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"image": "data:image/svg+xml;base64,',
                                Base64.encode(bytes(generateSVG(id))),
                                '"}'
                            )
                        )
                    )
                )
            );
    }

    function tokenURI(uint256 id)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(_exists(id), "token does not exist!");
        return constructTokenURI(id);
    }
}
