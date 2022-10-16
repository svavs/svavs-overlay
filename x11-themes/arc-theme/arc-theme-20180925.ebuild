# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="A flat theme with transparent elements for GTK+3, GTK+2 and GNOME Shell"
HOMEPAGE="https://github.com/NicoHood/arc-theme"
COMMIT="3f6e52d526bd9f933ca1bb0c1adaacee1f6d4a60"
SRC_URI="https://github.com/NicoHood/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cinnamon gnome-shell +gtk2 +gtk3 mate openbox xfce"

# Supports various GTK+3 versions and uses pkg-config to determine which
# set of files to install. Updates will break it but only this fix will
# help. https://github.com/horst3180/arc-theme/pull/436
DEPEND="
	dev-lang/sassc
	gtk3? ( >=x11-libs/gtk+-3.14:3
	virtual/pkgconfig )
	gtk2? ( media-gfx/inkscape
	media-gfx/optipng )"

# gnome-themes-standard is only needed by GTK+2 for the Adwaita
# engine. This engine is built into GTK+3.
RDEPEND="gtk2? ( x11-themes/gnome-themes-standard
	x11-themes/gtk-engines-murrine )"

S="${WORKDIR}/${PN}-${COMMIT}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-unity \
		$(use_enable cinnamon) \
		$(use_enable gtk2) \
		$(use_enable gtk3) \
		$(use_enable gnome-shell) \
		$(use_enable mate metacity) \
		$(use_enable openbox openbox) \
		$(use_enable xfce xfwm)
}
