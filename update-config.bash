#!/usr/bin/env bash

platform='unknown'
case "${OSTYPE}" in
  solaris*) platform='solaris' ;;
  darwin*)  platform='darwin' ;;
  linux*)   platform='linux' ;;
  bsd*)     platform='bsd' ;;
  msys*)    platform='msys' ;;
esac

# MacOS
if [ "${platform}" = "darwin" ] && [ -f "/Applications/PhpStorm.app/Contents/Info.plist" ]; then
  PhpStormVersion=$(/usr/libexec/PlistBuddy -c "Print :JVMOptions:Properties:idea.paths.selector" /Applications/PhpStorm.app/Contents/Info.plist)
  ConfigLibrary=~/Library/Application\ Support/JetBrains/"${PhpStormVersion}"
else
   echo "Couldn't fetch information from Info.plist"
fi

# Linux
# @todo `~/.config/JetBrains/PhpStorm2020.3`

# Check for updates first before copying anything.
# @todo

# Copy new files to the respective places.
if [ "${PhpStormVersion}" != "" ]; then
  echo "Copying files to ${ConfigLibrary}"
  cp -Rf config/. "${ConfigLibrary}"
  echo "Your PHPStorm configuration has been updated successfully."
fi
