#!/bin/bash

set -e

USAGE="$ scripts/make.sh ontology-name"

if [ -z $1 ] || [ ! -z $2 ]; then
  echo "Usage: $USAGE"; exit 1
fi

# Download nanopub jar if needed:
scripts/np help 2> /dev/null

scripts/update-timestamp.sh $1

LASTRELEASE=$(scripts/get-last-release-nr.sh $1)

if [ -z $LASTRELEASE ]; then
  echo "No previous release found"
  scripts/np sign -o $1.trig $1.trig.pre
else
  echo "Previous release: $LASTRELEASE"
  # Add `-f '-h AlwaysDifferentFingerprints'` to the next line to force new nanopub creation:
  scripts/np op reuse -s -t '-h UriBaseTopics' -x releases/$1.$LASTRELEASE.trig -a $1.temp.trig $1.trig.pre
  scripts/np sign -i -o $1.trig $1.temp.trig
  rm $1.temp.trig
fi

if [ -f scripts/make-$1-index.sh ]; then
  scripts/make-$1-index.sh
fi

scripts/make-rewrite-rules.sh $1

scripts/make-large-htaccess.sh

scripts/make-doc.sh $1
