# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

# Game name
GN="serioussamse"
# URL prefix
URL="https://archive.org/"

DESCRIPTION="Serious Sam Classic Bright Island Mappack"
HOMEPAGE="${URL}details/cecil-bright-island-1.1"
SRC_URI="${URL}download/cecil-bright-island-1.1/CECIL_BrightIsland_1.1.gro"
S="${WORKDIR}"

MY_MAPPACK_ARC="CECIL_BrightIsland_1.1.gro"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="games-fps/serioussam"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_unpack() {
	mkdir Levels Mods || die "Failed create Levels Mods dirs"
	cat "${DISTDIR}/${MY_MAPPACK_ARC}" > "${MY_MAPPACK_ARC}" \
		|| die "Failed copy archive"
}

src_install() {
	local dir="/usr/share/${GN}"

	# crerate install dirs
	mkdir "${D}/usr" && mkdir "${D}/usr/share" \
		|| die "Failed create install dirs"
	mkdir "${D}${dir}" || die "Failed create install dirs"

	# unpack mod content
	cat "${DISTDIR}/${MY_MAPPACK_ARC}" > "${MY_MAPPACK_ARC}" \
		|| die "Failed copy archive"
	mv "${MY_MAPPACK_ARC}" "${D}${dir}" \
		|| die "Failed to moved mappack content"
}

pkg_postinst() {
	elog "     Serious Sam Classic Bright Island Mappack installed"
}
