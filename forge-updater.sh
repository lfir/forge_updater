#!/bin/bash
#Script to check for new versions and update Forge for linux by Asta1986.

##Auxiliary functions.
#The first time the updater is run register the local game directory.
registerLocalDir() {
	if ! [[ -f "${HOME}/.forge-updater" ]] ; then
		read -rp 'Enter the full path to the Forge directory: ' orgDir
		echo "$orgDir" | sed 's/\/$//' > "${HOME}/.forge-updater"
	fi
	ldd=$(xdg-user-dir DOWNLOAD)/Forge
	localDir=$(cat "${HOME}/.forge-updater")
}

#Erase auxiliary files.
cleanUp() {
	rm -rf '/tmp/fv' '/tmp/fvl'
}

#Replace current game folder with the one downloaded.
replaceIfAccepted() {
	if [[ -n "$1" ]] ; then
		cp "${localDir}/forge.profile.properties" "$ldd" &> '/dev/null'
		rm -r "$localDir"
		mv "$ldd" "$localDir"
		echo 'All done.'
	else
		echo "Old version not replaced. The new version can be found in $ldd."
	fi
}

#Ask the user if he wants to replace the local version with the one downloaded.
beginDownload() {
	if [[ -n "$1" ]] ; then
		downloadUrl="${baseUrl}/${latestVersion}/forge-gui-desktop-${latestVersion}.tar.bz2"
		mkdir -p "$ldd"
		echo 'Downloading new version. Please wait.'
		wget --show-progress -qO - "$downloadUrl" | tar xjC "$ldd" -f - && \
		read -rp 'Replace local version with new version? [Y/N]: ' answer
		replaceIfAccepted "$(echo "$answer" | grep -oi y)"
	else
		echo 'Goodbye.'
	fi
}

#Check whether the local version is older than the available one.
#Ask the user if he wants to download the new version now.
forge-updater() {
	registerLocalDir
	#Get the latest available version from the forge download site.
	baseUrl='https://releases.cardforge.org/forge/forge-gui-desktop'
	wget -qO '/tmp/fv' "$baseUrl"
	grep -Po '(?<==")\d+.\d+.\d+(?=/")' '/tmp/fv' | tail -1 > '/tmp/fvl'
	latestVersion=$(cat '/tmp/fvl')
	#Make an int for each version to compare them.
	localVInt=$(grep -Po '\-\K\d+.\d.+\d+' "$localDir/forge.sh" | sed 's/\.//g')
	latestVInt=$(sed 's/\.//g' '/tmp/fvl')
	#Also check using only the first and second digits since sometimes Forge release versions 
	#don't have the same number of digits (i. e. 1.5.65 and 1.6.0).
	localMainVInt=$(echo "$localVInt" | grep -Po '^[0-9]{2}')
	latestMainVInt=$(echo "$latestVInt" | grep -Po '^[0-9]{2}')
	if (( localMainVInt < latestMainVInt )) || (( localVInt < latestVInt )) ; then
		read -rp 'New version available. Download it now? [Y/N]: ' answer
		beginDownload "$(echo "$answer" | grep -oi y)"
	else
		echo 'Forge is up to date.'
	fi
	cleanUp
}
##

#Allow sourcing the script.
if [[ ${BASH_SOURCE[0]} = "$0" ]] ; then
	forge-updater
fi

