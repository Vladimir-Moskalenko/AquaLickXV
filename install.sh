#!/bin/zsh
# AquaLickXV installer script
# v. 1.0.2 v3

# Versioning cheatsheet:
# - Major: significant changes; rewrites; adding a GUI
# - Semimajor: imortant changes, but not as major, such as improving support; more theming options
# - Minor: bugfixes, optimization, new features
# - Semiminor: wen u embarrassing bugs and dont want nobody to know


install() 
{
	echo Checking macOS version...

	if [[ $(sw_vers --productVersion) == *15.5* || $(sw_vers -productVersion) == *12.7.4* ]]
	then
	else
		echo "--------------------------------------------------------"
		echo " Support only for macOS 15.5 & 12.7.4! Attempting "
		echo " to install on other versions may break the OS!"
		echo "--------------------------------------------------------"
		echo Aborting...
		exit
	fi

	echo Checking SIP status...
	if [[ $(csrutil status) == *disabled* ]]
	then
	else
		echo "--------------------------------------------------------"
		echo " Please disable System Integrity Protection to continue"
		echo "--------------------------------------------------------"
		echo  
		echo Aborting...
		exit
	fi

	if [[ $(ls) == *bkup* ]]
	then
		echo Existing backup detected, skipping .car file backup...
	else
		echo Backing up current .car files...
		mkdir bkup
		cp -r /System/Library/CoreServices/SystemAppearance.bundle/Contents/Resources/ bkup
	fi
	
	mountExit="$(mount)"
	diskID="${mountExit:0:12}"

	echo Mounting root volume as r/w...
	mkdir ~/lvmnt
	sudo mount -o nobrowse -t apfs $diskID ~/lvmnt

	echo "Copying files..."
	echo "Copying Aqua.car"
	sudo cp Aqua.car ~/lvmnt/System/Library/CoreServices/SystemAppearance.bundle/Contents/Resources/
	echo "Copying DarkAqua.car"
	sudo cp DarkAqua.car ~/lvmnt/System/Library/CoreServices/SystemAppearance.bundle/Contents/Resources/
	echo "Copying VibrantLight.car"
	sudo cp VibrantLight.car ~/lvmnt/System/Library/CoreServices/SystemAppearance.bundle/Contents/Resources/
	echo "Copying VibrantDark.car"
	sudo cp VibrantDark.car ~/lvmnt/System/Library/CoreServices/SystemAppearance.bundle/Contents/Resources/

	echo Creating bootable APFS snapshot with the applied changes..
	if [[ $(uname -p) == *i386* || $(uname -p) == *x86_64* ]]
	then
		echo Using command for intel Macs...
		sudo bless --mount ~/lvmnt --bootefi --create-snapshot
	else
		echo Using command for Apple Silicon Macs...
		sudo bless --mount "~/lvmnt/System/Library/CoreServices/" --setBoot --create-snapshot
	fi
	echo Install finished! Reboot your computer to apply the changes.
}

installTest() 
{
	echo "Ignoring macOS Version check. "

	echo "--------------------------------------------------------"
	echo " If you're not on 15.5 or 12.7.4, there's a high chance "
	echo " your OS will break! In that scenario, please read "
	echo " AquaLickXV/broken.md to revert to a usable state!"
	echo "--------------------------------------------------------"
	

	echo Checking SIP status...
	if [[ $(csrutil status) == *disabled* ]]
	then
	else
		echo "--------------------------------------------------------"
		echo " Please disable System Integrity Protection to continue"
		echo "--------------------------------------------------------"
		echo  
		echo Aborting...
		exit
	fi

	if [[ $(ls) == *bkup* ]]
	then
		echo Existing backup detected, skipping .car file backup...
	else
		echo Backing up current .car files...
		mkdir bkup
		cp -r /System/Library/CoreServices/SystemAppearance.bundle/Contents/Resources/ bkup
	fi
	
	mountExit="$(mount)"
	diskID="${mountExit:0:12}"

	echo Mounting root volume as r/w...
	mkdir ~/lvmnt
	sudo mount -o nobrowse -t apfs $diskID ~/lvmnt

	echo "Copying files..."
	echo "Copying Aqua.car..."
	sudo cp Aqua.car ~/lvmnt/System/Library/CoreServices/SystemAppearance.bundle/Contents/Resources/
	echo "Copying DarkAqua.car..."
	sudo cp DarkAqua.car ~/lvmnt/System/Library/CoreServices/SystemAppearance.bundle/Contents/Resources/
	echo "Copying VibrantLight.car..."
	sudo cp VibrantLight.car ~/lvmnt/System/Library/CoreServices/SystemAppearance.bundle/Contents/Resources/
	echo "Copying VibrantDark.car..."
	sudo cp VibrantDark.car ~/lvmnt/System/Library/CoreServices/SystemAppearance.bundle/Contents/Resources/
	echo "##### Copying Assets.car... #####"
	sudo cp Assets.car ~/lvmnt/System/Library/CoreServices/SystemAppearance.bundle/Contents/Resources/

	echo Creating bootable APFS snapshot with the applied changes..
	if [[ $(uname -p) == *i386* || $(uname -p) == *x86_64* ]]
	then
		echo Using command for intel Macs...
		sudo bless --mount ~/lvmnt --bootefi --create-snapshot
	else
		echo Using command for Apple Silicon Macs...
		sudo bless --mount "~/lvmnt/System/Library/CoreServices/" --setBoot --create-snapshot
	fi
	echo Install finished! Reboot your computer to apply the changes.
}

uninstall()
{
	echo Attempting to restore from backup...

	if [[ $(ls) == *bkup* ]]
	then
	else
		echo "--------------------------------------------------------"
		echo " No backup folder detected! To revert changes, please "
		echo " reinstall macOS."
		echo "--------------------------------------------------------"
		echo Aborting...
		exit
	fi

	echo Checking SIP status...
	if [[ $(csrutil status) == *disabled* ]]
	then
	else
		echo "--------------------------------------------------------"
		echo " Please disable System Integrity Protection to continue"
		echo "--------------------------------------------------------"
		echo  
		echo Aborting...
		exit
	fi

	mountExit="$(mount)"
	diskID="${mountExit:0:12}"

	echo Mounting root volume as r/w...
	mkdir ~/lvmnt
	sudo mount -o nobrowse -t apfs $diskID ~/lvmnt

	echo "Copying files..."
	echo "Reverting Aqua.car..."
	sudo cp bkup/Aqua.car ~/lvmnt/System/Library/CoreServices/SystemAppearance.bundle/Contents/Resources/
	echo "Reverting DarkAqua.car..."
	sudo cp bkup/DarkAqua.car ~/lvmnt/System/Library/CoreServices/SystemAppearance.bundle/Contents/Resources/
	echo "Reverting VibrantLight.car..."
	sudo cp bkup/VibrantLight.car ~/lvmnt/System/Library/CoreServices/SystemAppearance.bundle/Contents/Resources/
	echo "Reverting VibrantDark.car..."
	sudo cp bkup/VibrantDark.car ~/lvmnt/System/Library/CoreServices/SystemAppearance.bundle/Contents/Resources/
	echo "Reverting Assets.car..."
	sudo cp bkup/Assets.car ~/lvmnt/System/Library/CoreServices/SystemAppearance.bundle/Contents/Resources/

	echo Creating bootable APFS snapshot with the applied changes..
	if [[ $(uname -p) == *i386* || $(uname -p) == *x86_64* ]]
	then
		echo Using command for intel Macs...
		sudo bless --mount ~/lvmnt --bootefi --create-snapshot
	else
		echo Using command for Apple Silicon Macs...
		sudo bless --mount "~/lvmnt/System/Library/CoreServices/" --setBoot --create-snapshot
	fi
	echo Install finished! Reboot your computer to apply the changes.
}

uninstallExt()
{
	echo "Restoring another macOS installation"


	echo Checking SIP status...
	if [[ $(csrutil status) == *disabled* ]]
	then
	else
		echo "--------------------------------------------------------"
		echo " Please disable System Integrity Protection to continue"
		echo "--------------------------------------------------------"
		echo  
		echo Aborting...
		exit
	fi

	diskID=""
	diskutil list virtual
	echo ""
	echo "Out of the list above, please type the identifier of the volume you want to restore."
	echo "Make sure the identifier is of a disk such as 'Macintosh HD', the one WITHOUT '- Data'"
	echo "Make sure you drop the second 's#' postfix."
	echo "Example: /dev/disk1s7 (instead of /dev/disk1s7s1)"
	echo ""
	read "?> " diskID
	if [[ $(echo $diskID) = /dev/disk?s? ]]
	then
	else
		echo "Wrong disk format! Make sure the disk format is /dev/disk?s?, where instead of ? is a number."
		uninstallExt
	fi

	if [[ $(ls) == *bkup* ]]
	then
	else
		echo "--------------------------------------------------------"
		echo " Please copy the backup folder from the target drive to "
		echo " the current directory first!"
		echo "--------------------------------------------------------"
		echo ""
		echo "! The current directory is: $(pwd)"
		echo ""
		uninstallExt
	fi

	echo Mounting root volume as r/w...
	mkdir ~/lvmnt
	sudo mount -o nobrowse -t apfs $diskID ~/lvmnt

	echo "Copying files..."
	echo "Reverting Aqua.car..."
	sudo cp bkup/Aqua.car ~/lvmnt/System/Library/CoreServices/SystemAppearance.bundle/Contents/Resources/
	echo "Reverting DarkAqua.car..."
	sudo cp bkup/DarkAqua.car ~/lvmnt/System/Library/CoreServices/SystemAppearance.bundle/Contents/Resources/
	echo "Reverting VibrantLight.car..."
	sudo cp bkup/VibrantLight.car ~/lvmnt/System/Library/CoreServices/SystemAppearance.bundle/Contents/Resources/
	echo "Reverting VibrantDark.car..."
	sudo cp bkup/VibrantDark.car ~/lvmnt/System/Library/CoreServices/SystemAppearance.bundle/Contents/Resources/
	echo "Reverting Assets.car..."
	sudo cp bkup/Assets.car ~/lvmnt/System/Library/CoreServices/SystemAppearance.bundle/Contents/Resources/

	echo Creating bootable APFS snapshot with the applied changes..
	if [[ $(uname -p) == *i386* || $(uname -p) == *x86_64* ]]
	then
		echo Using command for intel Macs...
		sudo bless --mount ~/lvmnt --bootefi --create-snapshot
	else
		echo Using command for Apple Silicon Macs...
		sudo bless --mount "~/lvmnt/System/Library/CoreServices/" --setBoot --create-snapshot
	fi
	echo Install finished! Reboot your computer to apply the changes.
}


main()
{
echo "Options: "
echo "	1. Install the theme"
echo "	2. Restore theme from backup"
echo "	3. Restore theme to another macOS drive"
echo "	9. Ignore all checks and install a test version (Dangerous!)"
echo "	0. Remove the backup folder (Dangerous!)"
echo "  "
choice="1"
instVar="1"
uninstVar="2"
read "?> " choice 
echo " "

case $choice in
	"0") echo "Removing the backup..."; rm -rf bkup;; # remove the backup
	"1") install;;
	"2") uninstall;;
	"3") uninstallExt;;
	"9") installTest;;
esac
}


echo "This is the AquaLickXV installer."
main