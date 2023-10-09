# Phase 2 Transparency

## Initialize zkey file for zkLogin circuit
For encoding compatibility with Kobi's implementation in phase 2, we either use the same modified snarkjs as in [phase 1](../phase1/README.md), or install snarkjs@0.6.11:
```bash
npm install snarkjs@0.6.11
```
To initialize the zkey file for zkLogin circuit, run
```bash
npx snarkjs groth16 setup circuit.r1cs ../phase1/pot_final.ptau initial.zkey
```
The BLAKE2b hash of the zkLogin circuit `circuit.r1cs` is
```bash
$ b2sum circuit.r1cs 
f8420ef7ad42cd1ed553b6b56a9ecfdb453493bf8b2b11fa6101813ffdabfbfd35c2d1ffde4bc5b60fe9333aec3e4284ac2e54ef7d6320a0b8654b44e0fd214b  circuit.r1cs
```
The BLAKE2b hash of the initial zkey file `initial.zkey` is
```bash
$ b2sum initial.zkey 
f534c2c3d156cd009ab69e362a511687ba4cf12bc0642109909ff79bbb54649d05714278c6f593f9109a09b3753689ae65c3b2a73f3679c2bcba27389b00cd57  initial.zkey
```

## Bellman export zkey to params file
To export zkey to Kobi-compatible params file, run
```bash
npx snarkjs zkey export bellman initial.zkey phase2_0.params
```
The BLAKE2b hash of the initial params file `phase2_0.params` is
```bash
$ b2sum phase2_0.params 
5b0e11af50b62f7b3f2a5defe52a5771392c65ecc169f7e558e18546af52538bd8efb9be9179fa57f0d11c04d1c8bf2d405ac7f3ae91a66241f03b4cb6bf9ea1  phase2_0.params
```

## Contribute by Kobi's implementation or snarkjs
Ceremony participants contribute by either Kobi's implementation
```bash
# in phase2-bn254/phase2/
cargo run --release --bin contribute phase2_{i}.params phase2_{i+1}.params {entropy}
```
or snarkjs
```bash
npx snarkjs zkey bellman contribute bn128 phase2_{i}.params phase2_{i+1}.params -e={entropy}
```
Each contribution can be verified by
```bash
# in phase2-bn254/phase2/
cargo run --release --bin verify_single_contribution phase2_{i}.params phase2_{i+1}.params 
```
The BLAKE2b hashes of all contribution files are listes [here](./file_hashes.txt).

## Make final beacon contribution from drand #3320606
There are 111 phase-2 contributions in the ceremony. To remove bias, we add a final beacon contribution from the Drand output at round #3320606
```bash
./drand-client --round 3320606 \
--chain-hash 8990e7a9aaed2ffed73dbd7092123d6f289930540d7651336225dc172e51b2ce \
--url http://api.drand.sh \
--relay /dnsaddr/api.drand.sh
```
The resulting random hex string is
```bash
70b277761bd889e0df98a45aff7d76b3744170c403136b312c1fcec0362a4543
```
Then make the final phase-2 contribution by the beacon randomness (hashed by sha256 for $2^{10}$ iterations) by running
```bash
# in phase2-bn254/phase2/
cargo run --release --bin beacon phase2_111.params 70b277761bd889e0df98a45aff7d76b3744170c403136b312c1fcec0362a4543 10 phase2_beacon.params
```
The BLAKE2b hash of the resulting params file `phase2_beacon.params` after the beacon contribution is
```bash
$ b2sum phase2_beacon.params 
7614bd81f29c315695f0196366a9206a2f295023fbb09425a6ef241be692a5210417567074074d9c359561e64badd302670f0919358e25f928761038e13f0616  phase2_beacon.params
```
To verify the beacon contribution
```bash
# in phase2-bn254/phase2/
cargo run --release --bin verify_single_contribution  phase2_111.params phase2_beacon.params
```

## Bellman import params file to zkey
To generates the final [proving key](../zkLogin.zkey) after the ceremony, run
```bash
npx snarkjs zkey import bellman initial.zkey phase2_beacon.params zkLogin.zkey
```

The BLAKE2b hash of the final zkey file `zkLogin.zkey` is
```bash
$ b2sum zkLogin.zkey 
060beb961802568ac9ac7f14de0fbcd55e373e8f5ec7cc32189e26fb65700aa4e36f5604f868022c765e634d14ea1cd58bd4d79cef8f3cf9693510696bcbcbce  zkLogin.zkey
```
To verify the final zkey file and get a record of all phase-2 contribution hashes, run
```bash
npx snarkjs zkey verify circuit.r1cs ../phase1/pot_final.ptau zkLogin.zkey
```
The verification result and all contribution hashes (beacon contribution listed as #112) can be accessed [here](./contribution_hashes.txt).

## Export verification key
To export the verification key, run
```bash
npx snarkjs zkey export verificationkey zkLogin.zkey zkLogin.vkey
```
The BLAKE2b hash of the verification key `zkLogin.vkey` is
```bash
$ b2sum zkLogin.vkey 
3a5e86d2d4ed16032f88bc2af892012c010f230cc99a80c691e29653c45af048b1679997e1e1a937a97ce683a6cbcb43689f95ae7ec5a9a206e8052abf9bc161  zkLogin.vkey
```
