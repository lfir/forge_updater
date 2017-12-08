Script to check for new versions and update Forge for linux by Asta1986.
Check https://www.slightlymagic.net/forum/viewtopic.php?f=26&t=20278 for more info and development discussion.
Local profile file is kept to maintain customized paths.

USAGE: In a terminal run 'bash forge-updater.sh'. When prompted for the Forge directory, enter the full path.
Alternatively the script can be run:
- By sourcing it first: run source forge-updater.sh and then forge-updater command.
- Making the script executable: run chmod +x forge-updater.sh and then ./forge-updater.sh from the same directory.

IMPORTANT: If you choose to replace the local version with a new one, make sure your user and cache
directories are not within the game directory (this is the default scenario).
