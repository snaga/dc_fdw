#!/bin/sh

TEST_ID=$1
PSQL_OPTS="-p 6432"
DBNAME=testdb

if [ -z $TEST_ID ]; then
    echo "Please specify test id. Abort."
    exit;
fi;

if [ ! -d "/tmp/dc_fdw/t" ]; then
    echo "Creating a symbolic liink in /tmp directory..."
    pushd ../.. > /dev/null
    ln -s `pwd`/dc_fdw /tmp
    popd > /dev/null
fi;

# Global setup
psql -f setup.sql ${PSQL_OPTS} ${DBNAME}

if [ -d ${TEST_ID} ]; then
  psql -f ${TEST_ID}/sql/setup.sql ${PSQL_OPTS} ${DBNAME}
  psql -f ${TEST_ID}/sql/test.sql ${PSQL_OPTS} ${DBNAME} > /tmp/dc_fdw/t/1/output/output.log
  psql -f ${TEST_ID}/sql/teardown.sql ${PSQL_OPTS} ${DBNAME}
else
    echo "Test Id ${TEST_ID} not found. Abort."
    exit;
fi;

# Global teardown
psql -f teardown.sql ${PSQL_OPTS} ${DBNAME}
