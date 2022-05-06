// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import './ERC165.sol';
import './interfaces/IERC721.sol';

/*
    Steps:
    1. Nft to point to an address (nft=>address)
    2. Keep track of token ids (tokensIds[])
    3. keep track of token owner address to token ids (address=>tokenID??)
    4. keep track of how many tokens an owner address has (address => []tokens)
    5. create event that emits (transfer log - contract address where it is being minted to )
    */

contract ERC721 is ERC165, IERC721 {


      constructor() public{
            _registerInterface( 
                bytes4(keccak256('balanceOf(bytes4)')) ^ 
                bytes4(keccak256('ownerOf(bytes4)')) ^
                bytes4(keccak256('transferFrom(bytes4)')) 
             );
        }


    /* mapping from token id to the owner 
        ([{"address1":"token1"}, {"address2":"token3"}.......])
    */
    mapping(uint256 => address) private _tokenOwner;


    /* mapping from owner to number of owned tokens 
        ([{"address1":5}, {"address2":2}.......])
    */ 
    mapping(address => uint256) private _OwnedTokensCount;


    // function to check if the token exists and owned by address
    function _exists(uint256 tokenId) internal view returns (bool) {
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }


    function _mint(address to, uint256 token) internal virtual {
        // 1. making sure that addres isn't zero
        // 2. making sure that token isn't already owned/exists
        require(
            to != address(0),
            "ERC721 Error: you're minting to the zero address"
        );
        require(!_exists(token), "Token already exists!!!");
    
        // 1. Assigning the token to the owner
        // 2. increasing number of owned tokens for owner
        _tokenOwner[token] = to;
        _OwnedTokensCount[to] += 1;

        // Here logging the transaction
        // address(0) here means the contract address
        emit Transfer(address(0),to,token);
    }

    // returns How many nfts the owner has?
    function balanceOf(address owner) public override view returns (uint){
        require(owner != address(0),"Error: ERC721 address can't be zero!! ");
        return _OwnedTokensCount[owner];
    }

    function ownerOf(uint token) public override view returns (address){
        return _tokenOwner[token];
    }



    // 1. make sure the receiver address is correct
    // 2. make sure the sender owns the token
    // 3. update balance of sender
    // 4. update balance of receiver
    // 5. Assign the token to the new address(receiver)
    function _transferFrom(address _from ,address _to, uint token) internal{
        require(_to!=address(0),"Address not correct!");
        require(ownerOf(token)== _from,"The _from address doesn't own the token!");

        _tokenOwner[token]=_to;
        
        _OwnedTokensCount[_to] += 1;
        _OwnedTokensCount[_from] -= 1;

    emit Transfer(_from, _to, token);
    }


    function transferFrom(address _from ,address _to, uint token) override public  {
        _transferFrom(_from, _to,token);
    }

}
