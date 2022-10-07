
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# inherit dotnet

DESCRIPTION="Cross platform Neovim front-end UI, built with F# and Avalonia"
HOMEPAGE="https://github.com/yatli/fvim"
SRC_URI="https://github.com/yatli/fvim/archive/refs/tags/v${PV}+g119a455.tar.gz"

# Source directory; the dir where the sources can be found (automatically
# unpacked) inside ${WORKDIR}.  The default value for S is ${WORKDIR}/${P}
# If you don't need to change it, leave the S= line out of the ebuild
# to keep it tidy.
S="${WORKDIR}/${P}-g119a455"


LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# Run-time dependencies. Must be defined to whatever this depends on to run.
RDEPEND=">=dev-dotnet/dotnet-sdk-bin-6.0.400"

# Build-time dependencies that need to be binary compatible with the system
# being built (CHOST). These include libraries that we link against.
# The below is valid if the same run-time depends are required to compile.
DEPEND="${RDEPEND}"

# Build-time dependencies that are executed during the emerge process, and
# only need to be present in the native build system (CBUILD). Example:
BDEPEND="${DEPEND}"


# The following src_configure function is implemented as default by portage, so
# you only need to call it if you need a different behaviour.
# src_configure() {
#   dotnet_pkg_setup
# }

# The following src_compile function is implemented as default by portage, so
# you only need to call it, if you need different behaviour.
# src_compile() {
#   # xbuild from Mono
#   exbuild
# }
src_compile() {
  dotnet publish -f net6.0 -c Release -r linux-x64 --self-contained
}

# The following src_install function is implemented as default by portage, so
# you only need to call it, if you need different behaviour.
# src_install() {
#   # gacinstall from Mono
#   egacinstall
# }
