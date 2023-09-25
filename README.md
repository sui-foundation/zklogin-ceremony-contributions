# zkcontributions

This repository enlists all trusted Groth16 Zero Knowledge Proof (ZKP) ceremony contributions for generating a Common Reference String (CRS), required for the [zkLogin](https://sui.io/zklogin) project. The ceremony was successfully hosted by the [Sui Foundation](https://sui.io/about). As recommended for every trusted ZKP setup, this repository enables participants to verify their contribution was applied correctly in the chain of sequential contributions, while everyone can verify the final CRS output, which is in turn used to generate zkLogin's proving and verifying key, respectively.

## Contributions format

We adopted [challenge #0081](https://pse-trusted-setup-ppot.s3.eu-central-1.amazonaws.com/challenge_0081) (resulting from 80 community contributions) from [perpetual powers of tau](https://github.com/privacy-scaling-explorations/perpetualpowersoftau/tree/master/0080_carter_response) in phase 1, which is circuit agnostic.
We applied the output of drand #3298000 to remove bias.

For phase 2, we ran a ceremony during Sep 12-18, 2023.
There are 111 contributions, 82 from browser and 29 from docker.
Eventually, we applied the output of drand #3320606 to remove bias from contributions.


All intermediate files can be reproduced following instructions [here](./phase1/README.md) for phase 1 and [here](./phase2/README.md) for phase 2.


## Acknowledgement

We thank all who participated in the ceremony. Here is a list of participants, who consented to publish their names: [here](./contributor_list.tsv).
