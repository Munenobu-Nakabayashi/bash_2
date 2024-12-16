#!/bin/bash

declare -a folderArray
folderArray=()

THISMONTH=`date +'%Y%m'`
LASTMONTH=""
WORK_YEAR=0
WORK_MONTH=0
ECNT=""		# Youso Su in Japanese

LOGDIR="/home/loan01/LOG/AKAMAI_H031S3482"	# Temporally. 
LOGKANGEN_DIR="logkangen"
WEEKDIR1=""
WEEKDIR2=""
WEEKDIR3=""
WEEKDIR4=""
WORKFILE=workfile
WORKFILE2=workfile2	### YYYY
WORKFILE3=workfile3	### MM

function calc_last_month() {

	pushd ${LOGDIR}/${LOGKANGEN_DIR}
	cat /dev/null > ${WORKFILE}
	cat /dev/null > ${WORKFILE2}
	cat /dev/null > ${WORKFILE3}
	
	echo ${THISMONTH} > ${WORKFILE}
	cut -c 1-4 ${WORKFILE} > ${WORKFILE2}
	WORK_YEAR=$( cat ${WORKFILE2} )
	cut -c 5-6 ${WORKFILE} > ${WORKFILE3}
	WORK_MONTH=$( cat ${WORKFILE3})
	if [ ${WORK_MONTH} == "01"  ]; then
		WORK_YEAR=`expr ${WORK_YEAR} - 1`
		WORK_MONTH="12"	
	else
		WORK_MONTH=`expr ${WORK_MONTH} - 1`
	fi

	rm -f ${WORKFILE}		# delete work files
	rm -f ${WORKFILE2}
	rm -f ${WORKFILE3}

	popd
	
}

function get_all_folders() {

	pushd ${LOGDIR}/${LOGKANGEN_DIR}
	
	for anyfolders in 20*-20*
	do
		if [ ${#anyfolders} -eq 17 ]; then	# "17" means "yyyymmdd-yyyymmdd"
			### echo ${anyfolders}
			folderArray+=(${anyfolders})
		fi
	done 

	popd

}

function get_last_4_folders() {
	ECNT=$( expr ${#folderArray[@]} - 1 )	# get the Youso Su and zero origin
	for ((i=0; i<4; i++))
	do
		j=`expr ${ECNT} - ${i}`
		if [ ${i} -eq 0 ]; then
			WEEKDIR4=${folderArray[${j}]}
		elif [ ${i} -eq 1 ]; then
			WEEKDIR3=${folderArray[${j}]}
		elif [ ${i} -eq 2 ]; then
			WEEKDIR2=${folderArray[${j}]}
		elif [ ${i} -eq 3 ]; then
			WEEKDIR1=${folderArray[${j}]}
		fi

	done	
	
}

function main() {
	calc_last_month
	get_all_folders
	get_last_4_folders
}

main

exit
