#! /bin/sh
export PGPATH=$PWD/../../../tmp_install/usr/local/pgsql/bin PGDATA=$PWD/node1
PATH="$PGPATH:$PATH"
LD_LIBRARY_PATH="$PGPATH/../lib" psql