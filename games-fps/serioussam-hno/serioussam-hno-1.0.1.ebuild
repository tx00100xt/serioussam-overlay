# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

MY_PN="serioussamse"
MY_MOD="HNO"
# Game name
GN="serioussamse"

DESCRIPTION="Serious Sam Classic Hero Number One Modification"
HOMEPAGE="https://github.com/tx00100xt/SE1-TSE-HNO"
SRC_URI="https://github.com/tx00100xt/SE1-TSE-${MY_MOD}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://archive.org/download/hero-number-one/HeroNumberOne.tar.xz
	https://archive.org/download/hno-data-messages-eng/HNO-Data-messages-eng.tar.xz"

MY_MOD_ARC="HeroNumberOne.tar.xz"
MY_MOD_ENG_MESSAGES="HNO-Data-messages-eng.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm64"
RESTRICT="bindist mirror"
IUSE=""

RDEPEND="
    || ( games-fps/serioussam-tse-vk games-fps/serioussam-tse )
"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/SE1-TSE-${MY_MOD}-${PV}/Sources"
MY_CONTENT="${WORKDIR}/SE1-TSE-${MY_MOD}-${PV}/${MY_PN}"

QA_TEXTRELS="
usr/lib/${GN}/Mods/${MY_MOD}/libEntitiesMP.so
usr/lib/${GN}/Mods/${MY_MOD}/libGameM{.so
usr/lib64/${GN}/Mods/${MY_MOD}/libEntitiesMP.so
usr/lib64/${GN}/Mods/${MY_MOD}/libGameMP.so
"

QA_FLAGS_IGNORED="
usr/lib/${GN}/Mods/${MY_MOD}/libEntitiesMP.so
usr/lib/${GN}/Mods/${MY_MOD}/libGameM{.so
usr/lib64/${GN}/Mods/${MY_MOD}/libEntitiesMP.so
usr/lib64/${GN}/Mods/${MY_MOD}/libGameMP.so
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
    cat "${DISTDIR}/${MY_MOD_ARC}" > "${MY_MOD_ARC}"
    cat "${DISTDIR}/${MY_MOD_ENG_MESSAGES}" > "${MY_MOD_ENG_MESSAGES}"
    unpack ./"${MY_MOD_ARC}"
    unpack ./"${MY_MOD_ENG_MESSAGES}"
    # rm -fr Mods/HNO/Data
    # mv Data Mods/HNO/Data
    mv Mods "${D}${dir}" || die "Failed to moved mod content"

    # moving libs
    if use x86; then
        cp -f "${BUILD_DIR}"/Debug/libEntitiesMP.so "${D}/usr/lib/${GN}/Mods/${MY_MOD}/libEntitiesExtMP.so" || die "Failed to copy libEntitiesExtMPMP.so"
        mv "${BUILD_DIR}"/Debug/libEntitiesMP.so "${D}/usr/lib/${GN}/Mods/${MY_MOD}" || die "Failed to moved libEntitiesMP.so"
        mv "${BUILD_DIR}"/Debug/libGameMP.so "${D}/usr/lib/${GN}/Mods/${MY_MOD}" || die "Failed to moved libGameMP.so"
        dosym "/usr/lib/${GN}/libamp11lib.so" "/usr/lib/${GN}/Mods/${MY_MOD}/libamp11lib.so"
    else
        cp -f "${BUILD_DIR}"/Debug/libEntitiesMP.so "${D}/usr/lib64/${GN}/Mods/${MY_MOD}/libEntitiesExtMP.so" || die "Failed to copy libEntitiesExtMPMP.so"
        mv "${BUILD_DIR}"/Debug/libEntitiesMP.so "${D}/usr/lib64/${GN}/Mods/${MY_MOD}" || die "Failed to moved libEntitiesMP.so"
        mv "${BUILD_DIR}"/Debug/libGameMP.so "${D}/usr/lib64/${GN}/Mods/${MY_MOD}" || die "Failed to moved libGameMP.so"
        dosym "/usr/lib64/${GN}/libamp11lib.so" "/usr/lib64/${GN}/Mods/${MY_MOD}/libamp11lib.so"
    fi
    # removing temp stuff
	rm -f  "${BUILD_DIR}"/{*.cmake,*.txt,*.a,*.ninja,.gitkeep} || die "Failed to removed temp stuff"
    rm -fr "${BUILD_DIR}"/Debug && rm -fr "${BUILD_DIR}"/CMakeFiles && rm -fr "${MY_CONTENT}"

	insinto /usr

}

pkg_postinst() {
	elog ""
	elog "     ***************************************************"
	elog "     Serious Sam Hero Number One Modifications installed"
	elog "     ***************************************************"
	elog ""
    echo
}
