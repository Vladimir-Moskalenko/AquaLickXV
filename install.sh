#!/bin/zsh
# AquaLickXV installer script
# v. 1.0.2

# Versioning cheatsheet:
# - Major: significant changes; rewrites; adding a GUI
# - Semimajor: imortant changes, but not as major, such as improving support; more theming options
# - Minor: bugfixes, optimization, new features


install() 
{
	echo Checking macOS version...

	if [[ $(sw_vers --productVersion) == *15.5* ]]
	then
	else
		echo "--------------------------------------------------------"
		echo " Support only for macOS 15.5! Attempting to install on "
		echo " other versions may break the OS!"
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

	echo Copying files...
	cp Aqua.car ~/lvmnt/System/Library/CoreServices/SystemAppearance.bundle/Contents/Resources/
	cp DarkAqua.car ~/lvmnt/System/Library/CoreServices/SystemAppearance.bundle/Contents/Resources/
	cp VibrantLight.car ~/lvmnt/System/Library/CoreServices/SystemAppearance.bundle/Contents/Resources/
	cp VibrantDark.car ~/lvmnt/System/Library/CoreServices/SystemAppearance.bundle/Contents/Resources/

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
	echo Checking macOS version...

	if [[ $(sw_vers --productVersion) == *15.5* ]]
	then
	else
		echo "--------------------------------------------------------"
		echo " Support only for macOS 15.5! Attempting to install on "
		echo " other versions may break the OS!"
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

	echo Copying files...
	cp /bkup/Aqua.car ~/lvmnt/System/Library/CoreServices/SystemAppearance.bundle/Contents/Resources/
	cp /bkup/DarkAqua.car ~/lvmnt/System/Library/CoreServices/SystemAppearance.bundle/Contents/Resources/
	cp /bkup/VibrantLight.car ~/lvmnt/System/Library/CoreServices/SystemAppearance.bundle/Contents/Resources/
	cp /bkup/VibrantDark.car ~/lvmnt/System/Library/CoreServices/SystemAppearance .bundle/Contents/Resources/

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
echo " "
choice="1"
instVar="1"
uninstVar="2"
read "?> " choice 


case $choice in
	"0") echo "Removing the backup..."; rm -rf bkup;; # remove the backup
	"1") install;;
	"2") uninstall;;
	"3") installTest;;
esac
}


echo "This is the AquaLickXV installer."
main