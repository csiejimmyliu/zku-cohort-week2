//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import { PoseidonT3 } from "./Poseidon.sol"; //an existing library to perform Poseidon hash on solidity
import "./verifier.sol"; //inherits with the MerkleTreeInclusionProof verifier contract

contract MerkleTree is Groth16Verifier {
    uint256[] public hashes; // the Merkle tree in flattened array form
    uint256 public index = 0; // the current index of the first unfilled leaf
    uint256 public root; // the current Merkle root

    constructor() {
        // [assignment] initialize a Merkle tree of 8 with blank leaves
        uint num_leaves = 8;
        uint level=3; // log8=3
        uint total_node=2**(3+1)-1;

        hashes= new uint256[](total_node);
        
        // init leave hash
        for (uint i=0; i<num_leaves;i++){
            hashes[i]=0;
        }

        // internode
        /*
        uint offset=num_leaves;
        for (uint ll=1;ll<level;ll++){
            uint l=level-ll;
            for (uint i=0;i<2**l;++i){
                hashes[offset+i]=PoseidonT3.poseidon([hashes[2*(offset+i)-total_node-1],hashes[2*(offset+i)-total_node]]);
            }
            offset+=2**l;
        }*/

        for (uint i=num_leaves;i<total_node;i++){
            hashes[i]=PoseidonT3.poseidon([hashes[2*i-total_node-1],hashes[2*i-total_node]]);
        }

        root=hashes[hashes.length - 1];

    }

    function insertLeaf(uint256 hashedLeaf) public returns (uint256) {
        // [assignment] insert a hashed leaf into the Merkle tree
        // f=(total_node+c+1)//2
        require(index < 8, "Merkle tree is full");

        hashes[index]=hashedLeaf;
        
        uint level=3; // log8=3
        uint total_node=2**(3+1)-1;
        uint current_index=index;
        do{
            current_index=(total_node+current_index+1)/2;
            hashes[current_index]=PoseidonT3.poseidon([hashes[2*current_index-total_node-1],hashes[2*current_index-total_node]]);
        }while(current_index<total_node-1);

        root = hashes[hashes.length - 1];
        index++;
        return root;


    }

    function verify(
            uint[2] calldata a,
            uint[2][2] calldata b,
            uint[2] calldata c,
            uint[1] calldata input
        ) public view returns (bool) {

        // [assignment] verify an inclusion proof and check that the proof root matches current root
        require(input[0] == root, "Proof root does not match current root");
        return verifyProof(a, b, c, input);
    
    }
}