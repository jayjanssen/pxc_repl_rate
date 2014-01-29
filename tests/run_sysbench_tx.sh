#!/bin/sh

echo "Sysbench run for $1 seconds"


local_pxc_index=`mysql -e "show global status like 'wsrep_local_index'" --raw --skip-column-names --vertical| tail -n 1`
current_unix_time=`mysql -e "select unix_timestamp()" --raw --skip-column-names --vertical| tail -n 1`

rand_seed=$(( ($current_unix_time / ($local_pxc_index +10 )) + ($current_unix_time % ($local_pxc_index + 10)) ))


start_com_updates=`mysql -e "show global status like 'Com_update'" --raw --skip-column-names --vertical| tail -n 1`
start_inno_updates=`mysql -e "show global status like 'Innodb_rows_updated'" --raw --skip-column-names --vertical| tail -n 1`
start_wsrep_last_committed=`mysql -e "show global status like 'wsrep_last_committed'" --raw --skip-column-names --vertical| tail -n 1`
start_wsrep_replicated=`mysql -e "show global status like 'wsrep_replicated'" --raw --skip-column-names --vertical| tail -n 1`
start_wsrep_replicated_bytes=`mysql -e "show global status like 'wsrep_replicated_bytes'" --raw --skip-column-names --vertical| tail -n 1`

sysbench --db-driver=mysql --test=sysbench_tests/db/oltp.lua --rand-type=uniform --rand-seed=$rand_seed --mysql-user=test --mysql-password=test --mysql-db=test --oltp-table-size=250000 --max-requests=0 --num-threads=48 --max-time=$1 --report-interval=1 run

end_com_updates=`mysql -e "show global status like 'Com_update'" --raw --skip-column-names --vertical| tail -n 1`
end_inno_updates=`mysql -e "show global status like 'Innodb_rows_updated'" --raw --skip-column-names --vertical| tail -n 1`
end_wsrep_last_committed=`mysql -e "show global status like 'wsrep_last_committed'" --raw --skip-column-names --vertical| tail -n 1`
end_wsrep_replicated=`mysql -e "show global status like 'wsrep_replicated'" --raw --skip-column-names --vertical| tail -n 1`
end_wsrep_replicated_bytes=`mysql -e "show global status like 'wsrep_replicated_bytes'" --raw --skip-column-names --vertical| tail -n 1`

com_updates=`expr $end_com_updates - $start_com_updates`
inno_updates=`expr $end_inno_updates - $start_inno_updates`
wsrep_committed=`expr $end_wsrep_last_committed - $start_wsrep_last_committed`
wsrep_replicated=`expr $end_wsrep_replicated - $start_wsrep_replicated`
wsrep_replicated_bytes=`expr $end_wsrep_replicated_bytes - $start_wsrep_replicated_bytes`
wsrep_avg_trx=`expr $wsrep_replicated_bytes / $wsrep_replicated`


echo "Com_updates: $com_updates"
echo "Inno_updates: $inno_updates"
echo "Wsrep committed: $wsrep_committed"
echo "Wsrep replicated: $wsrep_replicated"
echo "Wsrep replicated bytes: $wsrep_replicated_bytes"
echo "Wsrep avg trx size: $wsrep_avg_trx"

