This is a repo that helps me get acquainted with the git-crypt tool

Encrypt a directory
---

If you want to encrypt a directory named `secrets` and all sub directories, add this to .gitignore:

	secrets/** filter=git-crypt diff=git-crypt

Rotate symmetric key
---

	rm -r .git/git-crypt
	git crypt init
	git crypt export-key $NEW_KEY_FILE
	for f in $(git crypt status | grep -v "not encrypted" | awk '{ print $2; }')
	do
		touch $f
		git add $f
	done
	git commit -m "Rotated encryption key"

Fix git-crypt after rotation
---

Run `fix-rotation.sh $NEW_KEY_FILE` to fix the repository after a pull
