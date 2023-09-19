# Phase 1 Transparency

## Reduce perpetual powers of tau to smaller size
We adopt [challenge #0081](https://pse-trusted-setup-ppot.s3.eu-central-1.amazonaws.com/challenge_0081) (resulting from 80 community contributions) from [perpetual powers of tau](https://github.com/privacy-scaling-explorations/perpetualpowersoftau/tree/master/0080_carter_response) in phase 1.
Use the [modified Kobi's implementation](https://github.com/MystenLabs/phase2-bn254) to reduce the perpetual powers of tau to the order of 20 and reproduce challenge_0081_reduced_20:
```bash
git clone https://github.com/MystenLabs/phase2-bn254.git
cd phase2-bn254/powersoftau
cargo run --release --bin reduce_powers challenge_0081 challenge_0081_reduced_20 28 20 256
```
The BLAKE2b hash of the reduced file `challenge_0081_reduced_20` is
```bash
$ b2sum challenge_0081_reduced_20 
1a54dbbcc7037994d1d4d5c1df9271b034457492ba840f8e70b1ae91441900927b2e40849b2c6f2146d15f934c9bb10da2f1adc6e8b506d46e07ec2ddb714188  challenge_0081_reduced_20
```

## Make final beacon contribution from drand #3298000
Follow [drand instructions](https://drand.love/developer/drand-client/#installation) to install drand-client cli and run the following command to fetch randomness at round #3298000
```bash
./drand-client --round 3298000 \
--chain-hash 8990e7a9aaed2ffed73dbd7092123d6f289930540d7651336225dc172e51b2ce \
--url http://api.drand.sh \
--relay /dnsaddr/api.drand.sh
```
The resulting random hex string is
```bash
e60921c4dac7b78e57fbc308f429b22d056f027058143d8b6e30dd6b629aaf9f
```
Then make the final phase-1 contribution by the beacon randomness (hashed by sha256 for $2^{10}$ iterations) by running
```bash
# in phase2-bn254/powersoftau/
cargo run --release --bin beacon_constrained challenge_0081_reduced_20 response_beacon 20 256 e60921c4dac7b78e57fbc308f429b22d056f027058143d8b6e30dd6b629aaf9f 10
```
The BLAKE2b hash of the response file `response_beacon` is
```bash
$ b2sum response_beacon 
4a2897cf3cb86d63a8454cf5b425474fe6b06bc4d7dc8e3f6a532b76f2beed276fec8650d1f00104921459bb52667a77d41cd972877f19e39f51a2bde85f1260  response_beacon
```
To verify the beacon contribution
```bash
# in phase2-bn254/powersoftau/
cargo run --release --bin verify_transform_constrained challenge_0081_reduced_20 response_beacon challenge_final 20 256
```
The BLAKE2b hash of the resulting new challenge file `challenge_final` is
```bash
$ b2sum challenge_final 
cf3badec270805da628f8e9d16778358168ed7896ee07322e4c7a9637eb1a9d2b62cd5c0ca49ec034d1e86f02fe92df462b9e3bb82fc35502dd3c99e2e018f58  challenge_final
```

## Import response file as ptau file
Use the [modified snarkjs](https://github.com/MystenLabs/snarkjs/tree/ceremony) to import a response file from multiple contributions as a ptau file
```bash
git clone --branch ceremony https://github.com/MystenLabs/snarkjs.git snarkjs
cd snarkjs
npm install && npm run build && npm run buildcli

# in snarkjs/
npx snarkjs powersoftau import response_no_origin bn128 20 response_beacon pot20.ptau
```
The BLAKE2b hash of the resulting ptau file `pot20.ptau` is
```bash
$ b2sum pot20.ptau 
876520138d34dbbf2a1ea65d0e4e2f6d9877e7c2b418904360800af0e06807bfe18ded329d1667d8c495f7f2bbb5235d8e18c4deee3ab8c6c950d3ef25468a6c  pot20.ptau
```

## Prepare final ptau file for phase 2
To prepare final ptau file for phase 2, run
```bash
npx snarkjs powersoftau prepare phase2 pot20.ptau pot_final.ptau
```
The BLAKE2b hash of the final ptau file `pot_final.ptau` is
```bash
$ b2sum pot_final.ptau 
516fdf98bef4ab474bf01e336c801b275bdb4c5209ad06351b1f1ebc6f7060b77c11c9adaf861a776e77c2eff9f22cb4dae29fcab12f97489a9f049339904b3c  pot_final.ptau
```