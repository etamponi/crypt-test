#!/bin/bash
set -e

cd $(dirname ${BASH_SOURCE})

new_key_file=$1

if [ -z ${new_key_file} ]
then
    echo "Usage: $(basename ${BASH_SOURCE}) new_key_file"
    exit 1
fi

# Get encrypted files
encrypted_files=$(git crypt status | grep -v "not encrypted" | awk '{ print $2; }')
# Revert any local dirtiness that git pull has caused on the encrypted files
for f in ${encrypted_files}
do
    git checkout $f
done

# Stash any local change caused by git pull or by our local work
stash_out=$(git stash)
echo ${stash_out}

# Lock repository and forget key
git crypt lock
rm -rf .git/git-crypt

# Pull again and unlock with new key file
git clean -f -d
git pull
git crypt unlock ${new_key_file}

# Pop from stash
if [ "${stash_out}" != "No local changes to save" ]
then
        git stash pop
fi
