#! /bin/bash

# check plumed hash
hash=$(
cd $(plumed info --root)
test -d .git
git log -1 --format="%h"
)

echo "# hash code is $hash"

if cmp <(echo $hash) latest > /dev/null 2> /dev/null ; then

echo "# manual seems up to date"
echo "# to force push, remove 'latest' file and re-run"
exit

fi

echo $hash > latest


# clean present doc
rm -fr *-doc

# grab it from plumed version in the path
cp -R $(plumed info --root)/*doc .

# delete gitignore files
rm */.gitignore

# This file should be here, it is needed otherwise
# files beginning with _ are skipped
touch .nojekyll

cat << EOF
# next thing you should do is:
###
git add --all .
git commit -m "Update to plumed/plumed2@$hash"

## this is better compressing data before push
# git gc --aggressive 
git repack -a -d --depth=250 --window=250 -f

git push origin gh-pages
###
EOF

