# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit unpacker

# Game name
GN="serioussamse"

DESCRIPTION="Serious Sam Classic Bright Island Mappack"
HOMEPAGE="https://archive.org/details/cecil-bright-island-1.1"
SRC_URI="https://archive.org/download/cecil-bright-island-1.1/CECIL_BrightIsland_1.1.gro"

MY_MAPPACK_ARC="CECIL_BrightIsland_1.1.gro"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
RESTRICT="bindist mirror"
IUSE=""

RDEPEND="
	|| ( games-fps/serioussam-vk games-fps/serioussam )
"

S="${WORKDIR}"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_unpack() {
	mkdir Levels Mods
	cat "${DISTDIR}/${MY_MAPPACK_ARC}" > "${MY_MAPPACK_ARC}"
}

src_install() {
	local dir="/usr/share/${GN}"

	# crerate install dirs
	mkdir "${D}/usr" && mkdir "${D}/usr/share"
	mkdir "${D}${dir}"

	# unpack mod content
	cat "${DISTDIR}/${MY_MAPPACK_ARC}" > "${MY_MAPPACK_ARC}"
	mv "${MY_MAPPACK_ARC}" "${D}${dir}" || die "Failed to moved mappack content"

	insinto /usr
}

pkg_postinst() {
	elog ""
	elog "     ***************************************************"
	elog "     Serious Sam Classic Bright Island Mappack installed"
	elog "     ***************************************************"
	elog ""
	echo
}
