#!/bin/bash

set -e

scriptdir=$(cd $(dirname $0); pwd -P)

tmp_dir=`mktemp -d`
mkdir -p $tmp_dir

echo
echo "R1CS compiled files will be in: $tmp_dir/"
echo

srcdir=$scriptdir/../src
testdir=$scriptdir/../tests

# Automatically looks up all the tests and executes them.
cd $testdir

print_logs=0
if [ ! -z "$@" ]; then
    echo "Only running tests matching: $@"
    echo
    print_logs=1
fi

for circom_rel_path in `find . -type f -name "*.circom"`; do
    #echo "Compiling $circom_rel_path"

    if echo "$circom_rel_path" | grep '__lib/' &>/dev/null; then
        #echo "Skipping paths with underscores: $circom_rel_path"
        continue
    fi

    # Only run tests that have been specified as an argument, if any.
    if [ ! -z "$@" ]; then
        if ! echo "$circom_rel_path" | grep "$@" &>/dev/null; then
            continue
        fi
    fi

    # Switch to the right scalar field, if in the file name
    extra_args=
    echo_suffix=
    if echo "$circom_rel_path" | grep 'BN254.circom$' &>/dev/null; then
        extra_args="-p bn128"
        echo_suffix=" (BN254)"
    elif echo "$circom_rel_path" | grep 'BLS12381.circom$' &>/dev/null; then
        extra_args="-p bls12381"
        echo_suffix=" (BLS12-381)"
    fi

    circom_full_path=`readlink -f $circom_rel_path`
    pushd $tmp_dir/ &>/dev/null
    set +e
    # NOTE: Using --O0 for speed.
    circom --verbose --O0 $extra_args -l $srcdir/circuits -l $testdir/ $circom_full_path --r1cs &>logs.txt
    ret=$?
    set -e

    #echo "Return code: $ret"
    if echo "$circom_rel_path" | grep "should-panic/" &>/dev/null; then
        if [ $ret -eq 0 ]; then
            echo -n "ERROR: Expected $circom_rel_path compilation to FAIL!"
            echo "$echo_suffix"
            cat logs.txt
            exit 1
        else
            echo -n "PASS: $circom_rel_path did not compile, as expected."
            echo "$echo_suffix"
            if [ $print_logs -eq 1 ]; then
                cat logs.txt
                echo
            fi
        fi
    else
        if [ $ret -eq 1 ]; then
            echo -n "ERROR: Expected $circom_rel_path compilation to PASS!"
            echo "$echo_suffix"
            cat logs.txt
            exit 1
        else
            echo -n "PASS: $circom_rel_path"
            echo "$echo_suffix"
            if [ $print_logs -eq 1 ]; then
                cat logs.txt
                echo
            fi
        fi
    fi
    popd &>/dev/null
done

echo
echo "All done!"
echo
