#!/bin/bash
DIR="$(dirname "$(readlink -f "$0")")"

pushd $DIR/../../03-fuzzing-new-targets/zephyr-os/prebuilt_samples/CVE-no-CVE-false-positive-rf-size-check/POC
./run.sh $@
popd