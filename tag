#!/bin/bash

# --------------------------------------------------------------------
# Run this within a local respository directory to tag the latest
# commit, both locally and in the remote repository.
#
# For example:
#
# $ ./tag 2019-12-04
# --------------------------------------------------------------------

if [[ ! $1 ]] ; then 
  echo "No version \$1 (e.g. 2.0.1)"
  exit 1
fi

version=$1
major_version=$(echo $version | cut -c 1)

current_branch=`git rev-parse --abbrev-ref HEAD`

if [[ $major_version == 2 && $current_branch != master ]] ; then
  echo "Can only tag version $version in branch master, not branch $current_branch"
  echo "Can only tag branch 'master'"
  exit 2
fi

echo "New tag: $version"
echo

echo "Existing Tags:"
git tag
echo

x=`git tag | grep $version`
if [[ $? -eq 0 ]] ; then 
  echo "ERROR: Tag $version already exists"
  exit 1
fi

set -x

# Find checksum of latest commit
latest_checksum=`git log --pretty=format:'%H' -n 1`

# Create tag in local repository
git tag -a $version -m "version $version" $latest_checksum

# Look at at all my tags
git tag

# Push tag to remote repository      
git push origin $version

set +x
