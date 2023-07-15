# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils unpacker

# Game name
GN="serioussamse"

DESCRIPTION="Serious Sam Classic Rakanishu Mappacks"
HOMEPAGE="https://archive.org/details/cecil-bright-island"
SRC_URI="https://archive.org/download/se-coop-persepolis-and-teotihuacan-map-pack-v-2.020/SE_COOP_JacobsRest_ForModsEdition.gro
	https://archive.org/download/se-coop-persepolis-and-teotihuacan-map-pack-v-2.020/SE_COOP_Persepolis_Map_Pack_V2.020.gro
	https://archive.org/download/se-coop-persepolis-and-teotihuacan-map-pack-v-2.020/SE_COOP_Teotihuacan_Map_Pack_V2.020.gro"

MY_MAPPACK_ARC1="SE_COOP_JacobsRest_ForModsEdition.gro"
MY_MAPPACK_ARC2="SE_COOP_Persepolis_Map_Pack_V2.020.gro"
MY_MAPPACK_ARC3="SE_COOP_Teotihuacan_Map_Pack_V2.020.gro"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm64"
RESTRICT="bindist mirror"
IUSE=""

RDEPEND="
    || ( games-fps/serioussam-tse-vk games-fps/serioussam-tse )
"

S="${WORKDIR}"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"


src_install() {
    local dir="/usr/share/${GN}"

    # crerate install dirs
    mkdir "${D}/usr" && mkdir "${D}/usr/share" 
    mkdir "${D}${dir}"

    # unpack mod content
    cat "${DISTDIR}/${MY_MAPPACK_ARC1}" > "${MY_MAPPACK_ARC1}"
    cat "${DISTDIR}/${MY_MAPPACK_ARC2}" > "${MY_MAPPACK_ARC2}"
    cat "${DISTDIR}/${MY_MAPPACK_ARC3}" > "${MY_MAPPACK_ARC3}"

    mv "${MY_MAPPACK_ARC1}" "${D}${dir}" || die "Failed to moved mappack content"
    mv "${MY_MAPPACK_ARC2}" "${D}${dir}" || die "Failed to moved mappack content"
    mv "${MY_MAPPACK_ARC3}" "${D}${dir}" || die "Failed to moved mappack content"

	insinto /usr
}

pkg_postinst() {
	elog ""
	elog "     ************************************************"
	elog "     Serious Sam Classic Rakanishu Mappacks installed"
	elog "     ************************************************"
	elog ""
    echo
}
