# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PN="serioussam"
MY_MOD="OddWorldHD"
# Game name
GN="serioussam"
# URL prefix
URL="https://github.com/tx00100xt/"

DESCRIPTION="Serious Sam Classic OddWorld Modification"
HOMEPAGE="https://github.com/tx00100xt/SE1-TFE-OddWorld"
SRC_URI="${URL}SE1-TFE-OddWorld/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${URL}${MY_PN}-mods/raw/main/SamTFE-OddWorld/SamTFE-OddWorld.tar.xz.partaa
	${URL}${MY_PN}-mods/raw/main/SamTFE-OddWorld/SamTFE-OddWorld.tar.xz.partab
	${URL}${MY_PN}-mods/raw/main/SamTFE-OddWorld/SamTFE-OddWorld.tar.xz.partac"
S="${WORKDIR}/SE1-TFE-OddWorld-${PV}/Sources"

MY_CONTENT="${WORKDIR}/SE1-TFE-OddWorld-${PV}/SamTFE"
MY_MOD_ARC="SamTFE-OddWorld.tar.xz"
MY_LIB1="libEntities.so"
MY_LIB2="libGame.so"

LICENSE="GPL-2 BSD ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="games-fps/serioussam"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	einfo "Setting build type Release..."
	CMAKE_BUILD_TYPE="Release"
	local mycmakeargs=(
		-DTFE=TRUE
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
	mkdir "${D}/usr" && mkdir "${D}/usr/share" mkdir "${D}${libdir}" \
		|| die "Failed create install dir"
	for gamedir in ${GN} ${GN}/Mods ${GN}/Mods/${MY_MOD}
	do
		mkdir "${D}${libdir}/${gamedir}" || die "Failed create mod dir"
	done
	mkdir "${D}${dir}" || die "Failed create install dir"

	# unpack mod content
	cat "${DISTDIR}/${MY_MOD_ARC}".part* > "${MY_MOD_ARC}" \
		|| die "Failed to copy archive"
	unpack ./"${MY_MOD_ARC}"
	mv Mods "${D}${dir}" || die "Failed to moved mod content"
	cp -fr "${D}${dir}"/Mods/${MY_MOD}/Controls/Controls0.ctl \
		"${D}${dir}"/Mods/${MY_MOD}/Controls/00-Default.ctl \
			|| die "Failed to moved Controls"

	# moving libs
	if use x86; then
		mv "${BUILD_DIR}"/Debug/${MY_LIB1} \
			"${D}/usr/lib/${GN}/Mods/${MY_MOD}" \
				|| die "Failed to moved ${MY_LIB1}"
		mv "${BUILD_DIR}"/Debug/${MY_LIB2} \
			"${D}/usr/lib/${GN}/Mods/${MY_MOD}" \
				|| die "Failed to moved ${MY_LIB2}"
	else
		mv "${BUILD_DIR}"/Debug/${MY_LIB1} \
			"${D}/usr/lib64/${GN}/Mods/${MY_MOD}" \
				|| die "Failed to moved ${MY_LIB1}"
		mv "${BUILD_DIR}"/Debug/${MY_LIB2} \
			"${D}/usr/lib64/${GN}/Mods/${MY_MOD}" \
				|| die "Failed to moved ${MY_LIB2}"
	fi

	# removing temp stuff
	rm -f  "${BUILD_DIR}"/{*.cmake,*.txt,*.a,*.ninja,.gitkeep} \
		|| die "Failed to removed temp stuff"
	rm -fr "${BUILD_DIR}"/Debug && rm -fr "${BUILD_DIR}"/CMakeFiles \
		&& rm -fr "${MY_CONTENT}" || die "Failed to removed temp stuff"
}

pkg_postinst() {
	elog "     Serious Sam OddWorld Modifications installed"
}
