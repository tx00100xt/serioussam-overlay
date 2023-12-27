# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

# Game name
GN="serioussamse"

DESCRIPTION="Serious Sam Classic Ancient Rome Next Encounter Mappack"
HOMEPAGE="https://archive.org/details/ne-ancient-rome"
SRC_URI="https://archive.org/download/ne-ancient-rome/NE_AncientRome.gro"
S="${WORKDIR}"

MY_MAPPACK_ARC="NE_AncientRome.gro"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="games-fps/serioussam"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_install() {
	local dir="/usr/share/${GN}"

	# crerate install dirs
	mkdir "${D}/usr" && mkdir "${D}/usr/share" \
		|| die "Failed create install dirs"
	mkdir "${D}${dir}" || die "Failed create install dirs"

	# unpack mod content
	cat "${DISTDIR}/${MY_MAPPACK_ARC}" > "${MY_MAPPACK_ARC}" \
		|| die "Failed copy archive"
	unpack ./"${MY_MOD_ARC}"
	mv "${MY_MAPPACK_ARC}" "${D}${dir}" \
		|| die "Failed to moved mappack content"
}

pkg_postinst() {
	elog "     Serious Sam Classic Ancient Rome Next Encounter Mappack installed"
}
