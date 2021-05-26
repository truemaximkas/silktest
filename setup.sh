#!/usr/bin/env sh

export PGPATH=$PWD/../../../tmp_install/usr/local/pgsql/bin
export PATH="$PGPATH:$PATH" LD_LIBRARY_PATH="$PGPATH/../lib"

pg_ctl -D node1 stop > /dev/null
pg_ctl -D node2 stop > /dev/null

rm -rf node1 node2
rm node1.log node2.log

initdb -D node1
#initdb -D node2

#echo 'port = 5433' >> node2/postgresql.conf

echo 'enable_partitionwise_join = 1' >> node1/postgresql.conf
echo 'enable_partitionwise_aggregate = 1' >> node1/postgresql.conf
echo 'postgres_fdw.use_remote_estimate = 1' >> node1/postgresql.conf
echo "shared_preload_libraries = 'silk'" >> node1/postgresql.conf

#echo 'enable_partitionwise_join = 1' >> node2/postgresql.conf
#echo 'enable_partitionwise_aggregate = 1' >> node2/postgresql.conf
#echo 'postgres_fdw.use_remote_estimate = 1' >> node2/postgresql.conf

pg_ctl -D node1 -l node1.log start
#pg_ctl -D node2 -l node2.log start

createdb
#createdb -p5433

psql -f init1.sql
#psql -p5433 -f init2.sql

psql -f load.sql

#psql -c 'ANALYSE'
#psql -p5433 -c 'ANALYSE'
