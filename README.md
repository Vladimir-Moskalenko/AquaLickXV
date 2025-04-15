# AquaLickX for macOS XV Sequoia


## Fork of [AquaLickX for Sequoia 15.0.1](https://github.com/VisualisationExpo/AquaLickX-SequoiaEdition)

Created on macOS Sequoia **15.5**. Install on other versions of macOS Sequoia at your own risk.
For other macOS Versions, check out the list below.

### Links to other versions of AquaLickX:
- [macOS Monterey](https://github.com/VisualisationExpo/AquaLickX) (original project)
- [macOS Sonoma](https://github.com/VisualisationExpo/AquaLickX-Sonoma145Edition)
- [macOS Sequoia](https://github.com/VisualisationExpo/AquaLickX-SequoiaEdition) (15.0.1)

**Warning: read the README files of each of the projects above before attempting to install the .car files! Failing to do so may result in a broken OS!**


# Installation

To install the theme:
1. Download & unzip the project files
2. Make sure you have [disabled SIP](#disabling-sip)!
3. Open Terminal. Type the following: (replace `/path/to/files` with the path to the folder. Normally it'll be something like ~/Downloads/AquaLickXV-main. )
```
cd /path/to/files
chmod +x install.sh
./install.sh
```
3. All files should be automatically copied to the locations

# Disabling SIP
SIP is an additional protection measure introduced by Apple with OS X El Capitan. It prevents users or applications from editing `/System`, `/bin`, `/usr`, `/sbin`. The system appearance configuration files are located in `/System/Library/CoreServices` directory, meaning SIP needs to be disabled in order to change them. To disable SIP:
1. Enter recovery mode. On intel machines, press and hold `⌘+R` while your computer is starting up. On Apple Silicon machines, shut your Mac down. Then, press and hold the power button untill you see the boot picker. Select "Options", then click Next. 
(Note! On machines with Apple's T2 Security chip and Apple Silicon, you will be asked to select a volume to recover and enter an administrator's password)
2. In the menu bar, select "Utilities", and click "Terminal" (alternatively, press ⇧+⌘+T)
3. Type the following:
```
csrutil disable
csrutil authenticated-root disable
reboot
```
4. Complete the desired changes. In this case, reboot into macOS and [run the installer](#installation).
5. It is strongly recommended to re-enable SIP after this. To do so, complete steps 1 & 2. Then type:
```
csrutil enable
csrutil authenticated-root enable
reboot
```

[Apple Developer | SIP](https://developer.apple.com/documentation/security/disabling-and-enabling-system-integrity-protection)


# To-Do:

- [ ] Finish the README

### .car files
- [x] Window controls
- [x] Context menus
- [ ] Menubar
- [ ] Toolbar
- [ ] Other UI elements

### misc
- [x] .sh installer
- [ ] Enable installation for other macOS versions