# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit xdg

DESCRIPTION="No Nonsense Neovim Client in Rust"
HOMEPAGE="https://github.com/neovide/neovide https://neovide.dev"
SRC_URI="https://github.com/neovide/neovide/releases/download/${PV}/neovide.tar.gz"

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

# src unpacks the exe directly into WORKDIR with no subfolders
S="${WORKDIR}/."

QA_PREBUILT="*"

src_install() {
    insinto "/opt/${P}"
    exeinto "/opt/${P}"
    doins -r "assets"
    doexe "neovide"
    dosym "/opt/${P}/neovide" "/usr/bin/neovide"
    dosym "/opt/${P}/assets/neovide.desktop" "/usr/share/applications/neovide.desktop"
    dosym "/opt/${P}/assets/neovide-16x16.png" "/usr/share/pixmaps/neovide-16x16.png"
    dosym "/opt/${P}/assets/neovide-256x256.png" "/usr/share/pixmaps/neovide-256x256.png"
    dosym "/opt/${P}/assets/neovide-32x32.png" "/usr/share/pixmaps/neovide-32x32.png"
    dosym "/opt/${P}/assets/neovide-48x48.png" "/usr/share/pixmaps/neovide-48x48.png"
    dosym "/opt/${P}/assets/neovide.svg" "/usr/share/pixmaps/neovide.svg"
}

pkg_postinst() {
    xdg_desktop_database_update
}

pkg_postrm() {
    xdg_desktop_database_update
}
