#!/bin/bash

set -e

USAGE="$ scripts/make-ntemplate-index.sh"

if [ ! -z $1 ]; then
  echo "Usage: $USAGE"; exit 1
fi

LASTRELEASE=$(scripts/get-last-release-nr.sh ntemplate)

if [ -z $LASTRELEASE ]; then
  echo "No previous release found"
  LASTINDEXARG=""
else
  LASTINDEX=$(
    cat releases/ntemplate.index.$LASTRELEASE.trig \
    | egrep '^@prefix this:' \
    | tail -1 \
    | sed -r 's/.*<(.*)>.*/\1/'
  )
  echo "Supersedes index: $LASTINDEX"
  LASTINDEXARG="-x $LASTINDEX"
fi

echo "Making index..."
scripts/np mkindex \
  -u https://w3id.org/np/o/ntemplate/np/index/ \
  -c https://orcid.org/0000-0002-1267-0234 \
  -t "Nanopublications representing the Nanopublication Template Ontology" \
  -l https://creativecommons.org/publicdomain/zero/1.0/ \
  $LASTINDEXARG \
  -o ntemplate.index.trig \
  ntemplate.trig

