#!/bin/bash
set -e

cd $(dirname ${BASH_SOURCE})

new_key_file=$1

if [ -z ${new_key_file} ]
then
    echo "Usage: $(basename ${BASH_SOURCE}) new_key_file"
    exit 1
fi

checkout_encrypted() {
    encrypted_files=$(git crypt status | grep -v "not encrypted" | awk '{ print $2; }')
    for f in ${encrypted_files}
    do
        git checkout $f
    done
}

# Get encrypted files before we remove .gitattributes, that's why we don't use checkout_encrypted
encrypted_files=$(git crypt status | grep -v "not encrypted" | awk '{ print $2; }')

# Forget that we decrypted the repo
rm -rf .git/git-crypt

# Forget about encrypted files
git mv .gitattributes .gitattributes.tmp
git commit -m "$(hostname) Moved .gitattributes to fix key rotation"

# Revert any local dirtiness that git pull has caused
for f in ${encrypted_files}
do
    git checkout $f
done

# Stash any local change caused by git pull or by our local work
stash_out=$(git stash)
echo ${stash_out}

# Pull again and merge the previous commit
git pull --no-edit

# Revert the .gitattributes change
git mv .gitattributes.tmp .gitattributes
git commit -m "$(hostname) Readded .gitattributes to fix key rotation"

# Make sure we don't have any dirty encrypted file
checkout_encrypted

# Pop from stash
if [ "${stash_out}" != "No local changes to save" ]
then
	git stash pop
	# Check again because the last pop may have changed the .gitattributes
	checkout_encrypted
fi

git crypt unlock ${new_key_file}
