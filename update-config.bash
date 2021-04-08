#!/usr/bin/env bash

# ANSI Color codes for better formatting.
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Check the OS the script is running on.
platform='unknown'
case "${OSTYPE}" in
  solaris*) platform='solaris' ;;
  darwin*)  platform='darwin' ;;
  linux*)   platform='linux' ;;
  bsd*)     platform='bsd' ;;
  msys*)    platform='msys' ;;
esac

#
# MacOS
# ---
# The script will search through the '/Applications' folder for directories using the 'PhpStorm' string to see if there
# are more then 1 version installed then asks the user to select the one they want the configuration to be applied for.
#
if [ "${platform}" = "darwin" ] && [ -f "/Applications/PhpStorm.app/Contents/Info.plist" ]; then
  echo "Searching for installed PhpStorm versions. Please wait..."
  # Use the built-in Input Field Separator to create the PHPSTORM_VERSIONS array.
  IFS=$'\n' read -r -d '' -a PHPSTORM_VERSIONS <<< "$(find /Applications -type d -name "*PhpStorm*" -print 2>/dev/null)"
  PS3="Select the PhpStorm version you want the configurations to be applied for: "
  select APP_VERSION in "${PHPSTORM_VERSIONS[@]}"
  do
    [[ -n $APP_VERSION ]] || { echo "Invalid choice. Please try again." >&2; continue; }
    CHOSEN_VERSION="$(echo "${APP_VERSION}" | rev | cut -d'/' -f1 | rev)"
    # Use PlistBuddy to check the configuration folder for the chosen PhpStorm version.
    PHPSTORM_VERSION="$(/usr/libexec/PlistBuddy -c 'Print :JVMOptions:Properties:idea.paths.selector' /Applications/"${CHOSEN_VERSION}"/Contents/Info.plist)"
    break
  done
  CONFIG_LIBRARY=~/Library/Application\ Support/JetBrains/"${PHPSTORM_VERSION}"
else
   echo -e "${RED}Error!${NC}"
   echo "Couldn't fetch information from Info.plist"
fi

# Linux
# @todo
if [ "${platform}" = "linux" ]; then
  IFS=' ' read -r -a PHPSTORM_SCRIPTS <<< "$(whereis phpstorm)"
  SCRIPT_LOCATION=$(for i in "${PHPSTORM_SCRIPTS[@]}";do echo "$i";done | grep phpstorm.sh)
  # idea.properties -> idea.config.path -> if set, use it, if not, use the default `~/.config/JetBrains/PhpStorm2021.1`
  echo "${SCRIPT_LOCATION}"
fi

# Check for updates first before copying anything.
# @todo

# Copy new files to the respective places.
if [ "${PHPSTORM_VERSION}" != "" ]; then
  echo ""
  echo -e "Copying files to ${CYAN}'${CONFIG_LIBRARY}'${NC}"
  # Find all files located in config folder that are not hidden files or README.md or this script.
  FOLDERS="$(find . -type d -not -path '*/\.*' -not -path './README.md' -not -path './update-config.bash' -not -path '.')"
  for FOLDER in ${FOLDERS}
  do
    cp -Rf "${FOLDER}" "${CONFIG_LIBRARY}"
  done
  echo -e "${GREEN}Success!${NC}"
  echo "Your PHPStorm configuration has been updated successfully."
fi
