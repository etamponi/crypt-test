#!/bin/bash
set -e

new_key_file=$1

if [ -z ${new_key_file} ]
then
    echo "Usage: $(basename ${BASH_SOURCE}) new_key_file"
    exit 1
fi

rm -r .git/git-crypt
git mv .gitattributes .gitattributes.tmp
git commit -m "Moved .gitattributes to fix key rotation"
git pull --no-edit
git mv .gitattributes.tmp .gitattributes
git commit -m "Readded .gitattributes to fix key rotation"
git crypt unlock ${new_key_file}
