# zkLogin v2 ceremony

This folder is the public record of the trusted-setup ceremony for the zkLogin v2 circuit.

**Status: the ceremony has not started. This page will be completed when the ceremony is closed and audited.**

The ceremony runs on Sui, and each file is stored on Walrus.
The code, the contributor instructions, and the audit tool are in
[MystenLabs/groth16-ceremony](https://github.com/MystenLabs/groth16-ceremony).

## What this folder will contain

| File | Content |
| --- | --- |
| `README.md` | This page: the summary of the ceremony and how to verify it |
| `phase1/` | How the phase-1 file was made from the Perpetual Powers of Tau, its hashes, and how to download and verify it |
| `ceremony.json` | The network, the package ID, the ceremony object ID, and the transaction digests |
| `contributors.tsv` | One row for each accepted contribution: index, name, address, contribution hash, Walrus blob ID, time |
| `files.tsv` | One row for each ceremony file: name, size, `sha256`, `b2sum`, Walrus blob ID |
| `zkLogin-v2.vkey.json` | The final verification key |
| `audit.log` | The output of the audit of the closed ceremony |

The large files are not copied into this repository. `files.tsv` gives the Walrus blob ID and the hashes of each one.

## Inputs

These values are fixed before the ceremony starts.

| Item | Value |
| --- | --- |
| Circuit | zkLogin v2, built with `circom --O2`. It has 1,997,333 constraints. |
| R1CS `sha256` | `e7d9cb1336140b231d07235fee157403f3932b51fb4a1017a750fd284c3d894d` |
| R1CS `b2sum` | `bc8cdc434586a667aca8f5ab7c11ee14ece87e231570c43845a1cb0a8d82b268ed5dff1388f642476ad6c94c2f1451419e0a93ea57b8eb187163702f14af142f` |
| Phase 1 | Contribution `0086` of the Perpetual Powers of Tau, with drand round 6440000 as the final beacon, prepared at 2^28 and truncated to 2^21. Its chain has 67 contributions. See [`phase1/`](./phase1/README.md). |
| Phase 1 file | `ppot_0086_21.ptau`, Walrus blob ID `8V0atXFR_OLyOzdVtLQ9IN6H88PQmgE9YgSD7BbeqIE` |
| Phase 1 `b2sum` | `c9972d6f19100faad8382a585dac7fed6090320228c1bb0e64e32cc5689c340e4e8aeb4790eb1297649de83a798b4cebe624d9da4e74fa94d8767c4047c12a62` |

## Result

To be added after the ceremony is closed:

- The network, the package ID, and the ceremony object ID.
- The number of accepted contributions and the dates.
- The final beacon, which Sui randomness draws on-chain when the contributions end.
- The hashes and the Walrus blob IDs of the final proving key and the final verification key.

## How to verify

To be added with the result. The audit tool in `MystenLabs/groth16-ceremony` reads the ceremony object on Sui,
downloads each file from Walrus, and checks the full chain of contributions against the R1CS and the phase-1 file.
