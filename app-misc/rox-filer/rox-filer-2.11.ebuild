# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils virtualx

DESCRIPTION="ROX-Filer a drag and drop spatial file manager"
HOMEPAGE="http://rox.sourceforge.net/desktop"
SRC_URI="mirror://sourceforge/rox/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE=""

COMMON_DEPEND="dev-lang/perl
	dev-libs/libxml2:2
	gnome-base/libglade:2.0
	x11-libs/gtk+:2"
RDEPEND="${COMMON_DEPEND}
	x11-misc/shared-mime-info"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

S="${WORKDIR}/${P}"/ROX-Filer/src

src_prepare() {
	epatch "${FILESDIR}/${P}-in-source-build.patch"

	sed -i -e 's:g_strdup(getenv("APP_DIR")):"/usr/share/rox":' \
		main.c || die "sed failed"
}

src_configure() {
	econf LIBS="-lm -ldl"
}

src_install() {
	cd "${WORKDIR}/${P}"/ROX-Filer || die
	dodir /usr/share/applications  /usr/share/pixmaps  /usr/share/rox/Help
	insinto /usr/share/rox
	doins -r Messages Options.xml ROX images style.css .DirIcon Templates.ui
	insinto /usr/share/rox/Help
	doins Help/*.html Help/README*

	doman ../rox.1

	newbin ROX-Filer rox

	dosym text-x-diff.png /usr/share/rox/ROX/MIME/text-x-patch.png
	dosym application-x-font-afm.png /usr/share/rox/ROX/MIME/application-x-font-type1.png
	dosym application-xml.png /usr/share/rox/ROX/MIME/application-xml-dtd.png
	dosym application-xml.png /usr/share/rox/ROX/MIME/application-xml-external-parsed-entity.png
	dosym application-xml.png /usr/share/rox/ROX/MIME/application-rdf+xml.png
	dosym application-xml.png /usr/share/rox/ROX/MIME/application-x-xbel.png
	dosym application-x-shellscript.png /usr/share/rox/ROX/MIME/application-javascript.png
	dosym application-x-bzip-compressed-tar.png /usr/share/rox/ROX/MIME/application-x-xz-compressed-tar.png
	dosym application-x-bzip-compressed-tar.png /usr/share/rox/ROX/MIME/application-x-lzma-compressed-tar.png
	dosym application-x-bzip-compressed-tar.png /usr/share/rox/ROX/MIME/application-x-lzo.png
	dosym application-x-bzip.png /usr/share/rox/ROX/MIME/application-x-xz.png
	dosym application-x-gzip.png /usr/share/rox/ROX/MIME/application-x-lzma.png
	dosym application-msword.png /usr/share/rox/ROX/MIME/application-rtf.png

	dosym ../rox/.DirIcon /usr/share/pixmaps/rox.png

	insinto /usr/share/applications
	doins   "${FILESDIR}"/rox.desktop
}
