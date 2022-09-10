# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
GNOME2_LA_PUNT="yes" # plugins are dlopened
PYTHON_COMPAT=( python3_{8..10} )
WANT_AUTOCONF=2.5
WANT_AUTOMAKE=1.9

inherit autotools eutils gnome2 multilib python-single-r1

DESCRIPTION="X-Apps generic [Media] player"
HOMEPAGE="https://github.com/linuxmint/xplayer"
SRC_URI="https://github.com/linuxmint/xplayer/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ CC-BY-SA-3.0"
SLOT="0"

IUSE="doc +python"
# python-single-r1 would request disabling PYTHON_TARGETS on libpeas
# we need to fix that
REQUIRED_USE="python? ( ^^ ( $(python_gen_useflags '*') ) )"

KEYWORDS="~amd64 ~x86"

# X libs are not needed for OSX (aqua)
COMMON_DEPEND="
	>=gnome-extra/cinnamon-desktop-5.2.1
	>=dev-libs/glib-2.33.0[dbus]
	>=x11-libs/gtk+-3.5.2[introspection]
	>=media-libs/grilo-0.2.0
	>=dev-libs/libxml2-2.6.0
	>=x11-libs/xapp-1.9.0
	>=x11-libs/gdk-pixbuf-2.42.8

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
	media-libs/clutter
	media-libs/clutter-gst
	media-libs/clutter-gtk
	media-libs/gstreamer[introspection]
	media-libs/gst-plugins-base[introspection]
	app-text/docbook-xml-dtd:4.1.2
	app-text/yelp-tools
	dev-libs/libxml2:2
	>=dev-util/gtk-doc-am-1
	>=dev-util/intltool-0.50.1
	virtual/pkgconfig
"

DOCS="AUTHORS COPYING ChangeLog INSTALL MAINTAINERS NEWS README TODO debian/changelog"

# yelp-tools, gnome-common needed to eautoreconf

pkg_setup() {
	use python && [[ ${MERGE_TYPE} != binary ]] && python_setup
}

src_prepare() {
	default
	eautoreconf
	gnome2_src_prepare
}

src_install() {
	default
}
