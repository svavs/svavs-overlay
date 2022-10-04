# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit xdg

DESCRIPTION="No Nonsense Neovim Client in Rust"
HOMEPAGE="https://github.com/neovide/neovide https://neovide.dev"
SRC_URI="https://github.com/neovide/neovide/releases/download/${PV}/neovide.tar.gz -> ${PN}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	app-editors/neovim
	virtual/rust
	media-libs/mesa
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libglvnd
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

QA_PREBUILT="*"

src_install() {
    insinto "/opt/${P}"
    exeinto "/opt/${P}"
    doins "${FILESDIR}/neovide.desktop"
    doexe "neovide"
    dosym "/opt/${P}/neovide" "/usr/bin/neovide"
    dosym "/opt/${P}/neovide.desktop" "/usr/share/applications/neovide.desktop"
}

pkg_postinst() {
    xdg_desktop_database_update
}

pkg_postrm() {
    xdg_desktop_database_update
}
