GIT_LFS_SKIP_SMUDGE=1 git clone https://github.com/sui-foundation/zklogin-ceremony-contributions.git

cd zklogin-ceremony-contributions

git lfs pull --include "v1/zkLogin-main.zkey"

# Keep the file at the top level of the clone, where it was before the v1/ folder existed.
cp v1/zkLogin-main.zkey zkLogin-main.zkey
