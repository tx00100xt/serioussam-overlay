# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

MY_PN="SamTFE"

DESCRIPTION="Serious Sam Classic The First Encounter Alpha Remake Modification"
HOMEPAGE="https://github.com/tx00100xt/SeriousSamAlphaRemake"
SRC_URI="https://github.com/tx00100xt/SeriousSamAlphaRemake/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/tx00100xt/serioussam-mods/raw/main/SamTFE-SSA/SeriousSamAlphaRemake_v1.5.tar.xz.partaa
	https://github.com/tx00100xt/serioussam-mods/raw/main/SamTFE-SSA/SeriousSamAlphaRemake_v1.5.tar.xz.partab
	https://github.com/tx00100xt/serioussam-mods/raw/main/SamTFE-SSA/SeriousSamAlphaRemake_v1.5.tar.xz.partac
	https://github.com/tx00100xt/serioussam-mods/raw/main/SamTFE-SSA/SeriousSamAlphaRemake_v1.5.tar.xz.partad"

SSA_ARC="SeriousSamAlphaRemake_v1.5.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="bindist mirror"
IUSE=""

RDEPEND="
    || ( games-fps/serioussam-tfe-vk games-fps/serioussam-tfe )
	media-libs/libsdl2[alsa,video,joystick,opengl]
	media-libs/libvorbis
    sys-libs/zlib
	sys-devel/flex
    sys-devel/bison"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/SeriousSamAlphaRemake-${PV}/Sources"
MY_CONTENT="${WORKDIR}/SeriousSamAlphaRemake-${PV}/${MY_PN}"

QA_TEXTRELS="
usr/share/SamTFE/Mods/SSA/Bin/libEntities.so
usr/share/SamTFE/Mods/SSA/Bin/libGame.so
"

QA_FLAGS_IGNORED="
usr/share/SamTFE/Mods/SSA/Bin/libEntities.so
usr/share/SamTFE/Mods/SSA/Bin/libGame.so
"

src_configure() {
    einfo "Setting build type Release..."
    CMAKE_BUILD_TYPE="Release"
	local mycmakeargs=(
		-DTFE=TRUE
	)
	cmake_src_configure
}

src_install() {
    local dir="/usr/share/${MY_PN}"

    # crerate install dirs
    mkdir "${D}/usr" && mkdir "${D}/usr/share" && mkdir "${D}/usr/bin"

    mkdir "${D}${dir}"
    cat "${DISTDIR}/${SSA_ARC}".part* > "${SSA_ARC}"
    unpack ./"${SSA_ARC}"
    mv Mods "${D}${dir}" || die "Failed to moved mod content"

    # moving libs 
    mv "${BUILD_DIR}"/Debug/libEntities.so "${D}${dir}"/Mods/SSA/Bin || die "Failed to moved libEntities.so"
    mv "${BUILD_DIR}"/Debug/libGame.so "${D}${dir}"/Mods/SSA/Bin || die "Failed to moved libGame.so"
    # removing temp stuff
	rm -f  "${BUILD_DIR}"/{*.cmake,*.txt,*.a,*.ninja,.gitkeep} || die "Failed to removed temp stuff"
    rm -fr "${BUILD_DIR}"/Debug && rm -fr "${BUILD_DIR}"/CMakeFiles && rm -fr "${MY_CONTENT}"

	insinto /usr/share

}

pkg_postinst() {
	elog ""
	elog "     ************************************************"
	elog "     Serious Sam Alpha Remake Modifications installed"
	elog "     ************************************************"
	elog ""
    echo
}
