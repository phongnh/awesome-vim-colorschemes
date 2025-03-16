#!/usr/bin/env bash
set -eu
shopt -s nocaseglob

function _dl() {
	local tmp="tmp" docs="docs" rtp=${2:-}

	[ -d "$tmp" ] || mkdir "$tmp"
	[ -d "$docs" ] || mkdir "$docs"

	curl -L "https://api.github.com/repos/$1/tarball" \
		-H "Authorization: token $HOMEBREW_GITHUB_API_TOKEN" \
		| tar xz --strip=1 -C "$tmp"/

	rsync -avh "$tmp"/"$rtp" --include='after/***' \
		--include='autoload/***' --include='colors/***' \
		--include='plugin/***' --exclude='*' .

	cp -r "$tmp"/"$rtp"/README* "$docs"/"${1//\//-}".md
	rm -rf "$tmp"
}

function _main() {
	_dl cocopon/iceberg.vim
	_dl dracula/vim
	_dl lifepillar/vim-solarized8
	_dl nordtheme/vim
	_dl sainnhe/edge
	_dl sainnhe/everforest
	_dl sainnhe/gruvbox-material
	_dl sainnhe/sonokai
	_dl whatyouhide/vim-gotham

	chmod -x colors/*vim
}
_main
