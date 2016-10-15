This is a repo that helps me get acquainted with the git-crypt tool

Encrypt a directory
===================

If you want to encrypt a directory named `secrets` and all sub directories, add this to .gitignore:

	secrets/** filter=git-crypt diff=git-crypt
