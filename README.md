This is a repo that helps me get acquainted with the git-crypt tool

Usage
---

Install git-crypt, use it with symmetric key encryption.

Put `rotate-key.sh` and `fix-rotation.sh` at the root of your git repository.

Encrypt a directory
---

If you want to encrypt a directory named `secrets` and all sub directories, add this to .gitattributes:

	secrets/** filter=git-crypt diff=git-crypt

Rotate symmetric key
---

Make sure all changes to .gitattributes are committed, then run `rotate-key.sh $NEW_KEY_FILE` and push.

Fix git-crypt after rotation
---

Run `fix-rotation.sh $NEW_KEY_FILE` to fix the repository after a pull.
