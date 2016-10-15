#!/bin/bash
set -e

new_key_file=$1

if [ -z ${new_key_file} ]
then
    echo "Usage: $(basename ${BASH_SOURCE}) new_key_file"
    exit 1
fi

git mv .gitattributes .gitattributes.tmp
git commit -m "Moved .gitattributes to fix key rotation"
git pull --no-edit
git crypt unlock ${new_key_file}
git mv .gitattributes.tmp .gitattributes
git commit -m "Readded .gitattributes to fix key rotation"
for f in $(git crypt status | grep -v "not encrypted" | awk '{ print $2; }')
do
    git checkout $f
done
