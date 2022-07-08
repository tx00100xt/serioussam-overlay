# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

MY_PN="SamTSE"

DESCRIPTION="Serious Sam Classic Dances World Modification"
HOMEPAGE="https://github.com/tx00100xt/SE1-TSE-DancesWorld"
SRC_URI="https://github.com/tx00100xt/SE1-TSE-DancesWorld/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/tx00100xt/serioussam-mods/raw/main/SamTSE-DancesWorld/SamTSE-DancesWorld.tar.xz"

DancesWorld_ARC="SamTSE-Tower.tar.xz"

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

S="${WORKDIR}/SE1-TSE-DancesWorld-${PV}/Sources"
MY_CONTENT="${WORKDIR}/SE1-TSE-DancesWorld-${PV}/${MY_PN}"

QA_TEXTRELS="
usr/share/SamTSE/Mods/DancesWorld/Bin/libEntitiesMP.so
usr/share/SamTSE/Mods/DancesWorld/Bin/libGameMP.so
"

QA_FLAGS_IGNORED="
usr/share/SamTSE/Mods/DancesWorld/Bin/libEntitiesMP.so
usr/share/SamTSE/Mods/DancesWorld/Bin/libGameMP.so
"

src_configure() {
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
    mv "${WORKDIR}"/Mods "${D}${dir}" || die "Failed to moved mod content"

    # moving libs 
    mv "${BUILD_DIR}"/Debug/libEntitiesMP.so "${D}${dir}"/Mods/DancesWorld/Bin || die "Failed to moved libEntities.so"
    mv "${BUILD_DIR}"/Debug/libGameMP.so "${D}${dir}"/Mods/DancesWorld/Bin || die "Failed to moved libGame.so"
    # removing temp stuff
	rm -f  "${BUILD_DIR}"/{*.cmake,*.txt,*.a,*.ninja,.gitkeep} || die "Failed to removed temp stuff"
    rm -fr "${BUILD_DIR}"/Debug && rm -fr "${BUILD_DIR}"/CMakeFiles && rm -fr "${MY_CONTENT}"

	insinto /usr/share

}

pkg_postinst() {
	elog ""
	elog "     ************************************************"
	elog "     Serious Sam Dances World Modifications installed"
	elog "     ************************************************"
	elog ""
    echo
}
