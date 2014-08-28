#!/bin/bash
# www.datometry.com
# jeremy@datometry.com
# 2014.08.21

Experiment_ID=$1			# a generic label to name the experiment
Client_ID=$2					# what is the id of this process
Iterations_To_Run=$3 	# how many iterations should this process run

USER="jdbloom"
DATABASE="emc_test"
HOST="127.0.0.1"
LOGDIR=/mnt/hgfs/emctest/work/logs

QUERYDIR=/mnt/hgfs/emctest/work/queries

# to make this easier, just hardcoded in the names of the queries to run back to back
f1="${QUERYDIR}/q1.sql"
f2="${QUERYDIR}/q2.sql"
f3="${QUERYDIR}/q3.sql"
f4="${QUERYDIR}/q4.sql"
f5="${QUERYDIR}/q5.sql"

Iteration_Current=1
while [ $Iteration_Current -le $Iterations_To_Run ]
do

LOGFILE="${LOGDIR}/out_${Experiment_ID}_${Client_ID}_${Iteration_Current}.log"
ERROR_LOGFILE=${LOGDIR}/out_${Experiment_ID}_error.log

psql -U $USER -d $DATABASE -h $HOST <<EOF 1> $LOGFILE 2>> $ERROR_LOGFILE
\timing on
\i ${f1}
\i ${f2}
\i ${f3}
\i ${f4}
\i ${f5}
EOF



Iteration_Current=`expr $Iteration_Current + 1 `

# if you want to add a sleep timer, can add it here
done

WORKING_LOG=${LOGDIR}/out_${Experiment_ID}_${Client_ID}_working.log
RESULT_LOG=${LOGDIR}/out_${Experiment_ID}_${Client_ID}_result.log

grep Time ${LOGDIR}/out_${Experiment_ID}_${Client_ID}_*.log | sed -n -e 's/^.*Time: \(.*\) ms$/\1/p' > ${WORKING_LOG}

# sum entries in working_log and put in result_log
awk '{ sum += $1 } END { printf "%f\n", sum }' ${WORKING_LOG} > ${RESULT_LOG} 

# delete intermediate files
Iteration_Current=1
while [ $Iteration_Current -le $Iterations_To_Run ]
do
LOGFILE="${LOGDIR}/out_${Experiment_ID}_${Client_ID}_${Iteration_Current}.log"
rm $LOGFILE
Iteration_Current=`expr $Iteration_Current + 1 `
done
#rm $WORKING_LOG
