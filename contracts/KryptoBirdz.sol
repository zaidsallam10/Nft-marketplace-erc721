// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "./ERC721Connector.sol";


contract KryptoBird is ERC721Connector {
    // Adding all krybtoBirds here
    string [] public KryptoBirdz;
    // Assingin true value for the created krybtoBirds in order to check their existence
    mapping(string=>bool) _kryptoBirdzExists;

    function mint(string memory _kryptoBird) public{
       // Making sure that the _kryptoBird not exists
       require(!_kryptoBirdzExists[_kryptoBird], "Error: This crypto already exists!");
       // Add the token
       KryptoBirdz.push(_kryptoBird);
       // Get its id
       uint tokenId=KryptoBirdz.length-1;
       // call the ERC _mint function
       _mint(msg.sender, tokenId);
        // Updaing mapping that this token is exist
       _kryptoBirdzExists[_kryptoBird]=true;
    }
    constructor() public ERC721Connector("Kryptobird", "KBZ") {

    }
}
