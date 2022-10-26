
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake desktop #pax-utils

DESCRIPTION="A dynamic Linux tiling window manager for Xorg"
HOMEPAGE="https://github.com/hyprwm/Hypr"
SRC_URI="https://github.com/hyprwm/Hypr/archive/refs/tags/${PV}.tar.gz"

S="${WORKDIR}/Hypr-${PV}"

LICENSE="BSD-with-attribution"
SLOT="0"
KEYWORDS="~amd64"
IUSE="dbus gnome"

RESTRICT="test"

RDEPEND="
  >=x11-libs/cairo-1.16.0-r6
  >=x11-libs/libxcb-1.15-r1
  >=x11-base/xcb-proto-1.15.2
  >=x11-libs/xcb-util-0.4.0-r2
  >=x11-libs/xcb-util-cursor-0.1.3-r4
  >=x11-libs/xcb-util-keysyms-0.4.0-r2
  >=x11-libs/xcb-util-wm-0.4.1-r3
	dbus? ( sys-apps/dbus )
"

DEPEND="${RDEPEND}"

BDEPEND="${DEPEND}
  >=sys-devel/gdb-11.2
  >=dev-util/ninja-1.11.1-r2
  >=sys-devel/gcc-11.3.0
  >=dev-util/cmake-3.24.2
  >=dev-cpp/gtkmm-4.6.1-r1
  >=dev-cpp/gtkmm-3.24.6-r1
  >=gui-libs/gtk-4.6.7-r1

  >=media-libs/harfbuzz-5.1.0
  >=dev-libs/glib-2.72.3

	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-cmakelists-g++-path.patch  # bug #408025
	"${FILESDIR}"/${PN}-xsession.patch          # bug #408025
)

src_prepare() {
  cmake_src_prepare
}
src_configure() {
	local mycmakeargs=(
		-DSYSCONFDIR="${EPREFIX}"/etc
		-DWITH_DBUS=$(usex dbus)
	)
  cmake_src_configure
}

src_compile() {
  cmake_src_compile
}

src_install() {
  dobin ${WORKDIR}/${PF}_build/Hypr

	# pax-mark m "${ED}"/usr/bin/Hypr

	exeinto /etc/X11/Sessions
	newexe "${FILESDIR}"/${PN}-session ${PN}

  # X Session
  insinto /usr/share/xsessions
  doins "${S}"/example/${PN}.desktop

	# GNOME-based 
	if use gnome; then
		# GNOME session
		insinto /usr/share/gnome-session/sessions
		newins "${FILESDIR}"/${PN}-gnome-3.session ${PN}-gnome.session

		# Application launcher
		domenu "${S}"/example/${PN}.desktop

		# X Session
		# insinto /usr/share/xsessions
		# doins "${S}"/example/${PN}.desktop
	fi
}
