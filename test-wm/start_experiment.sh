#!/bin/bash
# www.datometry.com
# jeremy@datometry.com
# 2014.08.21

# this starts the experiment

exp_time_start_formatted=$(date)
exp_time_start_epochtime=$(date +%s)

Experiment_ID=$1				# a generic label to name the experiment
Clients_To_Start=$2   	# how many clients to start in this experiment
Iterations_To_Run=$3		# how many iterations to run per client

Start_Client_Script="start_client.sh"
LOGDIR=/mnt/hgfs/emctest/work/logs		# this must match the valuein start_client.sh
ERROR_LOGFILE=${LOGDIR}/out_${Experiment_ID}_error.log  # this must also match client.sh

Client_Number=1

if [ ! -d "$LOGDIR" ]; then
	echo "Could not access logdir - exiting"
	exit
fi

echo "Experiment ${Experiment_ID}:${Clients_To_Start}:${Iterations_To_Run} started at ${exp_time_start_formatted}"

while [ $Client_Number -le $Clients_To_Start ]
do
	sh ${Start_Client_Script} ${Experiment_ID} ${Client_Number} ${Iterations_To_Run} &
	Client_Number=`expr $Client_Number + 1 `
done


Clients_Running=2 # just to get the first iteration
while [ $Clients_Running -gt 0 ]
do
	sleep 2
	Clients_Running=`ps -ef | grep "${Start_Client_Script} ${Experiment_ID}" | grep -v grep | wc -l | awk {'print $1'}`
done

Total_Time=0
Client_Number=1
while [ $Client_Number -le $Clients_To_Start ]
do
	New_Time=`cat ${LOGDIR}/*_${Experiment_ID}_${Client_Number}_result.log`
	Total_Time=$(echo ${Total_Time} + ${New_Time} | bc)
	Client_Number=`expr $Client_Number + 1 `

done



# sum entries in working_log and put in result_log
#awk '{ sum += $1 } END { printf "%f\n", sum }' ${WORKING_LOG} > ${RESULT_LOG} 




# added some calculations - note bc does integer arithimetic 
Total_Time_In_Seconds=$(echo $Total_Time/1000 | bc)
Total_Time_In_Minutes=$(echo $Total_Time_In_Seconds/60 | bc)
Total_Time_In_Minutes_Remaining_Seconds=$(echo $Total_Time_In_Seconds % 60 | bc)
Total_Time_In_Hours=$(echo $Total_Time_In_Minutes/60 | bc)

exp_time_stop_formatted=$(date)
exp_time_stop_epochtime=$(date +%s)

echo "Experiment ${Experiment_ID}:${Clients_To_Start}:${Iterations_To_Run} ended at ${exp_time_stop_formatted}"
exp_time=$(echo ${exp_time_stop_epochtime} - ${exp_time_start_epochtime} | bc)

ERROR_REPORT=""
if [ -s $ERROR_LOGFILE ]; then 
	ERROR_REPORT="errors reported!  see ${ERROR_LOGFILE} for more info"
	echo "${exp_time_stop_formatted}: Detected non empty errors file" >> "$ERROR_LOGFILE"	
fi

FINAL_REPORT="Experiment ${Experiment_ID}:${Clients_To_Start}:${Iterations_To_Run} returns ${Total_Time_In_Seconds} seconds (${Total_Time_In_Minutes}:${Total_Time_In_Minutes_Remaining_Seconds})"
FINAL_REPORT2="Calendar time (not client wait time) taken: ${exp_time}  (${exp_time_start_formatted} -> ${exp_time_stop_formatted})"
echo ${FINAL_REPORT} > "${LOGDIR}/${Experiment_ID}.txt"
echo ${FINAL_REPORT2} >> "${LOGDIR}/${Experiment_ID}.txt"

echo ${FINAL_REPORT}
echo ${FINAL_REPORT2}

if [ "$ERROR_REPORT" ]; then
	echo ${ERROR_REPORT} >> "${LOGDIR}/${Experiment_ID}.txt"
	echo ${ERROR_REPORT}
fi
