#!/bin/bash

# bash script mode
set -euo pipefail
# debug mode
# set -x

function __error_handing__(){
    local last_status_code=$1;
    local error_line_number=$2;
    echo 1>&2 "Error - exited with status $last_status_code at line $error_line_number";
}

trap  '__error_handing__ $? $LINENO' ERR

readonly docker_socket='/var/run/docker.sock';

# check for existence of needed commands
{
    which docker
    which jq
    which curl
    test -S $docker_socket
} > /dev/null 2>&1


docker_api_version=$(curl --silent --unix-socket $docker_socket http://localhost/version | jq -r '.ApiVersion')
echo "Docker API Version:"
echo $docker_api_version
echo "Docker ID:"
curl --silent --unix-socket $docker_socket http://localhost/v$docker_api_version/info | jq -r '.ID'
