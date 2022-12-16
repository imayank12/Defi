// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
contract NFT is ERC721URIStorage {
    struct NftDetails{
        bool borrowed;
        uint256 borrowedAmount;
    }
    using Counters for Counters.Counter;
    address public tokenAddress;
    Counters.Counter private _tokenIds;
    mapping(uint256 => NftDetails) public nftBorrowedDetails;
    mapping(uint256 => uint256) public nftvalue;
    constructor() ERC721("GameItem", "ITM") {}

    function mintNFT(
        address user,
        string memory tokenURI,
        uint256 nftAmount
    ) public returns (uint256) {
        uint256 newItemId = _tokenIds.current();
        _mint(user, newItemId);
        _setTokenURI(newItemId, tokenURI);
        nftvalue[newItemId] = nftAmount;
        _tokenIds.increment();
        return newItemId;
    }
    function setTokenAddress(address _tokenAddress) external{
        tokenAddress = _tokenAddress;
    }

    function BorrowNft(
        address userAddress,
        uint256 nftId,
        uint256 tokenAmount
    ) external virtual {
        require(_ownerOf(nftId)==userAddress,"you do not own this nft");
        require(!nftBorrowedDetails[nftId].borrowed,"already borrowed");
        require(IERC20(tokenAddress).balanceOf(address(this)) > tokenAmount, "Pool does not have enough liquidity");
        require(nftvalue[nftId]>=tokenAmount,"amount not allowed");
        nftBorrowedDetails[nftId] = NftDetails(true,tokenAmount);
        bool result = IERC20(tokenAddress).transfer(userAddress, tokenAmount);
        require(result, "transfer failed while borrowing");
    }

    function RepayNft(
        address userAddress,
        uint256 nftId,
        uint256 tokenAmount
    ) external virtual {
        require(_ownerOf(nftId)==userAddress,"you do not own this nft");
        require(nftBorrowedDetails[nftId].borrowed,"not borrowed");
        if(nftBorrowedDetails[nftId].borrowedAmount>=tokenAmount){
           nftBorrowedDetails[nftId].borrowedAmount-=tokenAmount; 
        }else {
             nftBorrowedDetails[nftId].borrowedAmount=0;
             nftBorrowedDetails[nftId].borrowed=false; 

        }
        bool result = IERC20(tokenAddress).transferFrom(userAddress, address(this), tokenAmount);
        require(result, "transfer failed while borrowing");
    }
}
