# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

MY_PN="SamTSE"

DESCRIPTION="Serious Sam Classic The Second Encounter XPLUS Modification"
HOMEPAGE="https://github.com/tx00100xt/SeriousSamClassic"
SRC_URI="https://github.com/tx00100xt/SeriousSamClassic/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/tx00100xt/serioussam-mods/raw/main/SamTSE-XPLUS/SamTSE-XPLUS.tar.xz.partaa
	https://github.com/tx00100xt/serioussam-mods/raw/main/SamTSE-XPLUS/SamTSE-XPLUS.tar.xz.partab
	https://github.com/tx00100xt/serioussam-mods/raw/main/SamTSE-XPLUS/SamTSE-XPLUS.tar.xz.partac"

XPLUS_ARC="SamTSE-XPLUS.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="bindist mirror"
IUSE=""

RDEPEND="
    || ( games-fps/serioussam-tse-vk games-fps/serioussam-tse )
	media-libs/libsdl2[alsa,video,joystick,opengl]
	media-libs/libvorbis
    sys-libs/zlib
	sys-devel/flex
    sys-devel/bison"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/SeriousSamClassic-${PV}/${MY_PN}/Sources"
MY_CONTENT="${WORKDIR}/SeriousSamClassic-${PV}/${MY_PN}"

QA_TEXTRELS="
usr/share/SamTFE/Mods/XPLUS/Bin/libEntitiesMP.so
usr/share/SamTFE/Mods/XPLUS/Bin/libGameMP.so
"

QA_FLAGS_IGNORED="
usr/share/SamTFE/Mods/XPLUS/Bin/libEntitiesMP.so
usr/share/SamTFE/Mods/XPLUS/Bin/libGameMP.so
"

PATCHES=(
	"${FILESDIR}/rparh_security.patch"
	"${FILESDIR}/fixed_broken_timer.patch"
	"${FILESDIR}/critical_section_multitread.patch"
)



src_configure() {
    einfo "Choosing the player's xplus weapon..."
	rm -f "${MY_CONTENT}/Sources/EntitiesMP/PlayerWeapons.es" || die "Failed to removed PlayerWeapons.es"
    mv "${MY_CONTENT}/Sources/EntitiesMP/PlayerWeaponsHD.es" "${MY_CONTENT}/Sources/EntitiesMP/PlayerWeapons.es" || die "Failed to moved PlayerWeapons.es"

    einfo "Setting build type Release..."
    CMAKE_BUILD_TYPE="Release"
	local mycmakeargs=(
		-DTFE=FALSE
	)
	cmake_src_configure
}

src_install() {
    local dir="/usr/share/${MY_PN}"

    # crerate install dirs
    mkdir "${D}/usr" && mkdir "${D}/usr/share" && mkdir "${D}/usr/bin"

    mkdir "${D}${dir}"
    cat "${DISTDIR}/${XPLUS_ARC}".part* > "${XPLUS_ARC}"
    unpack ./"${XPLUS_ARC}"
    mv Mods "${D}${dir}" || die "Failed to moved mod content"

    # moving libs 
    mv "${BUILD_DIR}"/Debug/libEntitiesMP.so "${D}${dir}"/Mods/XPLUS/Bin || die "Failed to moved libEntitiesMP.so"
    mv "${BUILD_DIR}"/Debug/libGameMP.so "${D}${dir}"/Mods/XPLUS/Bin || die "Failed to moved libGameMP.so"
    # removing temp stuff
	rm -f  "${BUILD_DIR}"/{*.cmake,*.txt,*.a,*.ninja,.gitkeep} || die "Failed to removed temp stuff"
    rm -fr "${BUILD_DIR}"/Debug && rm -fr "${BUILD_DIR}"/CMakeFiles && rm -fr "${MY_CONTENT}"
	rm -f  "${D}${dir}"/Mods/XPLUS.des || die "Failed to removed temp stuff"
    rm -f  "${D}${dir}"/Mods/XPLUSTbn.tex || die "Failed to removed temp stuff"

	insinto /usr/share

}

pkg_postinst() {
	elog ""
	elog "     *************************************************************"
	elog "     Serious Sam The Second Encounter XPLUS Modifications installed"
	elog "     *************************************************************"
	elog ""
    echo
}
