[Source](https://zku.gnomio.com/mod/assign/view.php?id=119)

## Week 2 repo: 
https://github.com/zku-cohort-4/week2

Fork the above repo onto your own Github and run `git submodule update --init --recursive` to pull all submodules. Group your coding assignment submission into a single commit. Link the commit to the submission text box. All word answers should go into a single PDF file to be uploaded here.


## Part 1 Hashes and Merkle Tree

In this question, we will visit the different types of hashes available in Circom (and Solidity) and grow some Merkle trees!

1. Based on the resources we provide you as well as any additional research you have done, compare the four hashes and provide explanations in four different aspects: gas cost, capacity, proof generation efficiency, and proof size. It's ok if you cannot find reference for all four aspects, just do the best you can.


> 1. Gas Cost
SHA-256: High gas cost due to its computational intensity.
Keccak-256: Lower gas cost compared to SHA-256; optimized for Ethereum (ETH 2.0).
Poseidon: Designed for zk-SNARKs and zk-STARKs, offering lower gas costs compared to SHA-256 and Keccak-256.
Pedersen: Often used in ZKPs for its lower gas cost and better integration with elliptic curve operations.
> 2. Capacity
SHA-256: 256-bit output, highly secure, and widely used in various applications.
Keccak-256: 256-bit output, chosen for Ethereum’s proof-of-stake due to its security and efficiency.
Poseidon: Variable capacity but optimized for ZKPs, balancing between performance and security.
Pedersen: 256-bit output, especially efficient in contexts requiring elliptic curve cryptography.
> 3. Proof Generation Efficiency
SHA-256: Less efficient in proof generation for ZKPs due to higher computational demands.
Keccak-256: More efficient than SHA-256, optimized for Ethereum, but not the most efficient for ZKPs.
Poseidon: Highly efficient for ZKPs, designed to reduce proof generation time.
Pedersen: Efficient for ZKPs, particularly when used in conjunction with elliptic curve operations.
> 4. Proof Size
SHA-256: Larger proof sizes due to higher computational complexity.
Keccak-256: Moderate proof sizes, better than SHA-256 but not optimized for minimal proof size.
Poseidon: Smaller proof sizes due to optimization for ZKPs.
Pedersen: Relatively small proof sizes, especially when used within elliptic curve contexts.
> Summary
SHA-256: High gas cost, secure, less efficient for ZKPs, larger proof sizes.
Keccak-256: Moderate gas cost, efficient for Ethereum, moderate proof sizes.
Poseidon: Low gas cost, optimized for ZKPs, highly efficient, small proof sizes.
Pedersen: Low gas cost, efficient for elliptic curve contexts, small proof sizes.

2. Let’s build a binary Merkle tree template in Circom and some relevant templates for leaf verification. We will use the Poseidon hash for this assignment.

    1. Fork the week2 repo and initialize all submodules. Enter the Part1 directory and install all dependencies. In circuits/MerkleTree.circom, complete the code for the following templates (feel free to add any helper templates for intermediate components and it’s ok to reference existing repos as long as their licenses permit):

    2. CheckRoot: Given all 2n already hashed leaves of an n-level tree, compute the Merkle root.

    3. MerkleTreeInclusionProof: Given an already hashed leaf and all the elements along its path to the root, compute the corresponding root.

    4. Run . scripts/compile-circuit.sh && node scripts/bump-solidity.js to compile the verifier contract for MerkleTreeInclusionProof of a 3-level tree.

3. We will now create a smart contract and use the circuits from above to verify a leaf inclusion on chain. In contracts/MerkleTree.sol, complete the code so that your contract will

    1. initialize a blank (meaning all leaves are zeros) Merkle tree of 3 levels (8 leaves) in the constructor
clarification 1: assume the 0's are already hashed
clarification 2: the indexing convention of the hashes array is from bottom to top, left to right, of the tree

    2. insertLeaf(): a function to insert a new already hashed leaf and update the relevant elements in the tree

    3. verify(): a function that verifies the inclusion proof and checks that the output root from the proof is the same as the root on chain

    4. Run npx hardhat test and attach a screenshot of all the tests passing in your PDF file

    5.[bonus] In test/merkle-test.js, complete the code to verify the second leaf with the inclusion proof as well.

4. [bonus] Create a front-end UI that interacts with the above smart contract so that all of the functions can be called in the browser. The proof generation should also happen in the browser (Hint: WASM 👀).


## Part 2 Tornado Cash

1. How is Tornado Cash Nova different from Tornado Cash Classic? What are the key upgrades/improvements and what changes in the technical design make these possible?

2. What is the role of the relayers in the Tornado Cash protocols? Why are relayers needed?

3. In the Part2 directory of this week’s repo you will find a submodule that consists of a forked tornado-nova repo. Follow the README for instructions to install all dependencies and build via yarn.

    1. Run yarn test and attach a screenshot of all the tests passing to your PDF file. 

    2. In test/custom.test.js, write a test that: Alice deposits 0.1 ETH in L1 -> Alice withdraws 0.08 ETH in L2 -> assert recipient, omniBridge, and tornadoPool balances are correct.

    3. In the same file, write a test that: Alice deposits 0.13 ETH in L1 -> Alice sends 0.06 ETH to Bob in L2 -> Bob withdraws all his funds in L2 -> Alice withdraws all her remaining funds in L1 -> assert all relevant balances are correct.

    4. Copy your modified custom.test.js into week2/custom.test.modified.js for submission, so you don’t have to commit the submodule.

4. [bonus] Try out Tornado Classic on Goerli testnet and attach screenshots at deposit and withdrawal in the PDF file.

## Part 3 Semaphore

1. What is Semaphore? Explain in 4-8 sentences how it works.

2. How does Semaphore prevent double signing (or double withdrawal in the case of mixers)? Explain the mechanism in 4-8 sentences.

3. A lot of applications have already been built based on derivations from Semaphore, such as for voting (e.g. AnonyVote), survey or opinion (e.g. Ninja Survey, zkAsk), and authentication (e.g. InterRep, Continuum, zkPayroll). Can you suggest two more ideas for ZK applications that can be built upon Semaphore?
