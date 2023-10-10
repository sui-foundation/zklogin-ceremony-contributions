# zkcontributions

This repository enlists all trusted Groth16 Zero Knowledge Proof (ZKP) ceremony contributions for generating a Common Reference String (CRS), required for the [zkLogin](https://sui.io/zklogin) project. The ceremony was successfully hosted by the [Sui Foundation](https://sui.io/about). As recommended for every trusted ZKP setup, this repository enables participants to verify their contribution was applied correctly in the chain of sequential contributions, while everyone can verify the final CRS output, which is in turn used to generate zkLogin's proving and verifying key, respectively.

## Downloading files

1. Install [git-lfs](https://git-lfs.com/) to download any large file.

2. It is recommended to only download specific files of interest. For example, to download the proving key (`zkLogin.zkey`) run:

```bash
GIT_LFS_SKIP_SMUDGE=1 git clone git@github.com:sui-foundation/zklogin-ceremony-contributions.git
git lfs pull --include "zkLogin.zkey"
```

## Contributions format

We adopted [challenge #0081](https://pse-trusted-setup-ppot.s3.eu-central-1.amazonaws.com/challenge_0081) (resulting from 80 community contributions) from [perpetual powers of tau](https://github.com/privacy-scaling-explorations/perpetualpowersoftau/tree/master/0080_carter_response) in phase 1, which is circuit agnostic.
We applied the output of drand #3298000 to remove bias.

For phase 2, we ran a ceremony during Sep 12-18, 2023.
There are 111 contributions, 82 from browser and 29 from docker.
Eventually, we applied the output of drand #3320606 to remove bias from contributions.


All intermediate files can be reproduced following instructions [here](./phase1/README.md) for phase 1 and [here](./phase2/README.md) for phase 2.


## Acknowledgement

We thank all who participated in the ceremony. Here is a list of participants, who consented to publish their names: [here](./contributor_list.tsv).

```
Contributor's name (by alphabetic order)
Aditya Kumar Verma
Antoine C
Ari Juels
Arnab Roy
AstroStakers
Avradip Mandal
Ben Riva
BlockVision
Brian Long
Brightlystake
Charanjit Jutla
Charles Dou
Chuck Veenvliet
CryptoJack
Dahlia Malkhi
DAIC GmbH
Daniil Khyzhniak
Danny Sim
David Wong
Deepa Sathaye
Deepak Maram
DenysK | Stardust Staking
Don Beaver
Ducca, Staketab
Evgeny Garanin
Fan Zhang
Fausto StakingCabin
Flavian Manea
Foteini Baldimtsi
George Digkas
Greg North
GV
Hart Montgomery
Hyunggi Kim
Ignacio
Ioannis Ioannidis
Ivan Merin
Jasleen Malvai
Jens Groth
Jeonghwan
Jeongseup, Son
JJuunee Zhang
John Mitchell
John Youngseok Yang
Joonkyo Kim
joy wang
JulI0 | Latitude.sh
Junji Hashimoto
K | BartestneT
Karthik Kalyanaraman
Kevin | Staking Defense League
Kevin Lewi
Kevin Yu
knox hutchinson
Kobi Gurkan
Kostas
Lai Yutung
Luka
M3dium Rare
Mahdi Sedaghat
Marco Broeken
Masayuki ABE
Max Sherwood
Michel Abdalla
Mikhail
Miranda Christ
Moonlet
Muhammad Elsayeh
Nelrann
Nick Sullivan
Nicolas Ochem
Nikita Pashkov
Ola Muse
Peihao Li
Philip Glazman
POH YONG HWANG
PONGCHAI TANGBOWONWEERAKUN
Rohan Murukutla
Roman Osadchyi
Sergey Ilin
Tiago Machado
Wade Abel
Wenyi Huang
winlin
wizardfiction
Yan Ji
Yi Lu
Yobi
Zhijie
```
