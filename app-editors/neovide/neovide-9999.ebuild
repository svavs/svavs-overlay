# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [ "${PV#9999}" != "${PV}" ] ; then
	EGIT_REPO_URI="https://github.com/neovide/neovide"
	RESTRICT="mirror"
fi

inherit git-r3 cargo

DESCRIPTION="No Nonsense Neovim Client in Rust"
HOMEPAGE="https://github.com/neovide/neovide"

if [ "${PV#9999}" != "${PV}" ] ; then
	SRC_URI="$(cargo_crate_uris)"
else
	SRC_URI="https://github.com/neovide/neovide/releases/download/${PV}/${PN}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"

	# net-misc/curl
	# app-crypt/gnupg
	# app-misc/ca-certificates
	# dev-vcs/git
	# sys-devel/gcc[multilib]
	# dev-util/cmake
	# dev-libs/openssl
DEPEND="
	app-editors/neovim
	virtual/rust
	media-libs/mesa
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libglvnd
"
RDEPEND="${DEPEND}"

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}

src_configure() {
	local myfeatures=()
	cargo_src_configure --no-default-features
}

src_install() {
	cargo_src_install
}
