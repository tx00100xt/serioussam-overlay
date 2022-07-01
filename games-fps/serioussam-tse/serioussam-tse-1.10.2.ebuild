# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake desktop

MY_PN="SamTSE"

DESCRIPTION="Linux port of Serious Sam Classic The Second Encounter"
HOMEPAGE="https://github.com/tx00100xt/SeriousSamClassic"
SRC_URI="https://github.com/tx00100xt/SeriousSamClassic/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
RESTRICT="bindist mirror"
IUSE=""

RDEPEND="
    !games-fps/serioussam-tse-vk
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
usr/share/SamTSE/Bin/libEntitiesMP.so
usr/share/SamTSE/Bin/libGameMP.so
usr/share/SamTSE/Bin/libamp11lib.so
usr/share/SamTSE/Bin/libShaders.so
usr/share/SamTSE/Bin/libEngine.so
"

QA_FLAGS_IGNORED="
usr/share/SamTSE/Bin/libEntitiesMP.so
usr/share/SamTSE/Bin/libGameMP.so
usr/share/SamTSE/Bin/libamp11lib.so
usr/share/SamTSE/Bin/libShaders.so
usr/share/SamTSE/Bin/libEngine.so
usr/share/SamTSE/Bin/SeriousSam
usr/share/SamTSE/Bin/MakeFONT
usr/share/SamTSE/Bin/DedicatedServer
usr/share/SamTSE/Bin/ecc
"
PATCHES=(
	"${FILESDIR}/rparh_security_2.patch"
	"${FILESDIR}/gcc-11.3_fixed_mod_startup.patch"
)

src_configure() {
    einfo "Choosing the player's standard weapon..."
	rm -f "${MY_CONTENT}/Sources/EntitiesMP/PlayerWeapons.es" || die "Failed to removed PlayerWeapons.es"
    mv "${MY_CONTENT}/Sources/EntitiesMP/PlayerWeapons_old.es" "${MY_CONTENT}/Sources/EntitiesMP/PlayerWeapons.es" || die "Failed to moved PlayerWeapons.es"

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
    # moving libs 
    mv "${BUILD_DIR}"/Debug/* "${MY_CONTENT}"/Bin
    # removing temp stuff
	rm -f  "${BUILD_DIR}"/{*.cmake,*.txt,*.a,*.ninja,.gitkeep} || die "Failed to removed temp stuff"
    rm -fr "${BUILD_DIR}"/Debug && rm -fr "${BUILD_DIR}"/CMakeFiles && rm -fr "${MY_CONTENT}/Sources"
    # moving binares
    mv "${BUILD_DIR}"/* "${MY_CONTENT}"/Bin
    # moving content
    mv "${MY_CONTENT}" "${D}/usr/share"

    cp "${FILESDIR}/serioussam-tse.sh" "${D}/${dir}"
    cp "${FILESDIR}/ssam.xpm" "${D}/${dir}"
	insinto /usr/share

    cd "${D}/${dir}"
    newicon ssam.xpm ${MY_PN}.xpm

	make_wrapper ${MY_PN} ./serioussam-tse.sh "${dir}" "${dir}"
	make_desktop_entry ${MY_PN} "Serious Sam The Second Encounter" ${MY_PN}

}

pkg_postinst() {
	elog "     ***************************************************************************************"
	elog "     If you have access to a copy of the game (either by CD or through Steam),"
	elog "     you can copy the *.gro files to the /usr/share/SamTSE directory."
	elog "     /usr/share/SamTSE is the directory of the game Serious Sam Classic The Second Encounter"
	elog "     ***************************************************************************************"
	elog "     Copy all *.gro files and Help folder from the game directory to SamTSE directory."
	elog "     At the current time the files are:"
	elog "      - Help (folder)"
	elog "      - SE1_00.gro"
	elog "      - SE1_00_Extra.gro"
	elog "      - SE1_00_ExtraTools.gro"
	elog "      - SE1_00_Levels.gro"
	elog "      - SE1_00.gro"
	elog "      - SE1_00_Music.gro"
	elog "      - 1_04_patch.gro"
	elog "      - 1_07_patch.gro"
	elog "     ***************************************************************************************"
	elog "     You can also install:"
  	elog "                emerge serioussam-tse-data"
  	elog "     to extract game content from your CD or mounted image."
	elog "     ***************************************************************************************"
	elog "     Look at:"
	elog "        https://github.com/tx00100xt/serioussam-overlay/README.md"
	elog "     For information on the first launch of the game"
	elog ""
    echo
}
