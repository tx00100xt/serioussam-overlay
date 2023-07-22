# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

MY_PN="serioussamse"
MY_MOD="PESE2"
# Game name
GN="serioussamse"

DESCRIPTION="Serious Sam Classic Parse Error SE Modification"
HOMEPAGE="https://github.com/tx00100xt/SE1-ParseError"
SRC_URI="https://github.com/tx00100xt/SE1-ParseError/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/tx00100xt/serioussam-mods/raw/main/SamTSE-ParseError/SamTSE-ParseError.tar.xz"

MY_MOD_ARC="SamTSE-ParseError.tar.xz"
MY_LIB1="libEntitiesMP.so"
MY_LIB2="libGameMP.so"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
RESTRICT="bindist mirror"
IUSE=""

RDEPEND="
	|| ( games-fps/serioussam-tse-vk games-fps/serioussam-tse )
"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/SE1-ParseError-${PV}/Sources"
MY_CONTENT="${WORKDIR}/SE1-ParseError-${PV}/${MY_PN}"
BUILD_TMP=${BUILD_DIR}

src_configure() {
	einfo "Setting build type Release..."
	CMAKE_BUILD_TYPE="Release"
	local mycmakeargs=(
		-DTFE=FALSE
	)
	cmake_src_configure
	BUILD_DIR="${BUILD_TMP}/XPLUS"
	einfo "Setting build type Release..."
	CMAKE_BUILD_TYPE="Release"
	local mycmakeargs=(
		-DTFE=FALSE
	)
	cmake_src_configure
}

src_compile() {
	BUILD_DIR=${BUILD_TMP}
	cmake_src_compile
	einfo "Choosing the player's xplus weapon..."
	rm -f "${S}"/EntitiesMP/PlayerWeapons.es || die "Failed to removed PlayerWeapons.es"
	mv "${S}"/EntitiesMP/PlayerWeaponsHD.es "${S}"/EntitiesMP/PlayerWeapons.es || die "Failed to moved PlayerWeapons.es"
	BUILD_DIR="${BUILD_TMP}/XPLUS"
	cmake_src_compile
	BUILD_DIR=${BUILD_TMP}
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
	for gamedir in ${GN} ${GN}/Mods ${GN}/Mods/${MY_MOD} ${GN}/Mods/${MY_MOD}HD
	do
		mkdir "${D}${libdir}/${gamedir}" || die "Failed to create mod dir"
	done
	mkdir "${D}${dir}"

	# unpack mod content
	cat "${DISTDIR}/${MY_MOD_ARC}" > "${MY_MOD_ARC}"
	unpack ./"${MY_MOD_ARC}"
	mv Mods "${D}${dir}" || die "Failed to moved mod content"

	# moving standart libs
	if use x86; then
		mv "${BUILD_DIR}"/Debug/${MY_LIB1} "${D}/usr/lib/${GN}/Mods/${MY_MOD}" || die "Failed to moved libEntitiesMP.so"
		mv "${BUILD_DIR}"/Debug/${MY_LIB2} "${D}/usr/lib/${GN}/Mods/${MY_MOD}" || die "Failed to moved libGameMP.so"
	else
		mv "${BUILD_DIR}"/Debug/${MY_LIB1} "${D}/usr/lib64/${GN}/Mods/${MY_MOD}" || die "Failed to moved libEntitiesMP.so"
		mv "${BUILD_DIR}"/Debug/${MY_LIB2} "${D}/usr/lib64/${GN}/Mods/${MY_MOD}" || die "Failed to moved libGameMP.so"
	fi

	# moving HD libs
	if use x86; then
		mv "${BUILD_DIR}"/XPLUS/Debug/${MY_LIB1} \
			"${D}/usr/lib/${GN}/Mods/${MY_MOD}HD"/${MY_LIB1} || die "Failed to moved libEntitiesMP.so"
		mv "${BUILD_DIR}"/XPLUS/Debug/${MY_LIB2} \
			"${D}/usr/lib/${GN}/Mods/${MY_MOD}HD"/${MY_LIB2} || die "Failed to moved libGameMP.so"
	else
		mv "${BUILD_DIR}"/XPLUS/Debug/${MY_LIB1} \
			"${D}/usr/lib64/${GN}/Mods/${MY_MOD}HD"/${MY_LIB1} || die "Failed to moved libEntitiesMP.so"
		mv "${BUILD_DIR}"/XPLUS/Debug/${MY_LIB2} \
			"${D}/usr/lib64/${GN}/Mods/${MY_MOD}HD"/${MY_LIB2} || die "Failed to moved libGameMP.so"
	fi

	# removing temp stuff
	rm -f  "${BUILD_DIR}"/{*.cmake,*.txt,*.a,*.ninja,.gitkeep} || die "Failed to removed temp stuff"
	rm -fr "${BUILD_DIR}"/Debug && rm -fr "${BUILD_DIR}"/CMakeFiles && rm -fr "${MY_CONTENT}"
	rm -fr "${BUILD_DIR}"/XPLUS

	insinto /usr

}

pkg_postinst() {
	elog ""
	elog "     **************************************************"
	elog "     Serious Sam Parse Error SE Modifications installed"
	elog "     **************************************************"
	elog ""
	echo
}
