#!/bin/sh

DIR=$(cd $(dirname $0) && pwd)

SUITE_DIR=${DIR}/compatibility
ROOT_DIR=`dirname ${DIR}`

if [ ! -e $DIR/js.jar ]; then
    $DIR/download_rhino.sh
fi

if [ $# -eq 1 ]; then
    TEST_SUITES=$1
else
    TEST_SUITES=$(ls $SUITE_DIR)
fi

NUM=1
for version in $TEST_SUITES
do
    if [ $version = '1.12.0' -o $version = '1.11.0' ]; then 
        echo "# skip $version"
        continue;
    fi

    java -jar $DIR/js.jar $DIR/rhino/test_compat_rhino.js $version $ROOT_DIR > ${DIR}/actual.txt

    $DIR/compare_with_expected_output.sh $version $NUM

    NUM=`expr $NUM + 1`
done

echo "1..$(expr $NUM - 1)"
