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
# @todo Ask the user if they are sure to run the script.
if [ "${PhpStormVersion}" != "" ]; then
  echo "Copying files to ${ConfigLibrary}"
  # Find all files located in config folder that are not hidden filed or README or this script.
  folders="$(find . -type d -not -path '*/\.*' -not -path './README.md' -not -path './update-config.bash' -not -path '.')"
  for folder in ${folders}
  do
    cp -Rf "${folder}" "${ConfigLibrary}"
  done
  echo "Your PHPStorm configuration has been updated successfully."
fi
