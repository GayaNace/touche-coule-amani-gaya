// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import 'hardhat/console.sol';

abstract contract Ship {
  function update(uint x, uint y) public virtual;
  function fire() public virtual returns (uint, uint);
  function place(uint width, uint height) public virtual returns (uint, uint);
}

contract myShip is Ship {
  uint height;
  uint width;
  uint[] map;
  uint[] nextFire;
  uint indexNextFire;
  uint lastTargeted;
  uint shipPos;
  uint public constant vise = 1;
  
  constructor() {
    lastTargeted = 0;
    width = 0;
    height = 0;
  } 


  function Init(uint _width, uint _height) external {
    width = _width;
    height = _height;
    map = new uint[](width * height);
    indexNextFire = 0;
  }

  function update(uint _x, uint _y) public override(Ship) {
    uint NewPos = _x + _y * width;

    while (NewPos > shipPos && shipPos < width * height) {
      nextFire.push(shipPos);
      shipPos += 1;
    }
    if (shipPos == width * height)
      shipPos = 0;
    while (NewPos > shipPos) {
      nextFire.push(shipPos);
      shipPos+= 1;
    }
  }

  function fire() public override(Ship) returns (uint, uint) {
      uint feu;

      while (indexNextFire < nextFire.length) {
        feu = nextFire[indexNextFire];
        indexNextFire++;
        if (map[feu] == 0) {
          map[feu] = vise;
          return (feu % width, feu / width);
        }
      }
      while(map[lastTargeted] != 0)
        lastTargeted++;
      map[lastTargeted] = vise;
          return (lastTargeted % width, lastTargeted / width);
      //return(uint(keccak256(abi.encodePacked(block.timestamp,msg.sender)))
      //return (25,35) //for test
  }

  function place(uint _width, uint _height) public override(Ship) returns (uint, uint) {
    uint randNonce = 0;
    uint x;
    uint y;
    randNonce+=1;
    x=uint(keccak256(abi.encodePacked(block.timestamp,msg.sender,randNonce))) % 50;
    randNonce+=1;
    y=uint(keccak256(abi.encodePacked(block.timestamp,msg.sender,randNonce))) % 50;
 
    this.Init(_width, _height);
    shipPos = x + y * width;
    return (x, y);
    //return(uint(keccak256(abi.encodePacked(block.timestamp,msg.sender)))
    //return (25,35) //for test
  }
}
