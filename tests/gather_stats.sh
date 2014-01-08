#!/bin/bash

outputdir="/tmp/pxc_test"
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ ! -d ${outputdir} ]
then
  mkdir -p ${outputdir}
fi

mpstat 1 > ${outputdir}/mpstat.out &
mpstat_pid=$!

vmstat 1 > ${outputdir}/vmstat.out &
vmstat_pid=$!

iostat -mx 1 > ${outputdir}/iostat.out &
iostat_pid=$!

mysqladmin ext -i1 > ${outputdir}/mysqladmin.out &
mysqladmin_pid=$!

$script_dir/collect_diskstats.sh > ${outputdir}/diskstats.out &
diskstats_pid=$!

function kill_collection() {
  kill -9 ${mpstat_pid}
  kill -9 ${vmstat_pid}
  kill -9 ${iostat_pid}
  kill -9 ${mysqladmin_pid}
  kill -9 ${diskstats_pid}
}


sleep $1
kill_collection

wait ${mpstat_pid}
wait ${vmstat_pid}
wait ${iostat_pid}
wait ${diskstats_pid}
wait ${mysqladmin_pid}

