#!/usr/bin/env bash
### CONFIG ###
zip_path="zip.exe"
modname="@grad_connectButtonPort"
pboprefix="grad_"
componentname="connectButtonPort"
ports=(2302 2402 2502 2602 2702 2802 2902)

### AS AS USER, DONT EDIT BELOW THIS LINE ###

toolsDir=$(realpath "$(pwd)/$(dirname $0)")
baseDir=`dirname "${toolsDir}"`
platform=`uname`

if [[ ${platform} == "Linux" ]]; then
	armakePath="${toolsDir}/armake"
else
	armakePath="${toolsDir}/armake_w64.exe"
fi

if [[ ! -f ${armakePath} ]]; then
	echo "warning: armake binary not found at ${armakePath}, will not build pbo files!"
	exit 1
fi


zip_folder() {
    if [[ ${platform} == "Linux" ]]; then
    	tar -czf "$baseDir/release/${modNameWithPort}.tar.gz" -C "${baseDir}/release" ${modNameWithPort}
    	(cd ${baseDir}/release; zip -r "${modNameWithPort}.zip" ${modNameWithPort})
    else
    	pushd "${baseDir}/release"
    		# check zipper
    		if [ ! -e "${zip_path}" ]; then
    			zip_path="${toolsDir}/zip.exe"
    		fi

    		if [ ! -e "${zip_path}" ]; then
    			echo "warning: zip.exe not found, will not zip mod release!"
    			exit 1
    		fi

    		"${zip_path}" -r "$baseDir/release/${modNameWithPort}.zip" "${modNameWithPort}"
    	popd
    fi
}

build_pbo() {
    mkdir -p "${releaseDir}"
    cp -r "${baseDir}/addons" "${releaseDir}/"
    cp "${baseDir}"/*.paa "${baseDir}"/*.cpp "${baseDir}/README.md" "${releaseDir}/"

    bash "${toolsDir}/update-portDefine.sh" "${releaseDir}" $1

    "${armakePath}" build -f -p "${releaseDir}/addons/connectButtonPort" "${releaseDir}/addons/${pboprefix}${componentname}.pbo"

    if [[ ! -f "${releaseDir}/addons/${pboprefix}${componentname}.pbo" ]]; then
		echo "failed"
		exit 2
	fi

    rm -r "${releaseDir}/addons/connectButtonPort"
}


for i in "${ports[@]}"
do
    modNameWithPort="${modname}$i"
    releaseDir="${baseDir}/release/${modNameWithPort}"

    build_pbo $i
    zip_folder
done
