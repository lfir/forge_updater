#!/bin/bash
#Script to check for new versions and update Forge for linux by Asta1986.

replaceIfAccepted() {
if [[ -n "$1" ]] ; then
	cp "${localDir}/forge.profile.properties" "$ldd" &> '/dev/null'
	rm -r "$localDir"
	mv "$ldd" "$localDir"
	echo "All done."
else
	echo "Old version not replaced. The new version can be found in $ldd."
fi
}

#The first time the updater is run register the local game directory.
if ! [[ -f "${HOME}/.forge-updater" ]] ; then
	read -rp "Enter the full path to the Forge directory: " orgDir
	echo "$orgDir" > "${HOME}/.forge-updater"
fi

#Get the latest available version from the forge download site.
baseUrl='https://releases.cardforge.org/forge/forge-gui-desktop'
wget -qO '/tmp/fv' "$baseUrl"
grep -Po '(?<==")\d+.\d+.\d+(?=/")' "/tmp/fv" | tail -1 > '/tmp/fvl'

ldd=$(xdg-user-dir DOWNLOAD)/Forge
localDir=$(cat "${HOME}/.forge-updater")
latestVersion=$(cat '/tmp/fvl')
localVInt=$(grep -Po '\-\K\d+.\d.+\d+' "$localDir/forge.sh" | sed 's/\.//g')
latestVInt=$(sed 's/\.//g' '/tmp/fvl')

#Check whether the local version is older than the available one.
#Ask the user if he wants to replace the local version with the one downloaded.
if (( localVInt < latestVInt )) ; then
	downloadUrl="${baseUrl}/${latestVersion}/forge-gui-desktop-${latestVersion}.tar.bz2"
	mkdir -p "$ldd"
	echo "Downloading new version. Please wait."
	wget -qO - "$downloadUrl" | tar xjC "$ldd" -f - && \
	read -rp "Replace local version with new version? [Y/N]: " answer
	replaceIfAccepted "$(echo "$answer" | grep -oi y)"
else
	echo "Forge is up to date."
fi

#Erase auxiliary files.
rm '/tmp/fv' '/tmp/fvl'
