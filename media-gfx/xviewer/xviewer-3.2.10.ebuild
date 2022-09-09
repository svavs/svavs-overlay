# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
GNOME2_LA_PUNT="yes" # plugins are dlopened
PYTHON_COMPAT=( python3_{8..10} )

inherit eutils gnome2 meson multilib python-single-r1

DESCRIPTION="X-Apps [Image] Viewer which uses the gdk-pixbuf library. It can deal with large images, and zoom and scroll with constant memory usage. Its goals are simplicity and standards compliance"
HOMEPAGE="https://github.com/linuxmint/xviewer"
SRC_URI="https://github.com/linuxmint/xviewer/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ CC-BY-SA-3.0"
SLOT="0"

IUSE="doc +python"
# python-single-r1 would request disabling PYTHON_TARGETS on libpeas
# we need to fix that
REQUIRED_USE="python? ( ^^ ( $(python_gen_useflags '*') ) )"

KEYWORDS="~amd64 ~x86"

# X libs are not needed for OSX (aqua)
COMMON_DEPEND="
	>=dev-libs/atk-2.38.0[introspection]
	>=gnome-extra/cinnamon-desktop-5.2.1
	>=x11-libs/gdk-pixbuf-2.42.8
	>=dev-libs/glib-2.44:2[dbus]
	>=x11-libs/gtk+-3.16:3[introspection]
	>=x11-libs/xapp-1.9.0
	>=dev-libs/libxml2-2.5.0:2
	>=sys-libs/zlib-1.2.11

	gnome-base/gsettings-desktop-schemas
	gnome-base/gvfs

	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/pycairo[${PYTHON_USEDEP}]
			>=dev-python/pygobject-3:3[cairo,${PYTHON_USEDEP}]
			dev-libs/libpeas[${PYTHON_SINGLE_USEDEP}]
		')
	)
"

RDEPEND="${COMMON_DEPEND}
	x11-themes/adwaita-icon-theme
"

DEPEND="${COMMON_DEPEND}
	dev-libs/libxml2:2
	media-libs/exempi
	media-libs/libexif
	media-libs/lcms
	gnome-base/librsvg
"

# yelp-tools, gnome-common needed to eautoreconf

pkg_setup() {
	use python && [[ ${MERGE_TYPE} != binary ]] && python_setup
}

src_prepare() {
	gnome2_src_prepare
}

src_configure() {
	DOCS="AUTHORS COPYING MAINTAINERS README.md THANKS debian/changelog"

	local emesonargs=(
		-Denable_gvfs_metadata=true
		$(meson_use doc docs)
	)

	meson_src_configure
}

src_compile() {
	meson_src_compile
}

##src_test() {
##	meson_src_test
##}

src_install() {
	meson_src_install
}
