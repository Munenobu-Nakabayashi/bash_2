#!/bin/bash

###  declare an array
declare -a folderArray
folderArray=()

### declare Variants
# LOGDIR="/usr/dfws/etc/Akamai_Programs/1170772/log"	#Eternally. this mesns that this process runs in "honchan" env.
LOGDIR="/home/loan01/LOG/AKAMAI_H031S3482"	# Temporally. tihis means that this process runs in "kensho" env. 
LOGKANGEN_DIR="logkangen"
WORKFILE1="alllog_win_akamai"	# CRLF kaigyou
WORKFILE2="alllog_akamai"		# LF kaigyou

WORKFILEA=workfilea.txt		### YYYYMM
WORKFILEB=workfileb.txt		### YYYY
WORKFILEC=workfilec.txt		### MM

### get folder names.
WEEKDIR=""
WEEKDIR1=""	# no.4 last folder
WEEKDIR2=""	# no.3 last folder
WEEKDIR3=""	# no.2 last folder
WEEKDIR4=""	# no.1 last folder
WEEKDIR5=""	
ZIPFILE=""
PID=$$		# this shell's pid (to use (a) log records (b) nice and renice)
### get last month
THISMONTH=`date +'%Y%m'`
LASTMONTH=""
WORK_YEAR=0
WORK_MONTH=0
ECNT=""		# Youso Su in Japanese
RET=0

HOSTNAME=`hostname`
WHOAMI=`whoami`

TODAY=`date +'%Y%m%d'`

### Get (a) 4 weeks Summary File Path and (b) Last Month Summary File Path

function concat_4_weeks_files() {
	
	append_log_records "start concatting zip files (not to unzip) "
	cat /dev/null > ${LOGDIR}/${LOGKANGEN_DIR}/${WORKFILE1}_joint4weeks.txt

	if [ ${#WEEKDIR1} -gt 0 ]; then	# get the length of string. if 0 then ""
		if [ -d ${LOGDIR}/${LOGKANGEN_DIR}/${WEEKDIR1} ]; then	# if the folder exists
			append_log_records "concat ${WEEKDIR1}"
			unzip_c_and_stdout ${LOGDIR}/${LOGKANGEN_DIR}/${WEEKDIR1}
		fi
	else
		append_log_records "${WEEKDIR1} do not have strings,  that means bug !"
	fi
	if [ ${#WEEKDIR2} -gt 0 ]; then	# get the length of string. if 0 then ""
		if [ -d ${LOGDIR}/${LOGKANGEN_DIR}/${WEEKDIR2} ]; then	# if the folder exists
			append_log_records "concat ${WEEKDIR2}"
			unzip_c_and_stdout ${LOGDIR}/${LOGKANGEN_DIR}/${WEEKDIR2}
		fi
	else
		append_log_records "${WEEKDIR2} do not have strings,  that means bug !"
	fi
	if [ ${#WEEKDIR3} -gt 0 ]; then	# get the length of string. if 0 then ""
		if [ -d ${LOGDIR}/${LOGKANGEN_DIR}/${WEEKDIR3} ]; then	# if the folder exists 
			append_log_records "concat ${WEEKDIR3}"
			unzip_c_and_stdout ${LOGDIR}/${LOGKANGEN_DIR}/${WEEKDIR3}
		fi
	else
		append_log_records "${WEEKDIR3} do not have strings,  that means bug !"
	fi
	if [ ${#WEEKDIR4} -gt 0 ]; then	# get the length of string. if 0 then ""
		if [ -d ${LOGDIR}/${LOGKANGEN_DIR}/${WEEKDIR4} ]; then	# if the folder exists 
			append_log_records "concat ${WEEKDIR4}"
			unzip_c_and_stdout ${LOGDIR}/${LOGKANGEN_DIR}/${WEEKDIR4}
		fi
	else
		append_log_records "${WEEKDIR4} do not have strings,  that means bug !"
	fi
	if [ ${#WEEKDIR5} -gt 0 ]; then	# get the length of string. if 0 then ""
		append_log_records "why does {WEEKDIR5}  have strings ?,  that means bug !"
		if [ -d ${LOGDIR}/${LOGKANGEN_DIR}/${WEEKDIR5} ]; then	# if the folder exists 
			append_log_records "concat ${WEEKDIR5}"
			unzip_c_and_stdout ${LOGDIR}/${LOGKANGEN_DIR}/${WEEKDIR5}
		fi
	else
		append_log_records "${WEEKDIR5} does not have strings. all right"
	fi
	append_log_records "end concatting zip files (not to unzip) "

}

function unzip_c_and_stdout() {

	WEEKDIR=$1
	ANYFILES=""
	pushd ${WEEKDIR}	# this variant have a absolute folder path
	for ANYFILES in *.zip
	do
  		if [[ ${ANYFILES} == *.zip* ]]; then
			echo "unzip" ${ANYFILES}
			###unzip -c ${ANYFILES} | cat >> ${LOGDIR}/${LOGKANGEN_DIR}/${WORKFILE1}_joint4weeks.txt
			unzip -p ${ANYFILES} >> ${LOGDIR}/${LOGKANGEN_DIR}/${WORKFILE1}_joint4weeks.txt
			append_log_records "${ANYFILES} is concated"
		fi
	done
	popd

}

function change_crlf_for_lf() {

	append_log_records "start changing crlf for lf"
        cat /dev/null > ${LOGDIR}/${LOGKANGEN_DIR}/${WORKFILE2}_joint4weeks.txt
	# \r\n ---> \n ( attension ! ${WORKFILE1} ---> ${WORKFILE2} )
        cat ${LOGDIR}/${LOGKANGEN_DIR}/${WORKFILE1}_joint4weeks.txt | sed -e  's/\r//g' > ${LOGDIR}/${LOGKANGEN_DIR}/${WORKFILE2}_joint4weeks.txt
	# delete CRLF  "chukan" file.
	rm -f ${LOGDIR}/${LOGKANGEN_DIR}/${WORKFILE1}_joint4weeks.txt
	append_log_records "delete ${WORKFILE1}_joint4weeks.txt chukan file"
	append_log_records "finish changing crlf for lf"

}

function change_lf_for_crlf() {

        append_log_records "start changing lf for crlf"
        cat /dev/null > ${LOGDIR}/${LOGKANGEN_DIR}/${WORKFILE2}_WIN_sorted_access_number_${LASTMONTH}.txt
        
	# \r\n ---> \n ( attension ! ${WORKFILE1} ---> ${WORKFILE2} )
        ### cat ${LOGDIR}/${LOGKANGEN_DIR}/${WORKFILE2}_order_by_desc.txt | sed -e  's/\n/\r\n/g' > ${LOGDIR}/${LOGKANGEN_DIR}/${WORKFILE2}_WIN_sorted_access_number_${LASTMONTH}.txt
	GYOSU=0
	GYOSU=`wc -l ${LOGDIR}/${LOGKANGEN_DIR}/${WORKFILE2}_order_by_desc.txt`
        append_log_records "origin lf file have ${GYOSU} lines"

        cat ${LOGDIR}/${LOGKANGEN_DIR}/${WORKFILE2}_order_by_desc.txt | sed -e  's/$/\r/g' > ${LOGDIR}/${LOGKANGEN_DIR}/${WORKFILE2}_WIN_sorted_access_number_${LASTMONTH}.txt
        append_log_records "finish changing lf for crlf"
	GYOSU=0
	GYOSU=`wc -l ${LOGDIR}/${LOGKANGEN_DIR}/${WORKFILE2}_WIN_sorted_access_number_${LASTMONTH}.txt`
        append_log_records "redirect crlf file have ${GYOSU} lines"
        
	# delete LF "order_by_desc" file.
        rm -f ${LOGDIR}/${LOGKANGEN_DIR}/${WORKFILE2}_order_by_desc.txt
	append_log_records "delete ${WORKFILE2}_joint4weeks.txt chukan file"

}

function classify_by_folders() {

	# Files
  	ORG_FILE=${LOGDIR}/${LOGKANGEN_DIR}/${WORKFILE2}_joint4weeks.txt	# LF "kaigyou" file
  	SORT_FILE=${LOGDIR}/${LOGKANGEN_DIR}/${WORKFILE2}_sorted.txt		# 1st sorted file
	RE_SORT_FILE=${LOGDIR}/${LOGKANGEN_DIR}/${WORKFILE2}_re_sorted.txt	# 2nd sorted file
  	BY_FOLDER_PATH_FILE=${LOGDIR}/${LOGKANGEN_DIR}/${WORKFILE2}_by_folder_path.txt	# 3rd  "chukan" file. but we can not remove
  	ORDER_BY_DESC_FILE=${LOGDIR}/${LOGKANGEN_DIR}/${WORKFILE2}_order_by_desc.txt	# last "seikabuchu" file, means "koujun" sorted
  	ONE_LINE_FILE=${LOGDIR}/${LOGKANGEN_DIR}/one_line_file.txt
	UNEXPANDED_FILE=${LOGDIR}/${LOGKANGEN_DIR}/${WORKFILE2}_unexpanded.txt	# change one tab for one space

	# Variants 
 	FOLDER_PATH=""        		# Folder Path
  	SAVED_FOLDER_PATH=""  		# Folder Path (Use to Detect "Control Break")
  	SUM=0                 		# Sum Up by Folder Path
  	SLUSH="/"
	gyosu=0
	lcnt=0
	shou=0
	reminder=0			# "amari" in Japanese

  	# Generate "chukan" Files
	append_log_records "start to generate the 7 work files"
	cat /dev/null > ${SORT_FILE}
	cat /dev/null > ${RE_SORT_FILE}
	cat /dev/null > ${BY_FOLDER_PATH_FILE}
	cat /dev/null > ${ORDER_BY_DESC_FILE}
  	cat /dev/null > ${ONE_LINE_FILE} 
  	cat /dev/null > ${UNEXPANDED_FILE}	# add new 2024.12.12 
	append_log_records "finish to generate the 7 work files"

	append_log_records "start the 1st sort"
  	sort ${ORG_FILE} > ${SORT_FILE}   # Sorted in ascending order ... now, "champon" status about the domains (e.q. rbdoc-ssl, kmdoc-ssl ... and more)
	append_log_records "finish the 1st sort"
	gyosu=`wc -l ${SORT_FILE}`
	###gyosu=$(( wc -l ${SORT_FILE} ))
	append_log_records "gyosu in 1st sorted file is ${gyosu}"	

	append_log_records "start reading the 1st sort file"
  	while read line1
  	do

      		echo ${line1} > "${ONE_LINE_FILE}"

      		folderpath=$(cut -d " " -f 1 "${ONE_LINE_FILE}" | tee /dev/tty)     # Nothing to do with this line ... But Get Args
		cnt=0	# zero reset the variant "cnt"
      		cnt=$(awk '{ print $2 }' "${ONE_LINE_FILE}" | tee /dev/tty)         # e.q. RBdocs-ssl/hojin/b_direct/kitei/kitei.html "92")
      		if grep -q "?" ${ONE_LINE_FILE} > /dev/null; then                   # Check the "?" string, means the "Query String"
          		folderpath=$(cut -d "?" -f 1 "${ONE_LINE_FILE}" | tee /dev/tty) # Cut Off the "Query String". The query string means Nothing. 
          		echo ${folderpath} > "${ONE_LINE_FILE}"                         # And OverWrite the one line file
      		fi

		FOLDER_PATH=""
      		s_cnt=$(cat ${ONE_LINE_FILE} | grep -o "/" | wc -l | tee /dev/tty)  # Count the slushes "/" (At least, One. e.q. RBdocs-ssl/ 165389)
      		for ((i=1; i<=${s_cnt}; i++))
      		### for i in `seq 1 ${s_cnt}`
      		do
          		FOLDER_PATH=${FOLDER_PATH}$(cut -d "/" -f ${i} ${ONE_LINE_FILE})${SLUSH}        # Add a String "Backwards" (Not OverWrite!)
      		done

      		# Check "Control Break" Or Not
     		if [ "${FOLDER_PATH}" != "${SAVED_FOLDER_PATH}" ]; then                 		# "Control Break" Pattern
			### if [ "${SAVED_FOLDER_PATH}" != "" ]; then	# update 2014.12.10
			if [ ${#SAVED_FOLDER_PATH} -gt 0 ]; then	# update 2024.12.10 		"SAVED_FOLDER_PATH" contains strings, not zero length
          			echo ${SAVED_FOLDER_PATH}" "${SUM} >> ${BY_FOLDER_PATH_FILE}    	# Standard Out To the "akamai_by_folder_path.txt" File
			fi
          		# Change The Folder Path
          		SAVED_FOLDER_PATH=""
          		SAVED_FOLDER_PATH=${FOLDER_PATH}
          		SUM=0
          		SUM=${cnt}
      		else  # Same Pattern (Not Control Break)
          		### SUM=$((${SUM}+${cnt})) 	# UPDATE 2024.12.09	# Count Up in the same folder path
			SUM=`expr ${SUM} + ${cnt}`      # UPDATE 2024.12.09     # Count Up in the same folder path
      		fi
	
      		cat /dev/null > ${ONE_LINE_FILE}                                    	# Initialize the one line work file
		lcnt=$(( ${lcnt} + 1 ))
		reminder=$(( ${lcnt} % 5000 ))
		if [[ ${reminder} == 0 ]]; then
			append_log_records "${lcnt} / ${gyosu} is digensted in the 1st sort file"  
		fi

  	done < "${SORT_FILE}"

        echo ${SAVED_FOLDER_PATH}" "${SUM} >> ${BY_FOLDER_PATH_FILE}		# Standard Out at last
	append		# add new 2014.12.12 end_log_records "${lcnt} / ${gyosu} is digensted in the 1st sort file"
	append_log_records "finish reading the 1st sort file"

	#--------------------
	PID=$$			# add new 2024.12.10
	renice_this_pid		# renice the nice value of this pid
	#--------------------

	append_log_records "start the 2nd sort"
  	sort ${BY_FOLDER_PATH_FILE} > ${RE_SORT_FILE}	# Sorted in ascending order ...
	append_log_records "finish the 2nd sort"

	FOLDER_PATH=""
	SAVED_FOLDER_PATH=""
	
  	cat /dev/null > ${BY_FOLDER_PATH_FILE}		# Initialize the result file

	gyosu=0
	gyosu=`wc -l ${RE_SORT_FILE}`
	lcnt=0
	shou=0
	reminder=0
	append_log_records "gyosu in 2nd sorted file is ${gyosu}"	

	append_log_records "start reading the 2nd sort file"
  	while read line2
	do

      		echo ${line2} > "${ONE_LINE_FILE}"

		FOLDER_PATH=$(cut -d " " -f 1 "${ONE_LINE_FILE}" | tee /dev/tty)    # Nothing to do with this line ... But Get Args
		cnt=0	# zero reset the variant "cnt"
		cnt=$(awk '{ print $2 }' "${ONE_LINE_FILE}" | tee /dev/tty)         # e.q. RBdocs-ssl/hojin/b_direct/kitei/kitei.html "92")

     		if [ "${FOLDER_PATH}" != "${SAVED_FOLDER_PATH}" ]; then                 	# "Control Break" Pattern
			### if [ "${SAVED_FOLDER_PATH}" != "" ]; then	# update 2024.12.10
			if [ ${#SAVED_FOLDER_PATH} -gt 0 ]; then	# update 2024.12.10 "SAVED_FOLDER_PATH" contains strings, not zero length
				echo ${SAVED_FOLDER_PATH}" "${SUM} >> ${BY_FOLDER_PATH_FILE} 	# Standard Out To the "akamai_by_folder_path.txt" File
			fi
			# Change The Saved Folder Path
			SAVED_FOLDER_PATH=""
			SAVED_FOLDER_PATH=${FOLDER_PATH}
			SUM=0
			SUM=${cnt}
		else  # Same Pattern (Not Control Break)
			### SUM=$((${SUM}+${cnt})) 	# UPDATE 2024.12.09	# Count Up in the same folder path
			SUM=`expr ${SUM} + ${cnt}`      # UPDATE 2024.12.09     # Count Up in the same folder path
		fi
			
     		cat /dev/null > ${ONE_LINE_FILE}                                    	# Initialize the one line work file
		lcnt=$(( ${lcnt} + 1 ))
		reminder=$(( ${lcnt} % 5000 ))
		if [[ ${reminder} == 0 ]]; then		# this means "amari = zero"
			append_log_records "${lcnt} / ${gyosu} is digensted in the 2nd sort file"
		fi

	done < "${RE_SORT_FILE}"

        echo ${SAVED_FOLDER_PATH}" "${SUM} >> ${BY_FOLDER_PATH_FILE}			# Standard Out at last
	append_log_records "${lcnt} / ${gyosu} is digensted in the 2nd sort file"
	append_log_records "finish reading the 2nd sort file"
	GYOSU=0
	GYOSU=`wc -l ${BY_FOLDER_PATH_FILE}`
	append_log_records "order by folder path file have ${GYOSU} lines"

	# --- 2024.12.12 update
	append_log_records "start to replace one space  to one tab from the 2nd shukei file to unexpanded file"
	tr ' ' '\t' < ${BY_FOLDER_PATH_FILE} > ${UNEXPANDED_FILE}
	append_log_records "finish to replace one space to one tab from the 2nd shukei file to unexpanded file"
	GYOSU=0
	GYOSU=`wc -l ${UNEXPANDED_FILE}`
	append_log_records "unexpanded file have ${GYOSU} lines"
		
	# --- 2024.12.12 update

	append_log_records "start the 3rd sort order by kensu desc from the unexpanded file to 3rd desc sort file"
	### sort -r -n -k 2,2 -t "	" ${UNEXPANDED_FILE} > ${ORDER_BY_DESC_FILE}  	# Desc by "kensu"
	sort -r -nk 2,2 -t$'\t' ${UNEXPANDED_FILE} > ${ORDER_BY_DESC_FILE}  	# Desc by "kensu"
	append_log_records "finish the 3nd sort order by kensu desc from the unexpanded file to 3rd desc sort file"
	GYOSU=0
	GYOSU=`wc -l ${ORDER_BY_DESC_FILE}`
	append_log_records "desc sorted file have ${GYOSU} lines"
	
  	
	# Remove the "Chukan" Files
	append_log_records "start to delete 6 work files (excludeing ORDER_BY_DESC_FILE)"
	rm -f ${ORG_FILE}
  	rm -f ${SORT_FILE}
	rm -f ${BY_FOLDER_PATH_FILE}	# add 2024.12.16 (bug)
	rm -f ${RE_SORT_FILE}
	rm -f ${UNEXPANDED_FILE}	# add new 2024.12.12 
  	rm -f ${ONE_LINE_FILE}
	append_log_records "finish to delete 6 work files"

}

function save_result_file() {

	append_log_records "start to zip the results file"
	# create a new directory to save the result file
	pushd ${LOGDIR}/${LOGKANGEN_DIR}
	if [ -d ./TOP250-${LASTMONTH} ]; then
		mv -f ./TOP250-${LASTMONTH} ./TOP250-${LASTMONTH}.old
		append_log_records "oops, TOP250-${LASTMONTH} folder exist...rename TOP250-${LASTMONTH}.old"
	fi 
	mkdir TOP250-${LASTMONTH}
	GYOSU=0
	GYOSU=`wc -l ./${WORKFILE2}_WIN_sorted_access_number_${LASTMONTH}.txt`
        append_log_records "now, ${WORKFILE2}_WIN_sorted_access_number_${LASTMONTH} have ${GYOSU} lines"
	
	append_log_records "make a new folder which is named TOP250-${LASTMONTH}"
	mv ${WORKFILE2}_WIN_sorted_access_number_${LASTMONTH}.txt TOP250-${LASTMONTH}
	### cp ${WORKFILE2}_WIN_sorted_access_number_${LASTMONTH}.txt TOP250-${LASTMONTH}
	# arcive the result file
	GYOSU=0
	GYOSU=`wc -l ./TOP250-${LASTMONTH}/${WORKFILE2}_WIN_sorted_access_number_${LASTMONTH}.txt`
        append_log_records "by the way, ./TOP250-${LASTMONTH}/${WORKFILE2}_WIN_sorted_access_number_${LASTMONTH} have ${GYOSU} lines"

	pushd ./TOP250-${LASTMONTH}
	zip ${WORKFILE2}_WIN_sorted_access_number_${LASTMONTH}.zip ${WORKFILE2}_WIN_sorted_access_number_${LASTMONTH}.txt	
	### zip ./${WORKFILE2}_WIN_sorted_access_number_${LASTMONTH}.zip ./${WORKFILE2}_WIN_sorted_access_number_${LASTMONTH}.txt	# <--- BUG !!
	### popd	# <--- BUG !!
	append_log_records "finish to zip the results file"
	append_log_records "start to delete the results file"		# add new 2024.12.12 start
	rm -f ${WORKFILE2}_WIN_sorted_access_number_${LASTMONTH}.txt
	### rm -f ./${WORKFILE2}_WIN_sorted_access_number_${LASTMONTH}.txt	# <--- BUG !!
	append_log_records "finish to delete the results file"		# add new 2014.12.12 end
	popd
	popd

}

function append_log_records() {

	messages=""
	messages=$1
	### echo [$(date +"%Y-%m-%d %H:%M:%S")+09:00] pid:${PID} ${WHOAMI}@${HOSTNAME}: [${messages}] >> ${LOGDIR}/order_by_kensu_messages_${TODAY}.log
	# UPDATE 2024.12.09
	echo [$(date +"%Y-%m-%d %H:%M:%S") +09:00] pid:${PID} ${WHOAMI}@${HOSTNAME}: [${messages}] >> ${LOGDIR}/${LOGKANGEN_DIR}/order_by_kensu_messages_${TODAY}.log
	# this command have the absolute ( means "ZETTAI" ) path

}

function generate_log_file() {

	if [ -f ${LOGDIR}/${LOGKANGEN_DIR}/order_by_kensu_messages_${TODAY}.log ]; then
		mv ${LOGDIR}/${LOGKANGEN_DIR}/order_by_kensu_messages_${TODAY}.log ${LOGDIR}/${LOGKANGEN_DIR}/order_by_kensu_messages_${TODAY}.log.old
	fi
	cat /dev/null > ${LOGDIR}/${LOGKANGEN_DIR}/order_by_kensu_messages_${TODAY}.log

}

function calc_last_month() {

	append_log_records "start to calc the last month"
	pushd ${LOGDIR}/${LOGKANGEN_DIR}
	cat /dev/null > ${WORKFILEA}
	cat /dev/null > ${WORKFILEB}
	cat /dev/null > ${WORKFILEC}
	
	echo ${THISMONTH} > ${WORKFILEA}
	cut -c 1-4 ${WORKFILEA} > ${WORKFILEB}
	WORK_YEAR=$( cat ${WORKFILEB} )
	cut -c 5-6 ${WORKFILEA} > ${WORKFILEC}
	WORK_MONTH=$( cat ${WORKFILEC})
	if [ ${WORK_MONTH} == "01"  ]; then
		WORK_YEAR=`expr ${WORK_YEAR} - 1`
		WORK_MONTH="12"	
	else
		WORK_MONTH=`expr ${WORK_MONTH} - 1`
	fi
	LASTMONTH=${WORK_YEAR}${WORK_MONTH} 	# add new 2024.12.09
	append_log_records "the last month is ${LASTMONTH}"

	rm -f ${WORKFILEA}		# delete work files
	rm -f ${WORKFILEB}
	rm -f ${WORKFILEC}

	popd
	append_log_records "end to calc the last month"
	
}

function get_all_folders() {

	append_log_records "start to get all folders and append to an array"
	pushd ${LOGDIR}/${LOGKANGEN_DIR}
	
	for anyfolders in 20*-20*
	do
		if [ ${#anyfolders} -eq 17 ]; then	# "17" means "yyyymmdd-yyyymmdd"
			### echo ${anyfolders}
			folderArray+=(${anyfolders})	# append to array
			append_log_records "detected folder name in ${LOGKANGEN_DIR} is ${anyfolders}"
		fi
	done 

	popd
	append_log_records "finish to get all folders"

}

function get_last_4_folders() {

	append_log_records "start to copy the 4 folder name from old date to new date"
	ECNT=$( expr ${#folderArray[@]} - 1 )	# get the Youso Su and zero origin

	for ((i=0; i<4; i++))	# from 0 to 3 ( means 4 elements )
	do
		j=`expr ${ECNT} - ${i}`		# at first, most biggest "Youso Su", next, the 2nd biggest, next, the 3rd biggestm\, next the 4th biggest "Youso Su"
		if [ ${i} -eq 0 ]; then
			WEEKDIR4=${folderArray[${j}]}
			append_log_records "no.4 folder name is ${WEEKDIR4}"
		elif [ ${i} -eq 1 ]; then
			WEEKDIR3=${folderArray[${j}]}
			append_log_records "no.3 folder name is ${WEEKDIR3}"
		elif [ ${i} -eq 2 ]; then
			WEEKDIR2=${folderArray[${j}]}
			append_log_records "no.2 folder name is ${WEEKDIR2}"
		elif [ ${i} -eq 3 ]; then
			WEEKDIR1=${folderArray[${j}]}
			append_log_records "no.1 folder name is ${WEEKDIR1}"
		fi

	done	
	
	append_log_records "finish to copy the 4 folder name from old date to new date"

}

function renice_this_pid() {

	MULTI_LINE_FILE=./multi_line_file.txt
	NICE_CHI=999	# set a "arienai" nice-chi
	cat /dev/null > ${MULTI_LINE_FILE}

	# get the before "nice chi"
	nice > ${MULTI_LINE_FILE}
	NICE_CHI=$( cat ${MULTI_LINE_FILE} )
	append_log_records "now, the nice value of this pid: ${PID} is ${NICE_CHI}"
	if [ ${NICE_CHI} -gt -20  ]; then
		sudo renice -20 ${PID}		# set the minimum nice-chi
		append_log_records "renice the nice value of this pid: ${PID}"
	else
		append_rog_records "why do we have nothing to do with the nice value of this pid: ${PID} ?"
	fi

	NICE_CHI=999	# set a "arienai" nice-chi
	cat /dev/null > ${MULTI_LINE_FILE}

	# get the after  "nice chi"
	nice > ${MULTI_LINE_FILE}
	NICE_CHI=$( cat ${MULTI_LINE_FILE} )
	append_log_records "now, the nice value of this pid: ${PID} is ${NICE_CHI}"

	rm ${MULTI_LINE_FILE}	# delete the work file

}

function save_log_file() {

	append_log_records "good luck, have a nice day !"
	pushd ${LOGDIR}/${LOGKANGEN_DIR}
	mv ./order_by_kensu_messages_${TODAY}.log ./TOP250-${LASTMONTH}
	popd

}

function main() {

	generate_log_file	# update 2024.12.16 
	append_log_records "this procesedure is started"

	renice_this_pid		# add new 2024.12.10	

	# 2024.12.06 add new --- start
	calc_last_month
	get_all_folders
	get_last_4_folders
	# 2024.12.06 add new --- end

	concat_4_weeks_files
	change_crlf_for_lf
        classify_by_folders	# This subroutine do not have arguments ! 
	change_lf_for_crlf	# add new 2024.12.09
	save_result_file 

        ###### archive_and_remove_files	# the zombie function 
	append_log_records "this procesedure is finished"
	save_log_file		# add new 2024.12.09
 
	exit
	
	terminate_this_process	# I know this process to be a zombie 

}

function terminate_this_process() {
	
	RET=999				# means "arienai" modori-chi
	PID=$$
	RET=`kill -0 ${PID}`
	if [[ ${RET} != 0 ]]; then
		kill -9 ${PID}		# kill 9, and terminate this process 
	fi

}

### auther: Shinji Kawasaki
main

### exit

