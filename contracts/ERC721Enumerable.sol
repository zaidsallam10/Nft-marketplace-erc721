// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "./ERC721.sol";
import './interfaces/IERC721Enumerable.sol';

contract ERC721Enumerable is IERC721Enumerable,ERC721{

uint[] private _allTokens;

// mapping from tokenID to position in all tokens; 
mapping(uint=>uint) private allTokensIndex;
// mapping of owner to list of all ower token ids;
mapping(address=>uint[]) private _ownedTokens;
// mapping from tokenID to index of the owner token list;
mapping(uint =>uint) private _ownedTokensIndex;



  constructor() public{
            _registerInterface( 
                bytes4(keccak256('tokenByIndex(bytes4)')) ^ 
                bytes4(keccak256('tokenOfOwnerByIndex(bytes4)')) ^
                bytes4(keccak256('totalSupply(bytes4)')) 
             );
        }



// Overriding _mint function from ERC721.sol class
function _mint(address to, uint256 token) internal override(ERC721) {
    super._mint(to,token);
    // Two thing to do:
    // A. Add tokens to the owner
    // B. Add tokens to our total supply
    _addTokenToAllTokensEnumuration(token);
    _addTokenTOwnerEnumuration(to, token);
}

// add tokens to _alltokens and set position of the indexes
function _addTokenToAllTokensEnumuration(uint tokenId) private{
    allTokensIndex[tokenId]=_allTokens.length;
    _allTokens.push(tokenId);
} 


function _addTokenTOwnerEnumuration(address to, uint tokenId) private{

    // 1.  Set token as index with length of owned tokens of the owner
    _ownedTokensIndex[tokenId]=_ownedTokens[to].length;
    
    // 2.  Add token to owner
    _ownedTokens[to].push(tokenId); 
}




// returns token by index
function tokenByIndex(uint index) public override view returns (uint){
    require(index < totalSupply(),"Index is out of bound");
    return allTokensIndex[index];
}

// returns tokens for owner
function tokenOfOwnerByIndex(address owner, uint index) public override view returns (uint){
    require(index < balanceOf(owner),"Owner Index is out of bound");
    return _ownedTokens[owner][index];
}

// Return A count of valid NFTs with token=>address
function totalSupply() public override view returns (uint){
    return _allTokens.length;
}



}