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

# Function to copy files of this repository (except the README and this script)
# recursively to the location specified in $1.
copyfiles() {
  local CONFIG_LIBRARY="$1"
  local COPY_FAILURE=0
  if [ "${PHPSTORM_VERSION}" != "" ]; then
    echo ""
    # Find all files located in config folder that are not hidden files or README.md or this script.
    FOLDERS="$(find . -type d -not -path '*/\.*' -not -path './README.md' -not -path './update-config.bash' -not -path '.')"
    for FOLDER in ${FOLDERS}
    do
      if ! cp -Rf "${FOLDER}" "${CONFIG_LIBRARY}"; then
        COPY_FAILURE=1
        echo -e "Failed to copy file(s) from \"${CYAN}'${FOLDER}'${NC}\""
      else
        echo -e "File(s) from \"${CYAN}'${FOLDER}'${NC}\" has been successfully copied."
      fi
    done
    echo ""
    if [ "${COPY_FAILURE}" -eq 0 ]; then
      echo -e "${GREEN}Success!${NC}"
      echo "Your PHPStorm configuration has been updated successfully."
      echo "Please re-open your IDE to see the changes."
    else
      echo -e "${RED}Error!${NC}"
      echo "There were some problems updating the configuration."
    fi
  fi
}

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

# If the CONFIG_LIBRARY is successfully set, ask the user if they want to copy the file(s) to the designated place(s).
if [ "${CONFIG_LIBRARY}" ]; then
  echo ""
  echo "Configuration folder for your chosen PhpStorm version has been found:"
  echo -e "${CYAN}'${CONFIG_LIBRARY}'${NC}"
  echo ""
  echo "The script will now copy the files from the repository to this location."
  read -p "Do you wish to continue (Y/n)? " -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
      copyfiles "${CONFIG_LIBRARY}"
  fi
fi
