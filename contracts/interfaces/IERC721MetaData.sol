// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

interface IERC721Metadata /* is ERC721 */ {
    function name() external view returns (string memory _name);

    function symbol() external view returns (string memory _symbol);
}
