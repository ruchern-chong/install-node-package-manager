#!/bin/bash

USE_COREPACK=false

# Check if npm is installed because we need this to install the package managers globally.
# This should be the most cross-platform compatible way to do so.
if ! command -v npm &> /dev/null
then
	echo "npm not installed. Please install npm before proceeding."
	exit
else
	# Check if node version is greater than v16.
	# This check is needed to use corepack to install the necessary packages.
	if node --version ge 16.0.0 &> /dev/null;
	then
		while true; do
		read -r -p "Node v16 detected. Use corepack (recommended) to install the package managers? [Y/n] " corepack
		# Setting the default value to Y here since corepack is recommended to be used for installing the package managers starting from Node v16.
		corepack=${corepack:=Y}
			case $corepack in
				[Yy]* ) 
					USE_COREPACK=true;
					exec corepack enable > /dev/null 2>&1 &
					break;;
				[Nn]* ) 
					USE_COREPACK=false;
					break;;
				* ) echo "Please select a valid input";;
			esac
		done
	fi
	# Display a selection menu for the users to install the node package managers of their choice.
	# Since npm is already installed, this is temporarily removed from the menu.
	echo "Select the package manager you want to install. [yarn/pnpm] "
	select pkgmgr in "yarn" "pnpm"; do
		case $pkgmgr in
			# npm ) 
			# 	echo "Installing npm";
			# 	break;;
			yarn ) 
				echo "Installing yarn";
				# Install the stable version of yarn berry
				exec corepack prepare yarn@stable --activate
				break;;
			pnpm ) 
				echo "Installing pnpm";
				if [ "$USE_COREPACK" ]; then
					# Install the latest version of pnpm using corepack
					exec corepack prepare pnpm@latest --activate
				else
					# Install the latest version of pnpm using the legacy way
					exec npm install -g pnpm
				fi
				break;;
			* ) echo "Please select a valid input";;
		esac
	done
fi