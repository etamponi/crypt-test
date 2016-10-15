#!/bin/bash
set -e

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

encrypted_files=$(git crypt status | grep -v "not encrypted" | awk '{ print $2; }')

git mv .gitattributes .gitattributes.tmp
git commit -m "Moved .gitattributes to fix key rotation"

for f in ${encrypted_files}
do
    git checkout $f
done

git stash
git pull --no-edit
git crypt unlock ${new_key_file}
git mv .gitattributes.tmp .gitattributes
git commit -m "Readded .gitattributes to fix key rotation"
checkout_encrypted
git stash pop
checkout_encrypted
