
# Copyright 2022 Silvano Sallese
# Distributed under the terms of the GNU General Public License v2
#
# Install the latest release of the MkDoc documentation tool.
#
# Keywords:
#   docbook  : `xsltproc` required by `make doc/docbook/index.html`
#              and generation of docbook format of the documentation
#   http     : LWP::UserAgent and HTTP::Request perl modules to allow fetching online external declaration files
#   info     : `makeinfo` required by `meke doc/texinfo/doc.info`
#              and generation of info format of the documentation
#   latex    : `pdflatex`, `pdfcrop`, `pdftoppm` required by @math tag
#              and generation of pdf format of the documentation
#   man      : generation of man page of the documentation
#   rst      : `rst2html` required by `make doc/rst/doc.html`
#              and generation of rst format of the documentation
#   rtf      : Image::Size perl module to allow insertion of pictures in rtf format output
#              and generation of rtf format of the documentation
#   tracwiki : generation of tracwiki format of the documentation
#   txt      : generation of text format of the documentation
#

EAPI=7

inherit mercurial
inherit perl-functions

DESCRIPTION="MkDoc C/C++ documentation tool"
HOMEPAGE="https://www.nongnu.org/mkdoc/"
EHG_REPO_URI="https://hg.savannah.nongnu.org/hgweb/mkdoc/"

LICENSE="FDL-1.3+"
SLOT="0"
IUSE="docbook http info latex man rst rtf tracwiki txt"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"

# media-libs/netpbm is providing `pnmtopng` required by `make htmldoc`
RDEPEND="
	>=dev-lang/perl-5.10
	media-gfx/imagemagick[perl]
	media-libs/netpbm
	app-text/docbook-xsl-stylesheets
	latex? ( app-text/texlive-core app-text/poppler )
	rtf? ( dev-perl/Image-Size )
	http? ( dev-perl/LWP-UserAgent-Cached dev-perl/LWP-Protocol-http10 dev-perl/LWP-Protocol-https dev-perl/HTTP-Request-AsCGI )
	docbook? ( dev-libs/libxslt )
	rst? ( dev-python/docutils )
	info? ( sys-apps/texinfo )
	"
DEPEND="${RDEPEND}"

DOCS=(
	AUTHORS COPYING COPYING_FONT INSTALL README
)

PATCHES=(
	"${FILESDIR}/${PN}-makefile.patch"
)

src_compile () {
	emake htmldoc

	if use docbook; then
		emake doc/docbook/index.html
	fi

	# FIXME : make pdf documentation disabled because of an error about index generation
	# TODO  : fix the latex.tmpl
	if use latex; then
		# make doc/latex/doc.pdf
		elog "Skipping make doc.pdf: doc.tex is using the no more valid 'multind' package"
	fi

	if use info; then
		emake doc/texinfo/doc.info
	fi

	if use rst; then
		emake doc/rst/doc.html
	fi

	# FIXME : make txt documentation disabled because of an error about index generation
	# info:Writing documentation in text format ...
	#   info:Writing ./doc/text/doc.txt
	# Can't use an undefined value as an ARRAY reference at /home/silvano/tmp/mkdoc/src/mkdocDrvText.pm line 91.
	# make: *** [Makefile:57: doc/text/doc.txt] Errore 255
	#
	if use txt; then
		# make doc/text/doc.txt
		elog "Skipping make doc.txt: index generation is causing make error"
	fi

	if use man; then
		emake doc/man3/doc.3
		mv doc/man3/doc.3 doc/man3/mkdoc.3
	fi

	if use rtf; then
		emake doc/rtf/doc.rtf
	fi

	if use tracwiki; then
		emake doc/tracwiki/doc.txt
	fi
}

src_install() {
	# emake PREFIX=${D}/usr install || die "Install Failed"
	# einstall

	# cp -r src/* $(PREFIX)/share/mkdoc-9999
	einfo "Copying sources"
	insinto /usr/share/${PF}
	doins -r src/*

	# ln -s $(PREFIX)/share/mkdoc-9999/mkdoc $(PREFIX)/bin/mkdoc
	einfo "Creating bin file"
	dobin src/mkdoc

	einfo "Installing extra tools"
	# cp -r ${WORKDIR}/${P}/extra ${D}/usr/share/doc/mkdoc-9999/.
	dodoc -r extra

	einfo "Installing documentation"
	dodoc ${DOCS[@]}
	# cp -r doc/html $(PREFIX)/share/doc/mkdoc-9999
	einfo "--- html"
	dodoc -r doc/html

	if use docbook; then
		# cp -r ${WORKDIR}/${P}/doc/docbook ${D}/usr/share/doc/mkdoc-9999/.
		einfo "--- docbook"
		dodoc -r doc/docbook
	fi

	if use latex; then
		# cp -r ${WORKDIR}/${P}/doc/latex/doc.pdf ${D}/usr/share/doc/mkdoc-9999/doc.pdf
		einfo "--- Skipping dodoc for pdf format"
		#einfo "--- pdf"
		#dodoc -r doc/latex/doc.pdf
	fi

	if use man; then
		einfo "--- man page"
		dodoc doc/man3/mkdoc.3
		doman doc/man3/mkdoc.3
	fi

	if use info; then
		# cp -r ${WORKDIR}/${P}/doc/texinfo ${D}/usr/share/doc/mkdoc-9999/.
		einfo "--- info page"
		dodoc -r doc/texinfo
		doinfo doc/texinfo/doc.info
	fi

	if use rst; then
		# cp -r ${WORKDIR}/${P}/doc/rst ${D}/usr/share/doc/mkdoc-9999/.
		einfo "--- rst"
		dodoc -r doc/rst
	fi

	if use txt; then
		# cp -r ${WORKDIR}/${P}/doc/text ${D}/usr/share/doc/mkdoc-9999/.
		einfo "--- Skipping dodoc for text format"
		#einfo "--- txt"
		#dodoc -r doc/text
	fi

	if use rtf; then
		# cp -r ${WORKDIR}/${P}/doc/rtf ${D}/usr/share/doc/mkdoc-9999/.
		einfo "--- rtf"
		dodoc -r doc/rtf
	fi

	if use tracwiki; then
		# cp -r ${WORKDIR}/${P}/doc/tracwiki ${D}/usr/share/doc/mkdoc-9999/.
		einfo "--- tracwiki"
		dodoc -r doc/tracwiki
	fi
}
