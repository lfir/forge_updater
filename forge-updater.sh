#!/bin/bash
#Script to check for new versions and update Forge for linux by Asta1986.

replaceIfAccepted() {
if [[ -n "$1" ]] ; then
	cp $localDir/forge.profile.properties ~/Downloads/Forge &> /dev/null
	rm -r $localDir
	mv ~/Downloads/Forge $localDir
	echo "All done."
else
	echo "Old version not replaced. The new version can be found in '~/Downloads/Forge'."
fi
}

#The first time the updater is run register the local game directory.
if ! [[ -f ~/.forge-updater ]] ; then
read -p "Enter the full path to the Forge directory: " orgDir
echo $orgDir > ~/.forge-updater
fi

#Get the latest available version from the forge download site.
wget -qO /tmp/fv http://www.cardforge.link/releases/forge/forge-gui-desktop
grep -Po '(?<==")\d+.\d+.\d+(?=/")' /tmp/fv | tail -1 > /tmp/fvl

localDir=$(cat ~/.forge-updater)
baseUrl="http://www.cardforge.link/releases/forge/forge-gui-desktop"
latestVersion=$(cat /tmp/fvl)
localVInt=$(grep -Po 'ver \K\d+.\d.+\d+$' $localDir/CHANGES.txt | sed 's/\.//g')
latestVInt=$(sed 's/\.//g' /tmp/fvl)

#Check whether the local version is older than the available one.
#Ask the user if he wants to replace the local version with the one downloaded.
if (( localVInt < latestVInt )) ; then
	downloadUrl="$baseUrl/$latestVersion/forge-gui-desktop-$latestVersion.tar.bz2"
	mkdir -p ~/Downloads/Forge
	echo "Downloading new version. Please wait."
	wget -qO - $downloadUrl | tar xjC ~/Downloads/Forge -f - && \
	read -p "Replace local version with new version? [Y/N]: " answer
	replaceIfAccepted $(echo $answer | grep -oi y)
else
	echo "Forge is up to date."
fi

#Erase auxiliary files.
rm /tmp/fv /tmp/fvl
