#! /usr/bin/env bash

USE_COREPACK=false

if ! command -v npm &> /dev/null 
then
	echo "npm not installed. Please install npm before proceeding."
	exit
else
	if node --version ge 16.0.0 &> /dev/null;
	then
		while true; do
		read -r -p "Node v16 detected. Use corepack (recommended) to install the package managers? [Y/n] " corepack
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

	echo "Select the package manager you want to install. [yarn/pnpm] "
	select pkgmgr in "yarn" "pnpm"; do
		case $pkgmgr in
			# npm ) 
			# 	echo "Installing npm";
			# 	break;;
			yarn ) 
				echo "Installing yarn";
				exec corepack prepare yarn@stable --activate
				break;;
			pnpm ) 
				echo "Installing pnpm";
				if [ "$USE_COREPACK" ]; then
					exec corepack prepare pnpm@latest --activate
				else
					exec npm install -g pnpm
				fi
				break;;
			* ) echo "Please select a valid input";;
		esac
	done
fi