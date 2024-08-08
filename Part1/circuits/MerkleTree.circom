pragma circom 2.1.9;

include "../node_modules/circomlib/circuits/poseidon.circom";
include "../node_modules/circomlib/circuits/mux1.circom";

template CheckRoot(n) { // compute the root of a MerkleTree of n Levels 
    signal input leaves[2**n];
    signal output root;

    //[assignment] insert your code here to calculate the Merkle root from 2^n leaves
    var total_node=2**(n+1)-1;
    component hashes[total_node];

    //init leaf hash values
    for (var i=0;i<2**n;i++) {
        hashes[i]=Poseidon(1);
        hashes[i].inputs[0] <== leaves[i];
    }

    //calculate hash value of internal node
    for (var i=2**n;i<total_node;i++){
            hashes[i]=Poseidon(2);
            hashes[i].inputs[0] <== hashes[2*i-total_node-1].out;
            hashes[i].inputs[1] <== hashes[2*i-total_node].out;
        }

    root<==hashes[total_node-1].out;

}

template MerkleTreeInclusionProof(n) {
    signal input leaf;
    signal input path_elements[n];
    signal input path_index[n]; // path index are 0's and 1's indicating whether the current element is on the left or right
    signal output root; // note that this is an OUTPUT signal

    //[assignment] insert your code here to compute the root from a leaf and elements along the path
    component poseidons[n];
    component mux[n];
    signal hashes[n+1];
    hashes[0] <== leaf;

    
    for (var i = 0; i < n; i++) {
        //constrain index is only 0 or 1
        path_index[i] * (1 - path_index[i]) === 0;

        poseidons[i] = Poseidon(2);

        //decide where the node is on left or right, the order of Poseidon hash matters
        mux[i] = MultiMux1(2);

        mux[i].c[0][0] <== hashes[i];
        mux[i].c[0][1] <== path_elements[i];

        mux[i].c[1][0] <== path_elements[i];
        mux[i].c[1][1] <== hashes[i];

        mux[i].s <== path_index[i];

        poseidons[i].inputs[0] <== mux[i].out[0];
        poseidons[i].inputs[1] <== mux[i].out[1];

        hashes[i+1] <== poseidons[i].out;
    }

    root <== hashes[n];
}