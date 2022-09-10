# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
GNOME2_LA_PUNT="yes" # plugins are dlopened
PYTHON_COMPAT=( python3_{8..10} )

inherit eutils gnome2 meson multilib python-single-r1

DESCRIPTION="X-Apps document [viewer] capable of displaying multiple and single page document formats like PDF and Postscript"
HOMEPAGE="https://github.com/linuxmint/xreader"
SRC_URI="https://github.com/linuxmint/xreader/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ CC-BY-SA-3.0"
SLOT="0"

IUSE="doc +python +pdf +ps +dvi djvu +tiff +xps epub"
# python-single-r1 would request disabling PYTHON_TARGETS on libpeas
# we need to fix that
REQUIRED_USE="python? ( ^^ ( $(python_gen_useflags '*') ) )"

KEYWORDS="~amd64 ~x86"

# X libs are not needed for OSX (aqua)
COMMON_DEPEND="
	x11-libs/cairo
	>=dev-libs/glib-2.44:2[dbus]
	>=x11-libs/gtk+-3.16:3[introspection]
	dev-libs/Ice
	sys-libs/zlib
	app-crypt/libsecret

	>=dev-libs/libxml2-2.5.0:2
	x11-libs/gtksourceview:4[introspection]
	>=dev-libs/libpeas-1.14.1[gtk]

	gnome-base/gsettings-desktop-schemas

	>=x11-libs/xapp-1.9.0
	x11-libs/libX11
	net-libs/libsoup:2.4

	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/pycairo[${PYTHON_USEDEP}]
			>=dev-python/pygobject-3:3[cairo,${PYTHON_USEDEP}]
			dev-libs/libpeas[${PYTHON_SINGLE_USEDEP}]
		')
	)

	pdf? ( app-text/poppler )
	ps? ( >=app-text/libspectre-0.2.0 )
	dvi? (
		dev-libs/kpathsea
		>=app-text/libspectre-0.2.0
		media-libs/t1lib
	)
	djvu? ( >=app-text/djvu-3.5.17 )
	tiff? ( media-libs/tiff )
	xps? ( >=app-text/libgxps-0.2.1 )
	epub? ( net-libs/webkit-gtk )
"

RDEPEND="${COMMON_DEPEND}
	x11-themes/adwaita-icon-theme
"

DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	dev-libs/libxml2:2
	>=dev-util/intltool-0.50.1
	>=dev-util/gtk-doc-am-1
	virtual/pkgconfig
	dev-libs/mathjax
"

# yelp-tools, gnome-common needed to eautoreconf

pkg_setup() {
	use python && [[ ${MERGE_TYPE} != binary ]] && python_setup
}

src_prepare() {
	gnome2_src_prepare
}

src_configure() {
	DOCS="AUTHORS COPYING ChangeLog NEWS README.md debian/changelog"

	local emesonargs=(
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
