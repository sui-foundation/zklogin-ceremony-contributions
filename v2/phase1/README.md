# zkLogin v2: phase 1

Phase 1 (powers of tau) for the zkLogin v2 circuit. We did not run a new phase 1. Like [v1](../../v1/phase1/README.md), we adopt the [perpetual powers of tau](https://github.com/privacy-ethereum/perpetualpowersoftau) (PPOT) community ceremony and close it with a public beacon. Two things changed from v1:

* v2 adopts PPOT up to contribution **0086**, up from 0080 in v1. The chain of records in the file has 67 contributions, not 86, because PPOT's chain forks after 0058 and continues at 0078: 0001 to 0058, then 0078 to 0086. The [PPOT README](https://github.com/privacy-ethereum/perpetualpowersoftau) explains the fork.
* v2 uses a **2^21** setup instead of 2^20, because the v2 circuit has 1,997,333 constraints and does not fit in 2^20.

The process follows the one PPOT used for its published [0080 phase 2 files](https://github.com/privacy-ethereum/perpetualpowersoftau#prepared-phase-2-files). We converted the 0086 response to a snarkjs `.ptau`, applied a drand beacon, prepared it for phase 2 at the full 2^28, and then cut the 2^21 file out of that result. Nothing in the process adds secret entropy. Every step is deterministic, so repeating it gives the same bytes, and the hashes in [B2SUMS.txt](./B2SUMS.txt) let you check that.

The file the zkLogin v2 phase 2 uses is `ppot_0086_21.ptau`:

| | |
| --- | --- |
| Size | 2,416,021,477 bytes (2.25 GiB) |
| BLAKE2b (`b2sum`) | `c9972d6f19100faad8382a585dac7fed6090320228c1bb0e64e32cc5689c340e4e8aeb4790eb1297649de83a798b4cebe624d9da4e74fa94d8767c4047c12a62` |
| Walrus blob ID | `8V0atXFR_OLyOzdVtLQ9IN6H88PQmgE9YgSD7BbeqIE` |
| Walrus shared object | `0x58927041ddc22c8c758074392cb1392f08ba51abe79b3fe7d8c5d92d88fcf2fb` (mainnet) |

Its BLAKE2b hash is the `phase1_digest` committed on-chain by the zkLogin v2 ceremony. If your copy has the same hash, it is the exact file the ceremony used.

The file is too large for Git LFS here, so it is stored on [Walrus](https://www.walrus.xyz) instead. See [Download](#download).

## Inputs

* `response_0086`, the response file of PPOT [contribution 0086](https://github.com/privacy-ethereum/perpetualpowersoftau/tree/master/0086_nebra_response). 51,539,607,552 bytes. Its BLAKE2b hash is the value in that contribution's verification log:

  ```
  9dd89930afaaa29178878d459794fe351c4f70bcf76f5d469e1f809d4563a6150b168bd0d7087e7ae200b57da481a898832ab70760fdd5863eb22ece736e530a
  ```

* [`pot28_0086_nopoints.ptau`](https://github.com/privacy-ethereum/perpetualpowersoftau/tree/master/0086_nebra_response) from the PPOT repository. It holds the contribution records up to 0086 and no points.
* drand round 6,440,000 as the beacon. See [Beacon](#beacon).

## Software

snarkjs from [MystenLabs/snarkjs](https://github.com/MystenLabs/snarkjs), which is snarkjs 0.7.6 with one fix ([PR #10](https://github.com/MystenLabs/snarkjs/pull/10), merged as `f5dd39f`). Upstream snarkjs stored the BLAKE2b byte counter in a contribution record as a 32-bit number. For any file above 4 GiB, the record then holds a truncated hasher state, and `powersoftau verify` on the 2^28 file fails at the challenge chain check. The fix stores the counter as two words.

Use this snarkjs for every step, not only for `verify`. The counter is written into the contribution record at import and beacon time, so a file produced with unfixed snarkjs cannot be repaired afterwards. The run itself used the fix at commit `a7acd5b`, which writes the same bytes on this code path.

One more change, for speed only. In `powersoftau_preparephase2.js` we opened the input and output files with a 1 GiB cache and 16 MiB pages instead of the fastfile defaults of 256 KiB and 4 KiB. The single-threaded stretches of `prepare phase2` read about 18 times faster that way. The output is byte for byte the same.

Hardware: Ubuntu 24.04, 48 cores, 503 GB of memory, Node.js v20.20.2. `prepare phase2` peaked at about 396 GB.

Below, `snarkjs` means `node --max-old-space-size=300000 build/cli.cjs` in a checkout of that snarkjs.

## Beacon

The beacon randomness is round 6,440,000 of the [drand](https://drand.love) League of Entropy default chain (chain hash `8990e7a9aaed2ffed73dbd7092123d6f289930540d7651336225dc172e51b2ce`, the same chain v1 used). The round was emitted on 2026-09-05 at 17:57:00 UTC. We picked it on 2026-08-31, five days ahead.

The value is `f7aebf4ea3a437940698fdab30d5f5b6d64c3d64abefd85f7bf752e446fd2211`. You can fetch it yourself:

```bash
curl https://api.drand.sh/public/6440000
```

We used 31 iterations for the beacon hash (2^31 SHA-256 rounds), as PPOT did for its 0080 set.

## Steps

1. Make the starting file for the import.

   `import response` wants a `.ptau` with the contribution records up to 0085, and PPOT only publishes the records up to 0086. So we took `pot28_0086_nopoints.ptau`, dropped its last record, and wrote the rest back out. This uses snarkjs's own read and write helpers and touches no points. Run from the snarkjs checkout:

   ```js
   import * as binFileUtils from '@iden3/binfileutils';
   import * as utils from './src/powersoftau_utils.js';
   const { fd, sections } = await binFileUtils.readBinFile('pot28_0086_nopoints.ptau', 'ptau', 1);
   const { curve, power, ceremonyPower } = await utils.readPTauHeader(fd, sections);
   const records = await utils.readContributions(fd, curve, sections);
   records.pop();
   const out = await binFileUtils.createBinFile('pot28_0085_nopoints.ptau', 'ptau', 1, 2);
   await utils.writePTauHeader(out, curve, power, ceremonyPower);
   await utils.writeContributions(out, curve, records);
   await out.close(); await fd.close();
   ```

2. Convert the response to `.ptau`:

   ```bash
   snarkjs powersoftau import response pot28_0085_nopoints.ptau response_0086 pot28.ptau -n="nebra"
   ```

3. Apply the beacon:

   ```bash
   snarkjs powersoftau beacon pot28.ptau pot28_beacon.ptau f7aebf4ea3a437940698fdab30d5f5b6d64c3d64abefd85f7bf752e446fd2211 31 -n="drand round 6440000"
   ```

4. Prepare for phase 2 at the full degree 28:

   ```bash
   snarkjs powersoftau prepare phase2 pot28_beacon.ptau pot28_final.ptau -v
   ```

5. Cut out every lower degree. `truncate` takes only the input file and names its outputs after it, `pot28_final_01.ptau` through `pot28_final_27.ptau`:

   ```bash
   snarkjs powersoftau truncate pot28_final.ptau -v
   ```

   A file prepared directly at degree 21 is not byte-identical to the truncated one. `prepare phase2` fills the last slot of the top Lagrange tauG1 level with zero, while `truncate` copies the real point from the larger file. Both are valid for a Groth16 setup. We use the truncated file, as PPOT did for its 0080 set.

6. Rename. `pot28_final_NN.ptau` becomes `ppot_0086_NN.ptau`, and `pot28_final.ptau` becomes `ppot_0086_final.ptau`.

7. Verify:

   ```bash
   snarkjs powersoftau verify ppot_0086_21.ptau
   ```

| Step | Time |
| --- | ---: |
| prepare phase2 | 163 h 42 min |
| truncate, all 27 files | 32 min |
| verify, degree 21 | 1 h 49 min |

## Hashes

[B2SUMS.txt](./B2SUMS.txt) lists the BLAKE2b hash of every degree from 1 to 28, of the intermediate files `pot28.ptau` and `pot28_beacon.ptau`, and of `response_0086`. Only degree 21 is used by zkLogin v2. The others are listed so that anyone repeating the run can check each step.

## Other degrees

The same run produced a phase-2-ready file for every degree from 1 to 28, `ppot_0086_01.ptau` through `ppot_0086_27.ptau` and `ppot_0086_final.ptau`. Every file is exactly 1152 * 2^degree + 102373 bytes. Only degree 21 is on Walrus so far. We plan to upload the others and list their blob IDs here. A single Walrus blob can hold at most 13.6 GiB, so degrees 24 to 28 will go up in parts, with a manifest that lists the parts in order. Until then, the hashes in [B2SUMS.txt](./B2SUMS.txt) let you check a file you made yourself with the steps above.

## Download

You can read from the Walrus storage nodes with the Walrus CLI, which checks every piece against the blob ID as it downloads. Or you can fetch from a public aggregator over plain HTTP, which is simpler, but then the checking is on you.

With the Walrus CLI (install it with [suiup](https://github.com/MystenLabs/suiup)). Reading needs no wallet and no tokens:

```bash
suiup install walrus@mainnet
mkdir -p ~/.config/walrus
curl -o ~/.config/walrus/client_config.yaml https://docs.wal.app/setup/client_config.yaml
walrus --context mainnet read 8V0atXFR_OLyOzdVtLQ9IN6H88PQmgE9YgSD7BbeqIE --out ppot_0086_21.ptau
```

With an aggregator:

```bash
curl -o ppot_0086_21.ptau https://aggregator.walrus-mainnet.walrus.space/v1/blobs/8V0atXFR_OLyOzdVtLQ9IN6H88PQmgE9YgSD7BbeqIE
```

Walrus storage is paid for a fixed number of epochs. The blob is a shared object, so anyone can extend it with `walrus extend`.

## Verify

Check the bytes first, then the ceremony history.

1. The size should be exactly 1152 * 2^21 + 102373 = 2,416,021,477 bytes.
2. `b2sum ppot_0086_21.ptau` should print the `c9972d6f...` hash above.
3. `walrus --context mainnet blob-id ppot_0086_21.ptau` should print `8V0atXFR_OLyOzdVtLQ9IN6H88PQmgE9YgSD7BbeqIE`. This needs the CLI but no network.
4. `snarkjs powersoftau verify ppot_0086_21.ptau`, with the snarkjs from [Software](#software), checks every contribution back to the first one, the beacon, and the prepared sections. Expect about two hours, most of it replaying the beacon's 2^31 hash iterations. The list it prints should have 67 contributions, ending with nebra's 0086, followed by the beacon `f7aebf4e...` with 31 iterations, and the last line should be `Powers Of tau file OK!`.

## References

* Perpetual powers of tau: [privacy-ethereum/perpetualpowersoftau](https://github.com/privacy-ethereum/perpetualpowersoftau), contribution [0086](https://github.com/privacy-ethereum/perpetualpowersoftau/tree/master/0086_nebra_response)
* snarkjs with the 4 GiB fix: [MystenLabs/snarkjs#10](https://github.com/MystenLabs/snarkjs/pull/10)
* zkLogin v2 ceremony record: [../README.md](../README.md), code: [MystenLabs/groth16-ceremony](https://github.com/MystenLabs/groth16-ceremony)
* zkLogin v1 phase 1: [../../v1/phase1/README.md](../../v1/phase1/README.md)
