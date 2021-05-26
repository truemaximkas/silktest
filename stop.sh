#! /bin/sh
export PGPATH=$PWD/../../../tmp_install/usr/local/pgsql/bin
export PATH="$PGPATH:$PATH"
LD_LIBRARY_PATH="$PGPATH/../lib" pg_ctl -D $PWD/node1 -l node1.log stop
LD_LIBRARY_PATH="$PGPATH/../lib" pg_ctl -D $PWD/node2 -l node2.log stop
