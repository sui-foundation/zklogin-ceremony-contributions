# zkLogin ceremony records

This repository holds the public record of each trusted-setup ceremony for [zkLogin](https://sui.io/zklogin).
A ceremony makes the Groth16 proving key and verification key for one version of the zkLogin circuit.
The record lets each contributor check that the final keys include their contribution, and lets anyone verify the final keys.

## Ceremonies

| Ceremony | Circuit | Date | Contributions | Record |
| --- | --- | --- | --- | --- |
| zkLogin v1 | zkLogin v1, 2^20 | September 12-18, 2023 | 111 | [`v1/`](./v1/README.md) |
| zkLogin v2 | zkLogin v2, 2^21 | To be added | To be added | [`v2/`](./v2/README.md) |

## Layout

```text
v1/                      Record of the 2023 ceremony, with all files in Git LFS
v2/                      Record of the zkLogin v2 ceremony
download-main-zkey.sh    Downloads the v1 proving key for Mainnet and Testnet
download-test-zkey.sh    Downloads the v1 proving key for Devnet
```

The two ceremonies store their files in different places:

- **v1** keeps each file in this repository through [Git LFS](https://git-lfs.com/).
- **v2** ran on Sui and stored each file on [Walrus](https://www.walrus.xyz). This repository holds the hashes,
  the Walrus blob IDs, and the on-chain IDs, so that each file can be found and checked.

## Download the v1 proving keys

Install Git LFS first. Then run one script. Each script clones this repository without the large files and downloads one key.

```sh
# Mainnet and Testnet
wget -O - https://raw.githubusercontent.com/sui-foundation/zklogin-ceremony-contributions/main/download-main-zkey.sh | bash

# Devnet
wget -O - https://raw.githubusercontent.com/sui-foundation/zklogin-ceremony-contributions/main/download-test-zkey.sh | bash
```

The key is then at `zklogin-ceremony-contributions/zkLogin-main.zkey` or `zklogin-ceremony-contributions/zkLogin-test.zkey`.
