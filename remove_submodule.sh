#!/bin/sh

path=${1%/}
echo $path

if [ ! -d $path ]; then
    echo "submodule not found"
    exit 1
fi

git config -f .git/config --remove-section submodule.$path
git config -f .gitmodules --remove-section submodule.$path
git add .gitmodules
git rm --cached $path
git commit -m "Removed submodule $(basename $path)"
rm -rf $path
rm -rf .git/modules/$path
