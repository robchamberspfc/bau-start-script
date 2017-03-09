#!/usr/bin/env bash

DP_COMPOSE_DIR=$1
WHITE='\033[01;37m'
NC='\033[0m' # No Color

log_debug() {
	echo -e "    ${WHITE}# $1${NC}"
}

log_debug "DP_COMPOSE_DIR=$DP_COMPOSE_DIR"

dockerReady=$(docker ps | grep -c "CONTAINER ID")

if [ "$dockerReady" -le 1 ]; then  

	log_debug "Waiting for docker to complete start up."

	while [ true ]
	do
		temp=$(docker ps | grep -c "CONTAINER ID")
		if [ "$temp" -ge 1 ]; then
			log_debug "Docker start up complete"
			break
		else
			sleep 2
		fi
	done
fi

composeContainers=$(docker ps | grep -c "dpcompose_")

if [ "$composeContainers" -ne 3 ]; then
	log_debug "dpcompose containers are not running. Attempting to start dp-compose..."
	cd "$DP_COMPOSE_DIR"
	pwd
	./run.sh
else
	log_debug "dpcompose containers are running. No action required"
fi