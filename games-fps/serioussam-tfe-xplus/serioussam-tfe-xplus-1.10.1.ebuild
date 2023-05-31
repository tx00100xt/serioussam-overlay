# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

MY_PN="SamTFE"
# Game name
GN="serioussam"

DESCRIPTION="Serious Sam Classic The First Encounter XPLUS Modification"
HOMEPAGE="https://github.com/tx00100xt/SeriousSamClassic"
SRC_URI="https://github.com/tx00100xt/SeriousSamClassic/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/tx00100xt/serioussam-mods/raw/main/SamTFE-XPLUS/SamTFE-XPLUS.tar.xz.partaa
	https://github.com/tx00100xt/serioussam-mods/raw/main/SamTFE-XPLUS/SamTFE-XPLUS.tar.xz.partab
	https://github.com/tx00100xt/serioussam-mods/raw/main/SamTFE-XPLUS/SamTFE-XPLUS.tar.xz.partac"

XPLUS_ARC="SamTFE-XPLUS.tar.xz"

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

S="${WORKDIR}/SeriousSamClassic-${PV}/${MY_PN}/Sources"
MY_CONTENT="${WORKDIR}/SeriousSamClassic-${PV}/${MY_PN}"

QA_TEXTRELS="
usr/lib/${GN}/Mods/XPLUS/Bin/libEntities.so
usr/lib/${GN}/XPLUS/Bin/libGame.so
usr/lib64/${GN}/Mods/XPLUS/Bin/libEntities.so
usr/lib64/${GN}/XPLUS/Bin/libGame.so
"

QA_FLAGS_IGNORED="
usr/lib/${GN}/Mods/XPLUS/Bin/libEntities.so
usr/lib/${GN}/XPLUS/Bin/libGame.so
usr/lib64/${GN}/Mods/XPLUS/Bin/libEntities.so
usr/lib64/${GN}/XPLUS/Bin/libGame.so
"

PATCHES=(
	"${FILESDIR}/rparh_security.patch"
	"${FILESDIR}/fixed_broken_timer.patch"
	"${FILESDIR}/critical_section_multitread.patch"
	"${FILESDIR}/fix-thunder.patch"
)



src_configure() {
    einfo "Choosing the player's xplus weapon..."
    rm -f "${S}"/Sources/Entities/PlayerWeapons.es || die "Failed to removed PlayerWeapons.es"
    mv "${S}"/Entities/PlayerWeaponsHD.es "${S}"/Entities/PlayerWeapons.es || die "Failed to moved PlayerWeapons.es"

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

    # crerate install dirs
    mkdir "${D}/usr" && mkdir "${D}/usr/share" && mkdir "${D}${dir}"
	if use x86; then
    	mkdir "${D}/usr/lib" && mkdir "${D}/usr/lib/${GN}"  && mkdir "${D}/usr/lib/${GN}/Mods"
    else
    	mkdir "${D}/usr/lib64" && mkdir "${D}/usr/lib64/${GN}"  && mkdir "${D}/usr/lib64/${GN}/Mods"
    fi

    # moving libs
 	if use x86; then
        mkdir "${D}/usr/lib/${GN}/Mods/XPLUS"
        mv "${BUILD_DIR}"/Debug/libEntities.so "${D}/usr/lib/${GN}/Mods/XPLUS" || die "Failed to moved libEntities.so"
        mv "${BUILD_DIR}"/Debug/libGame.so "${D}/usr/lib/${GN}/Mods/XPLUS" || die "Failed to moved libGame.so"
        dosym "/usr/lib/${GN}/libamp11lib.so" "/usr/lib/${GN}/Mods/XPLUS/libamp11lib.so"
    else
    	mkdir "${D}/usr/lib64/${GN}/Mods/XPLUS"
        mv "${BUILD_DIR}"/Debug/libEntities.so "${D}/usr/lib64/${GN}/Mods/XPLUS" || die "Failed to moved libEntities.so"
        mv "${BUILD_DIR}"/Debug/libGame.so "${D}/usr/lib64/${GN}/Mods/XPLUS" || die "Failed to moved libGame.so"
        dosym "/usr/lib64/${GN}/libamp11lib.so" "/usr/lib64/${GN}/Mods/XPLUS/libamp11lib.so"
    fi

    mkdir "${D}${dir}"
    cat "${DISTDIR}/${XPLUS_ARC}".part* > "${XPLUS_ARC}"
    unpack ./"${XPLUS_ARC}"
    # moving xplus 
    mv "${S}"/Mods "${D}${dir}" || die "Failed to moved XPLUS content"

    # removing temp stuff
	rm -f  "${BUILD_DIR}"/{*.cmake,*.txt,*.a,*.ninja,.gitkeep} || die "Failed to removed temp stuff"
    rm -fr "${BUILD_DIR}"/Debug && rm -fr "${BUILD_DIR}"/CMakeFiles && rm -fr "${MY_CONTENT}"
	rm -f  "${D}${dir}"/Mods/XPLUS.des || die "Failed to removed temp stuff"
    rm -f  "${D}${dir}"/Mods/XPLUSTbn.tex || die "Failed to removed temp stuff"

	insinto /usr
}

pkg_postinst() {
	elog ""
	elog "     *************************************************************"
	elog "     Serious Sam The First Encounter XPLUS Modifications installed"
	elog "     *************************************************************"
	elog ""
    echo
}
