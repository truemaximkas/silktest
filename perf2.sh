#! /bin/sh

sudo perf script | ./FlameGraph/stackcollapse-perf.pl > out.perf-folded
./FlameGraph/flamegraph.pl out.perf-folded > $1.svg

