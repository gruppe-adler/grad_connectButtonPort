#!/usr/bin/env bash

releaseDir=$1
port=$2
versionfile="${releaseDir}/addons/connectButtonPort/definePort.hpp"

echo "updating port to $port"
sed -i -e "s/define CONNECTBUTTONPORT.*/define CONNECTBUTTONPORT $port/" "${versionfile}"
