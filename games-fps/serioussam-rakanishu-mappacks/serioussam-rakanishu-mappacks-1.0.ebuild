# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

# Game name
GN="serioussamse"

DESCRIPTION="Serious Sam Classic Rakanishu Mappacks"
HOMEPAGE="https://archive.org/details/cecil-bright-island"
SRC_URI="https://archive.org/download/se-coop-persepolis-and-teotihuacan-map-pack-v-2.020/SE_COOP_JacobsRest_ForModsEdition.gro
	https://archive.org/download/se-coop-persepolis-and-teotihuacan-map-pack-v-2.020/SE_COOP_Persepolis_Map_Pack_V2.020.gro
	https://archive.org/download/se-coop-persepolis-and-teotihuacan-map-pack-v-2.020/SE_COOP_Teotihuacan_Map_Pack_V2.020.gro"
S="${WORKDIR}"

MY_MAPPACK_ARC1="SE_COOP_JacobsRest_ForModsEdition.gro"
MY_MAPPACK_ARC2="SE_COOP_Persepolis_Map_Pack_V2.020.gro"
MY_MAPPACK_ARC3="SE_COOP_Teotihuacan_Map_Pack_V2.020.gro"

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
		|| die "Failed create install dir"
	mkdir "${D}${dir}" || die "Failed create install dir"

	# unpack mod content
	cat "${DISTDIR}/${MY_MAPPACK_ARC1}" > "${MY_MAPPACK_ARC1}" \
		|| die "Failed to copy archive"
	cat "${DISTDIR}/${MY_MAPPACK_ARC2}" > "${MY_MAPPACK_ARC2}" \
		|| die "Failed to copy archive"
	cat "${DISTDIR}/${MY_MAPPACK_ARC3}" > "${MY_MAPPACK_ARC3}" \
		|| die "Failed to copy archive"

	mv "${MY_MAPPACK_ARC1}" "${D}${dir}" || die "Failed move mappack content"
	mv "${MY_MAPPACK_ARC2}" "${D}${dir}" || die "Failed move mappack content"
	mv "${MY_MAPPACK_ARC3}" "${D}${dir}" || die "Failed move mappack content"
}

pkg_postinst() {
	elog "     Serious Sam Classic Rakanishu Mappacks installed"
}
