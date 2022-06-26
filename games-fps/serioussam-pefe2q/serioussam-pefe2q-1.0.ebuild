# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

MY_PN="SamTFE"

DESCRIPTION="Serious Sam Classic Parse Error FE Modification"
HOMEPAGE="https://github.com/tx00100xt/SE1-ParseError"
SRC_URI="https://github.com/tx00100xt/SE1-ParseError/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/tx00100xt/serioussam-mods/raw/main/SamTFE-ParseError/SamTFE-ParseError.tar.xz.partaa
	https://github.com/tx00100xt/serioussam-mods/raw/main/SamTFE-ParseError/SamTFE-ParseError.tar.xz.partab
	https://github.com/tx00100xt/serioussam-mods/raw/main/SamTFE-ParseError/SamTFE-ParseError.tar.xz.partac
	https://github.com/tx00100xt/serioussam-mods/raw/main/SamTFE-ParseError/SamTFE-ParseError.tar.xz.partad
	https://github.com/tx00100xt/serioussam-mods/raw/main/SamTFE-ParseError/SamTFE-ParseError.tar.xz.partae
"

PEFE2_ARC="SamTFE-ParseError.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
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

S="${WORKDIR}/SE1-ParseError-${PV}/Sources"
MY_CONTENT="${WORKDIR}/SE1-ParseError-${PV}/${MY_PN}"

QA_TEXTRELS="
usr/share/SamTSE/Mods/PEFE2/Bin/libEntities.so
usr/share/SamTSE/Mods/PEFE2/Bin/libGame.so
usr/share/SamTSE/Mods/PEFE2HD/Bin/libEntities.so
usr/share/SamTSE/Mods/PEFE2HD/Bin/libGame.so
"

QA_FLAGS_IGNORED="
usr/share/SamTSE/Mods/PEFE2/Bin/libEntities.so
usr/share/SamTSE/Mods/PEFE2/Bin/libGame.so
usr/share/SamTSE/Mods/PEFE2HD/Bin/libEntities.so
usr/share/SamTSE/Mods/PEFE2HD/Bin/libGame.so
"

src_configure() {
    einfo "Choosing the player's standart weapon..."
	rm -f "${S}/EntitiesMP/PlayerWeapons.es" || die "Failed to removed PlayerWeapons.es"
    mv "${S}/EntitiesMP/PlayerWeapons_old.es" "${S}/EntitiesMP/PlayerWeapons.es" || die "Failed to moved PlayerWeapons.es"

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
    cat "${DISTDIR}/${PEFE2_ARC}".part* > "${PEFE2_ARC}"
    unpack ./"${PEFE2_ARC}"
    mv Mods "${D}${dir}" || die "Failed to moved mod content"

    # moving libs 
    mv "${BUILD_DIR}"/Debug/libEntitiesMP.so "${D}${dir}"/Mods/PEFE2/Bin/libEntities.so || die "Failed to moved libEntities.so"
    mv "${BUILD_DIR}"/Debug/libGameMP.so "${D}${dir}"/Mods/PEFE2/Bin/libGame.so  || die "Failed to moved libGame.so"

    # build HD
    einfo "Choosing the player's xplus weapon..."
	rm -f "${S}"/Sources/EntitiesMP/PlayerWeapons.es || die "Failed to removed PlayerWeapons.es"
    mv "${S}"/EntitiesMP/PlayerWeaponsHD.es "${S}"/EntitiesMP/PlayerWeapons.es || die "Failed to moved PlayerWeapons.es"
    cd "${S}"
    rm -fr cmake-build
    mkdir cmake-build && cd cmake-build
    cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo ..
    make -j4

    # moving libs 
    mv "${S}"/cmake-build/Debug/libEntitiesMP.so "${D}${dir}"/Mods/PEFE2HD/Bin/libEntities.so || die "Failed to moved libEntities.so"
    mv "${S}"/cmake-build/Debug/libGameMP.so "${D}${dir}"/Mods/PEFE2HD/Bin/libGame.so  || die "Failed to moved libGame.so"

    # removing temp stuff
	rm -f  "${BUILD_DIR}"/{*.cmake,*.txt,*.a,*.ninja,.gitkeep} || die "Failed to removed temp stuff"
    rm -fr "${BUILD_DIR}"/Debug && rm -fr "${BUILD_DIR}"/CMakeFiles && rm -fr "${MY_CONTENT}"

	insinto /usr/share

}

pkg_postinst() {
	elog ""
	elog "     **************************************************"
	elog "     Serious Sam Parse Error SE Modifications installed"
	elog "     **************************************************"
	elog ""
    echo
}
