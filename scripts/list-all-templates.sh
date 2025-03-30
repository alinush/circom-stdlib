#!/bin/bash

set -e

scriptdir=$(cd $(dirname $0); pwd -P)

cd $scriptdir/..
grep "^template" src/ -Inr
