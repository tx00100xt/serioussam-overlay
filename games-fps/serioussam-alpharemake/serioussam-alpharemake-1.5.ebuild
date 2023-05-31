# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

MY_PN="serioussam"
MY_MOD="SSA"
# Game name
GN="serioussam"

DESCRIPTION="Serious Sam Classic The First Encounter Alpha Remake Modification"
HOMEPAGE="https://github.com/tx00100xt/SeriousSamAlphaRemake"
SRC_URI="https://github.com/tx00100xt/SeriousSamAlphaRemake/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/tx00100xt/${MY_PN}-mods/raw/main/SamTFE-${MY_MOD}/SeriousSamAlphaRemake_v1.5.tar.xz.partaa
	https://github.com/tx00100xt/${MY_PN}-mods/raw/main/SamTFE-${MY_MOD}/SeriousSamAlphaRemake_v1.5.tar.xz.partab
	https://github.com/tx00100xt/${MY_PN}-mods/raw/main/SamTFE-${MY_MOD}/SeriousSamAlphaRemake_v1.5.tar.xz.partac
	https://github.com/tx00100xt/${MY_PN}-mods/raw/main/SamTFE-${MY_MOD}/SeriousSamAlphaRemake_v1.5.tar.xz.partad"

MY_MOD_ARC="SeriousSamAlphaRemake_v1.5.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm64"
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
MY_CONTENT="${WORKDIR}/SeriousSamAlphaRemake-${PV}/SamTFE"

QA_TEXTRELS="
usr/lib/${GN}/Mods/${MY_MOD}/libEntities.so
usr/lib/${GN}/Mods/${MY_MOD}/libGame.so
usr/lib64/${GN}/Mods/${MY_MOD}/libEntities.so
usr/lib64/${GN}/Mods/${MY_MOD}/libGame.so
"

QA_FLAGS_IGNORED="
usr/lib/${GN}/Mods/${MY_MOD}/libEntities.so
usr/lib/${GN}/Mods/${MY_MOD}/libGame.so
usr/lib64/${GN}/Mods/${MY_MOD}/libEntities.so
usr/lib64/${GN}/Mods/${MY_MOD}/libGame.s
"

src_configure() {
    einfo "Setting build type Release..."
    CMAKE_BUILD_TYPE="Release"
    if use arm64
    then
        local mycmakeargs=(
            -DTFE=TRUE
            -DRPI4=TRUE
        )
    else
        local mycmakeargs=(
            -DTFE=TRUE
        )
    fi
    cmake_src_configure
}

src_install() {
    local dir="/usr/share/${GN}"
    if use x86; then
        local libdir="/usr/lib"
    else
        local libdir="/usr/lib64"
    fi

    # crerate install dirs
    mkdir "${D}/usr" && mkdir "${D}/usr/share" mkdir "${D}${libdir}"
    for gamedir in ${GN} ${GN}/Mods ${GN}/Mods/${MY_MOD}
    do
        mkdir "${D}${libdir}/${gamedir}" || die "Failed to create mod dir"
    done
    mkdir "${D}${dir}"

    # unpack mod content
    cat "${DISTDIR}/${MY_MOD_ARC}".part* > "${MY_MOD_ARC}"
    unpack ./"${MY_MOD_ARC}"
    mv Mods "${D}${dir}" || die "Failed to moved mod content"
    cp -fr "${dir}"/Scripts/CustomOptions/GFX-AdvancedRendering.cfg "${D}${dir}/Mods/${MY_MOD}"/Scripts/CustomOptions || die "Failed to copy "
    cp -fr "${FILESDIR}"/GFX-RenderingOptions.cfg "${D}${dir}/Mods/${MY_MOD}"/Scripts/CustomOptions || die "Failed to copy "

    # moving libs
    if use x86; then
        mv "${BUILD_DIR}"/Debug/libEntities.so "${D}/usr/lib/${GN}/Mods/${MY_MOD}" || die "Failed to moved libEntities.so"
        mv "${BUILD_DIR}"/Debug/libGame.so "${D}/usr/lib/${GN}/Mods/${MY_MOD}" || die "Failed to moved libGame.so"
        dosym "/usr/lib/${GN}/libamp11lib.so" "/usr/lib/${GN}/Mods/${MY_MOD}/libamp11lib.so"
    else
        mv "${BUILD_DIR}"/Debug/libEntities.so "${D}/usr/lib64/${GN}/Mods/${MY_MOD}" || die "Failed to moved libEntities.so"
        mv "${BUILD_DIR}"/Debug/libGame.so "${D}/usr/lib64/${GN}/Mods/${MY_MOD}" || die "Failed to moved libGame.so"
        dosym "/usr/lib64/${GN}/libamp11lib.so" "/usr/lib64/${GN}/Mods/${MY_MOD}/libamp11lib.so"
    fi
    # removing temp stuff
	rm -f  "${BUILD_DIR}"/{*.cmake,*.txt,*.a,*.ninja,.gitkeep} || die "Failed to removed temp stuff"
    rm -fr "${BUILD_DIR}"/Debug && rm -fr "${BUILD_DIR}"/CMakeFiles && rm -fr "${MY_CONTENT}"

	insinto /usr

}

pkg_postinst() {
	elog ""
	elog "     ************************************************"
	elog "     Serious Sam Alpha Remake Modifications installed"
	elog "     ************************************************"
	elog ""
    echo
}
