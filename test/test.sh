#!/bin/sh

INPUT_CHECKOUTS_DIR=../test/success ../workdir/entrypoint.sh
exit_code=$?

echo "happy case test"
echo "expected=0 actual=$exit_code"

if [ ${exit_code} -ne 0 ]; then
  fail="true"
fi

INPUT_CHECKOUTS_DIR=../test/error ../workdir/entrypoint.sh
exit_code=$?
echo "break check test"
echo "expected=1 actual=$exit_code"

if [ ${exit_code} -ne 1 ]; then
  fail="true"
fi

rm ../test/success/master/buf.bin ../test/error/master/buf.bin

if [ "${fail}" = "true" ]; then
  exit 1
fi

