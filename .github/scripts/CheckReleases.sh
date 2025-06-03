#!/bin/bash

set -x
set -v

GetReleases()
 {
  list=$(gh release list -R "$1" --json tagName | jq -r 'map(select(true))[] | (.tagName)' | sed s/version_//g)
  tmpfile=mktemp
  touch $tmpfile
  for i in $list; do
    if [[ $i != *-* ]] && dpkg --compare-versions $i "ge" "2.9"; then 
      echo $i >>$tmpfile
    fi
  done
  sort <$tmpfile >$2
  rm -f $tmpfile
 }
 
GetReleases "prusa3d/PrusaSlicer" "./PrusaSlicer.Releases"
GetReleases "gneiss15/GithubActionsTest" "./GithubActionsTest.Releases"
export newReleases="$(comm -23 PrusaSlicer.Releases GithubActionsTest.Releases)"
rm -f "./PrusaSlicer.Releases" "./GithubActionsTest.Releases"

