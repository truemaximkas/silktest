#! /bin/sh
export PGPATH=$PWD/../../../tmp_install/usr/local/pgsql/bin
export PATH="$PGPATH:$PATH"
LD_LIBRARY_PATH="$PGPATH/../lib" numactl --membind=1 --cpunodebind=1 -- pg_ctl -D $PWD/node1 -l node1.log start
LD_LIBRARY_PATH="$PGPATH/../lib" numactl --membind=1 --cpunodebind=1 -- pg_ctl -D $PWD/node2 -l node2.log start
