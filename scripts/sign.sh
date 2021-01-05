#!/bin/bash

set -e

USAGE="$ scripts/sign.sh ontology-name"

if [ -z $1 ] || [ ! -z $2 ]; then
  echo "Usage: $USAGE"; exit 1
fi

if [ ! -f $1.trig.pre ]; then
  echo "File $1.trig.pre does not exist"; exit 1
fi

echo "Signing $1.trig..."
scripts/np sign -o $1.signed.trig $1.trig
