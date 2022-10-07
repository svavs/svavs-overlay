
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit unpacker xdg-utils

DESCRIPTION="Cross platform Neovim front-end UI, built with F# and Avalonia"
HOMEPAGE="https://github.com/yatli/fvim"
SRC_URI="https://github.com/yatli/fvim/releases/download/v0.3.531%2Bg119a455/fvim-linux-amd64-v0.3.531+g119a455.deb"

S="${WORKDIR}"

RESTRICT="mirror"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64"

# Run-time dependencies. Must be defined to whatever this depends on to run.
RDEPEND=">=dev-dotnet/dotnet-sdk-bin-6.0.400"

# Build-time dependencies that need to be binary compatible with the system
# being built (CHOST). These include libraries that we link against.
# The below is valid if the same run-time depends are required to compile.
# DEPEND="${RDEPEND}"

# Build-time dependencies that are executed during the emerge process, and
# only need to be present in the native build system (CBUILD). Example:
# BDEPEND="${DEPEND}"


src_unpack() {
	unpack_deb ${A}
}

src_install() {
	cp -a * "${ED}/"
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
