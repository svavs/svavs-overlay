# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# FIX: Not compiling cause of cargo's package compile error of skia-bindings

EAPI=8
inherit cargo git-r3

DESCRIPTION="No Nonsense Neovim Client in Rust"
HOMEPAGE="https://github.com/vhakulinen/gnvim"
EGIT_REPO_URI="https://github.com/vhakulinen/gnvim"
RESTRICT="mirror"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	app-editors/neovim
	virtual/rust
  dev-cpp/gtkmm
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
