#!/usr/bin/env bash
set -e

new_key_file=$1

if [ -z ${new_key_file} ]
then
    echo "Usage: $(basename ${BASH_SOURCE}) new_key_file"
    exit 1
fi

rm -r .git/git-crypt
git crypt init
git crypt export-key ${new_key_file}
for f in $(git crypt status | grep -v "not encrypted" | awk '{ print $2; }')
do
    touch $f
    git add $f
done
git commit -m "Rotated encryption key"
