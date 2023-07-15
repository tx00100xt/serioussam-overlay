# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils unpacker

# Game name
GN="serioussamse"

DESCRIPTION="Serious Sam Classic Ancient Rome Next Encounter Mappack"
HOMEPAGE="https://archive.org/details/ne-ancient-rome"
SRC_URI="https://archive.org/download/ne-ancient-rome/NE_AncientRome.gro"

MY_MAPPACK_ARC="NE_AncientRome.gro"

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
    cat "${DISTDIR}/${MY_MAPPACK_ARC}" > "${MY_MAPPACK_ARC}"
    unpack ./"${MY_MOD_ARC}"
    mv "${MY_MAPPACK_ARC}" "${D}${dir}" || die "Failed to moved mappack content"

	insinto /usr
}

pkg_postinst() {
	elog ""
	elog "     *****************************************************************"
	elog "     Serious Sam Classic Ancient Rome Next Encounter Mappack installed"
	elog "     *****************************************************************"
	elog ""
    echo
}
