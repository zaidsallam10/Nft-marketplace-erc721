// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import './ERC721Metadata.sol';
// import './ERC721.sol';
import './ERC721Enumerable.sol';

contract ERC721Connector is ERC721Metadata, ERC721Enumerable{

    constructor(string memory name, string memory symbol) public ERC721Metadata(name,symbol){

    }

}