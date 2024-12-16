#!/bin/bash

RET=999                         # means "arienai" modori-chi
PID=$$
RET=`kill -0 ${PID}`
if [[ ${RET} != 0 ]]; then
	kill -9 ${PID}          # kill 9, and terminate the zombie process
fi
exit
