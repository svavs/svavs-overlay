
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake 

DESCRIPTION="A dynamic Linux tiling window manager for Xorg"
HOMEPAGE="https://github.com/hyprwm/Hypr"
SRC_URI="https://github.com/hyprwm/Hypr/archive/refs/tags/${PV}.tar.gz"
S="${WORKDIR}/Hypr-${PV}"
LICENSE="BSD-with-attribution"
SLOT="0"
KEYWORDS="~amd64"
IUSE="dbus gnome"

# A space delimited list of portage features to restrict. man 5 ebuild
# for details.  Usually not needed.
RESTRICT="test"

# Run-time dependencies. Must be defined to whatever this depends on to run.
# Example:
#    ssl? ( >=dev-libs/openssl-1.0.2q:0= )
#    >=dev-lang/perl-5.24.3-r1
# It is advisable to use the >= syntax show above, to reflect what you
# had installed on your system when you tested the package.  Then
# other users hopefully won't be caught without the right version of
# a dependency.
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

# Build-time dependencies that need to be binary compatible with the system
# being built (CHOST). These include libraries that we link against.
# The below is valid if the same run-time depends are required to compile.
DEPEND="${RDEPEND}"

# Build-time dependencies that are executed during the emerge process, and
# only need to be present in the native build system (CBUILD). Example:
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
  cmake_src_configure
}

src_compile() {
  cmake_src_compile
}

src_install() {
  dobin ${WORKDIR}/${PF}_build/Hypr

	pax-mark m "${ED}"/usr/bin/Hypr

	exeinto /etc/X11/Sessions
	newexe "${FILESDIR}"/${PN}-session ${PN}

	# GNOME-based awesome
	if use gnome; then
		# GNOME session
		insinto /usr/share/gnome-session/sessions
		newins "${FILESDIR}"/${PN}-gnome-3.session ${PN}-gnome.session

		# Application launcher
		domenu "${S}"/example/${PN}.desktop

		# X Session
		insinto /usr/share/xsessions
		doins "${S}"/example/${PN}.desktop
	fi

}
