// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import './interfaces/IERC165.sol';

contract ERC165 is IERC165{

        mapping(bytes4=>bool) private _supported_interfaces;

        constructor() public{
            _registerInterface(bytes4(keccak256('supportsInterface(bytes4)')));
        }

        // Get function
        function supportsInterface(bytes4 interfaceId) external view override returns (bool){
            return _supported_interfaces[interfaceId];
        }

        // Set function
        function _registerInterface(bytes4 interfaceId) internal{
            require(interfaceId!=0xffffffff,"Invalid interface request");
            _supported_interfaces[interfaceId]=true;
        }

}