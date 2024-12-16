#! /bin/bash

PID=$$
MULTI_LINE_FILE=./multi_line_file.txt
NICE_CHI=999
cat /dev/null > ${MULTI_LINE_FILE}

nice > ${MULTI_LINE_FILE}
NICE_CHI=$( cat ${MULTI_LINE_FILE} )
### echo ${NICE_CHI}
if [ ${NICE_CHI} -gt -20  ]; then
	sudo renice -20 ${PID}
fi
nice 

exit



