# Keymando DMG Installer

This plugin provides two new commands for installing .dmg files. Both commands mount the given .dmg, find any .app files and move them to /Applications, then cleanup by unmounting and deleting the .dmg.

## Commands

    Install selected dmg

Uses a selected file in Finder as the target path.

    Install downloaded dmg

Creates a dialog window listing all .dmgs discovered in the ~/Downloads directory for the user. The selection is then used as the target path.


## Todo

As it was originally written to get a feel for the Keymando API, and uncover some basic behaviors for building more complicated scripts, there aren't exactly a lot of changes planned. Anything that will allow Keymando to continue to replace other mouse-free focused apps will be considered. Currently planned are:

- Break the hard coded #{Dir.home}/Downloads path, and support a DmgInstaller.register method for multiple search paths, similar to the AppLauncher plugin.
- Support .pkg installations as well as .dmg files.

If you have any additional ideas, feel free to fork and hack away.


