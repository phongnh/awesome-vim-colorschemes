#!/usr/bin/env bash
set -eu
shopt -s nocaseglob

function _dl() {
	local tmp="tmp" docs="docs" rtp=""

	[ -d "$tmp" ] || mkdir "$tmp"
	[ -d "$docs" ] || mkdir "$docs"

	curl -L "https://api.github.com/repos/$1/tarball${2:+/$2}" \
		-H "Authorization: token $HOMEBREW_GITHUB_API_TOKEN" \
		| tar xz --strip=1 -C "$tmp"/

	rsync -avh "$tmp"/"$rtp" --include='after/***' \
		--include='autoload/***' --include='colors/***' \
		--include='lua/***' \
		--include='plugin/***' --exclude='*' .

	cp -r "$tmp"/"$rtp"/README* "$docs"/"${1//\//-}".md
	rm -rf "$tmp"
}

function _dl_codeberg() {
	local tmp="tmp" docs="docs" rtp="" ref=${2:-main}

	[ -d "$tmp" ] || mkdir "$tmp"
	[ -d "$docs" ] || mkdir "$docs"

	curl -L "https://codeberg.org/$1/archive/$ref.tar.gz" \
		| tar xz --strip=1 -C "$tmp"/

	rsync -avh "$tmp"/"$rtp" --include='after/***' \
		--include='autoload/***' --include='colors/***' \
		--include='lua/***' \
		--include='plugin/***' --exclude='*' .

	cp -r "$tmp"/"$rtp"/README* "$docs"/"${1//\//-}".md
	rm -rf "$tmp"
}

function _main() {
	_dl_codeberg lifepillar/vim-solarized8 master

	_dl cocopon/iceberg.vim
	_dl dracula/vim
	_dl nordtheme/vim
	_dl sainnhe/edge
	_dl sainnhe/everforest
	_dl sainnhe/gruvbox-material
	_dl sainnhe/sonokai
	_dl whatyouhide/vim-gotham
	_dl mhartington/oceanic-next
	_dl ayu-theme/ayu-vim
	_dl junegunn/seoul256.vim
	_dl rose-pine/vim
	_dl pineapplegiant/spaceduck
	_dl lanx-x/NeoSolarized

	_dl EdenEast/nightfox.nvim
	_dl zenbones-theme/zenbones.nvim

	chmod -x colors/*vim
}
_main
