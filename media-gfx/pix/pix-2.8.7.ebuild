# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
GNOME2_LA_PUNT="yes" # plugins are dlopened
PYTHON_COMPAT=( python3_{8..10} )

inherit autotools eutils gnome2 multilib python-single-r1

DESCRIPTION="X-Apps [Image] Pix is an application to organize yout photos, based on gThumb"
HOMEPAGE="https://github.com/linuxmint/pix"
SRC_URI="https://github.com/linuxmint/pix/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ CC-BY-SA-3.0"
SLOT="0"

IUSE="doc +python +raw +slideshow"
REQUIRED_USE="python? ( ^^ ( $(python_gen_useflags '*') ) )"

KEYWORDS="~amd64 ~x86"

DOCS="AUTHORS COPYING INSTALL MAINTAINERS NEWS README debian/changelog"

COMMON_DEPEND="
	sys-devel/flex
	sys-devel/bison
	media-libs/libpng
	x11-libs/libSM
	x11-libs/libICE
	sys-devel/libtool
	gnome-base/gnome-common
	gnome-base/gsettings-desktop-schemas
	>=x11-libs/gtk+-3.20.0:3[introspection]
	>=dev-libs/glib-2.34:2[dbus]
	x11-libs/cairo
	dev-libs/libltdl
	>=net-libs/libsoup-2.36:2.4
	>=gnome-base/librsvg-2.34
	sys-libs/zlib
	app-crypt/libsecret
	media-libs/libwebp
	net-libs/webkit-gtk

	>=media-gfx/exiv2-0.21
	media-libs/gstreamer
	media-libs/gst-plugins-base
	media-libs/libjpeg-turbo
	media-libs/tiff

	slideshow? (
		media-libs/clutter
		media-libs/clutter-gtk
	)

	raw? ( media-libs/libopenraw )

	dev-libs/gobject-introspection
	app-text/djvu
	app-text/libgxps
	dev-libs/kpathsea
	app-text/poppler
	app-text/libspectre
	>=x11-libs/xapp-1.9.0
	mate-base/mate-common
	dev-libs/libxslt


	gnome-base/gsettings-desktop-schemas
	gnome-base/gvfs

	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/pycairo[${PYTHON_USEDEP}]
			>=dev-python/pygobject-3:3[cairo,${PYTHON_USEDEP}]
		')
	)
"

RDEPEND="${COMMON_DEPEND}
	x11-themes/adwaita-icon-theme
"

DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	app-text/yelp-tools
	>=dev-libs/libxml2-2.4.0:2
	virtual/pkgconfig
"

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
