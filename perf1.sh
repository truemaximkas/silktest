#! /bin/sh

sudo perf record -p $1 -F 99 --call-graph dwarf,16384
