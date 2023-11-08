#!/bin/bash

set -eux

installCaskPackages(){
	local pkgs=(
		"karabiner-elements"
		"maccy"
		"amethyst"
		"docker"
		"tomatobar"
	)

	# shellcheck disable=SC2086
	brew install --cask ${pkgs[*]}
}

moveConfigs(){
  pushd "$HOME/Desktop/git/dotfiles/mac"
	for dir in */ ; do
		mkdir -p "$HOME/.config/$dir"
		cp -r "$dir" "$HOME/.config/$dir"
	done	
}


installCaskPackages
moveConfigs
popd
