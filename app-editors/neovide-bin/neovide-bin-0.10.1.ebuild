# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit xdg desktop

DESCRIPTION="No Nonsense Neovim Client in Rust"
HOMEPAGE="https://github.com/neovide/neovide https://neovide.dev"
SRC_URI="https://github.com/neovide/neovide/releases/download/${PV}/neovide.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* amd64"

DEPEND="
	app-editors/neovim
	virtual/rust
	media-libs/mesa
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libglvnd
"
RDEPEND="${DEPEND}"

# src unpacks the exe directly into WORKDIR with no subfolders
S="${WORKDIR}/."

QA_PREBUILT="*"

src_install() {
    insinto "/opt/${P}"
    exeinto "/opt/${P}"
    doins -r "${FILESDIR}/assets"
    doexe "neovide"
    domenu "${FILESDIR}/assets/neovide.desktop"
    doicon "${FILESDIR}/assets/neovide.svg"
    dosym "/opt/${P}/neovide" "/usr/bin/neovide"
}

pkg_postinst() {
    xdg_desktop_database_update
}

pkg_postrm() {
    xdg_desktop_database_update
}
