#!/bin/sh

set -e

scriptdir=$(cd $(dirname $0); pwd -P)

tmp_dir=`mktemp -d`
mkdir -p $tmp_dir

echo
echo "R1CS compiled files will be in: $tmp_dir/"
echo

srcdir=$scriptdir/../src

cd $srcdir/tests

for source in `find . -type f -name *.circom`; do
    full_path=`readlink -f $source`

    #echo "Source file: $source"
    echo "Compiling $full_path"

    (
        cd $tmp_dir/
        circom --O0 -l $srcdir/ $full_path --r1cs
    )
    echo
done
