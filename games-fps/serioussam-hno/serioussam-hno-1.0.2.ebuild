# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PN="serioussamse"
MY_MOD="HNO"
# Game name
GN="serioussamse"
# URL prefix
URL1="https://github.com/tx00100xt/"
URL2="https://archive.org/download/"

DESCRIPTION="Serious Sam Classic Hero Number One Modification"
HOMEPAGE="https://github.com/tx00100xt/SE1-TSE-HNO"
SRC_URI="${URL1}SE1-TSE-${MY_MOD}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${URL2}hero-number-one/HeroNumberOne.tar.xz
	${URL2}hno-data-messages-eng/HNO-Data-messages-eng.tar.xz"
S="${WORKDIR}/SE1-TSE-${MY_MOD}-${PV}/Sources"

MY_CONTENT="${WORKDIR}/SE1-TSE-${MY_MOD}-${PV}/${MY_PN}"
MY_MOD_ARC="HeroNumberOne.tar.xz"
MY_MOD_ENG_MESSAGES="HNO-Data-messages-eng.tar.xz"
MY_LIB1="libEntitiesMP.so"
MY_LIB2="libGameMP.so"

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
	mkdir "${D}/usr" && mkdir "${D}/usr/share" mkdir "${D}${libdir}" \
		|| die "Failed create install dir"
	for gamedir in ${GN} ${GN}/Mods ${GN}/Mods/${MY_MOD}
	do
		mkdir "${D}${libdir}/${gamedir}" || die "Failed create mod dir"
	done
	mkdir "${D}${dir}" || die "Failed create install dir"

	# unpack mod content
	cat "${DISTDIR}/${MY_MOD_ARC}" > "${MY_MOD_ARC}" \
		|| die "Failed to copy archive"
	cat "${DISTDIR}/${MY_MOD_ENG_MESSAGES}" > "${MY_MOD_ENG_MESSAGES}" \
		|| die "Failed to copy archive"
	unpack ./"${MY_MOD_ARC}"
	unpack ./"${MY_MOD_ENG_MESSAGES}"
	# rm -fr Mods/HNO/Data
	# mv Data Mods/HNO/Data
	mv Mods "${D}${dir}" || die "Failed to moved mod content"

	# moving libs
	if use x86; then
		cp -f "${BUILD_DIR}"/Debug/${MY_LIB1} \
			"${D}/usr/lib/${GN}/Mods/${MY_MOD}/libEntitiesExtMP.so" \
				|| die "Failed to copy libEntitiesExtMP.so"
		mv "${BUILD_DIR}"/Debug/${MY_LIB1} \
			"${D}/usr/lib/${GN}/Mods/${MY_MOD}" \
				|| die "Failed to moved ${MY_LIB1}"
		mv "${BUILD_DIR}"/Debug/${MY_LIB2} \
			"${D}/usr/lib/${GN}/Mods/${MY_MOD}" \
				|| die "Failed to moved ${MY_LIB2}"
	else
		cp -f "${BUILD_DIR}"/Debug/${MY_LIB1} \
			"${D}/usr/lib64/${GN}/Mods/${MY_MOD}/libEntitiesExtMP.so" \
				|| die "Failed to copy libEntitiesExtMP.so"
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
	elog "     Serious Sam Hero Number One Modifications installed"
}
