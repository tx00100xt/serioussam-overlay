# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GN1U General Public License v2

EAPI=7

inherit cmake

MY_PN1="serioussam"
MY_PN2="serioussamse"
MY_MOD1="PEFE2"
MY_MOD2="PESE2"

# Game name
GN1="serioussam"
GN2="serioussamse"
# URL prefix
URL1="https://github.com/tx00100xt/"
URL2="https://github.com/tx00100xt/serioussam-mods/raw/main/"

DESCRIPTION="Serious Sam Classic Parse Error Modification"
HOMEPAGE="https://github.com/tx00100xt/SE1-ParseError"
SRC_URI="${URL1}/SE1-ParseError/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${URL2}SamTFE-ParseError/SamTFE-ParseError.tar.xz.partaa
	${URL2}SamTFE-ParseError/SamTFE-ParseError.tar.xz.partab
	${URL2}SamTFE-ParseError/SamTFE-ParseError.tar.xz.partac
	${URL2}SamTFE-ParseError/SamTFE-ParseError.tar.xz.partad
	${URL2}SamTFE-ParseError/SamTFE-ParseError.tar.xz.partae
	${URL2}SamTSE-ParseError/SamTSE-ParseError.tar.xz
"
S="${WORKDIR}/SE1-ParseError-${PV}/Sources"

MY_CONTENT1="${WORKDIR}/SE1-ParseError-${PV}/${MY_PN1}"
MY_CONTENT2="${WORKDIR}/SE1-ParseError-${PV}/${MY_PN2}"
MY_MOD1_ARC="SamTFE-ParseError.tar.xz"
MY_MOD2_ARC="SamTSE-ParseError.tar.xz"
MY_LIB1="libEntities.so"
MY_LIB2="libGame.so"
MY_LIB3="libEntitiesMP.so"
MY_LIB4="libGameMP.so"

LICENSE="GPL-2 BSD ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="games-fps/serioussam"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

BUILD_TMP=${BUILD_DIR}

src_configure() {
	einfo "Setting build type Release..."
	CMAKE_BUILD_TYPE="Release"
	BUILD_DIR="${BUILD_TMP}/XPLUS"
	einfo "Choosing the player's xplus weapon..."
	local mycmakeargs=(
		-DTFE=FALSE
		-DXPLUS=TRUE
	)
	cmake_src_configure

	einfo "Setting build type Release..."
	CMAKE_BUILD_TYPE="Release"
	BUILD_DIR="${BUILD_TMP}"
	einfo "Choosing the player's standart weapon..."
	local mycmakeargs=(
		-DTFE=FALSE
		-DXPLUS=FALSE
	)
	cmake_src_configure
}

src_compile() {
	einfo "Compiling with standart weapon..."
	cmake_src_compile

	einfo "Compiling with standart xplus weapon..."
	rm -f "${S}"/EntitiesMP/PlayerWeapons.es \
		|| die "Failed to removed PlayerWeapons.es"
	mv "${S}"/EntitiesMP/PlayerWeaponsHD.es \
		"${S}"/EntitiesMP/PlayerWeapons.es \
		|| die "Failed to moved PlayerWeapons.es"
	BUILD_DIR="${BUILD_TMP}/XPLUS"
	cmake_src_compile
}

src_install() {
	local dir1="/usr/share/${GN1}"
	local dir2="/usr/share/${GN2}"
	if use x86; then
		local libdir="/usr/lib"
	else
		local libdir="/usr/lib64"
	fi

	# crerate install dirs
	mkdir "${D}/usr" && mkdir "${D}/usr/share" mkdir "${D}${libdir}" \
		|| die "Failed create install dir"
	for gamedir in ${GN1} ${GN1}/Mods ${GN1}/Mods/${MY_MOD1}
	do
		mkdir "${D}${libdir}/${gamedir}" || die "Failed create mod dir"
	done
	for gamedir in ${GN2} ${GN2}/Mods ${GN2}/Mods/${MY_MOD2}
	do
		mkdir "${D}${libdir}/${gamedir}" || die "Failed create mod dir"
	done
	mkdir "${D}${dir1}" && mkdir "${D}${dir1}/Mods" \
		|| die "Failed to create mod dir"
	mkdir "${D}${dir2}" && mkdir "${D}${dir2}/Nods" \
		|| die "Failed to create mod dir"
	mkdir "${D}${libdir}/${GN1}/Mods/${MY_MOD1}HD" \
		|| die "Failed to create mod dir"
	mkdir "${D}${libdir}/${GN2}/Mods/${MY_MOD2}HD" \
		|| die "Failed to create mod dir"

	# unpack mod content
	cat "${DISTDIR}/${MY_MOD1_ARC}".part* > "${MY_MOD1_ARC}" \
		|| die "Failed to cp[y archive"
	cat "${DISTDIR}/${MY_MOD2_ARC}" > "${MY_MOD2_ARC}" \
		|| die "Failed to cp[y archive"
	cd "${D}${dir1}" || die "Failed to change dir"
	unpack "${S}/${MY_MOD1_ARC}" || die "Failed to unpack mod content"
	cd "${D}${dir2}" || die "Failed to change dir"
	unpack "${S}/${MY_MOD2_ARC}" || die "Failed to unpack mod content"

	# moving standart libs
	if use x86; then
		mv "${BUILD_TMP}/Debug/${MY_LIB1}" \
			"${D}/usr/lib/${GN1}/Mods/${MY_MOD1}" \
				|| die "Failed to moved libEntities.so"
		mv "${BUILD_TMP}/Debug/${MY_LIB2}" \
			"${D}/usr/lib/${GN1}/Mods/${MY_MOD1}" \
				|| die "Failed to moved libGame.so"
		mv "${BUILD_TMP}/Debug/${MY_LIB3}" \
			"${D}/usr/lib/${GN2}/Mods/${MY_MOD2}" \
				|| die "Failed to moved libEntitiesMP.so"
		mv "${BUILD_TMP}/Debug/${MY_LIB4}" \
			"${D}/usr/lib/${GN2}/Mods/${MY_MOD2}" \
				|| die "Failed to moved libGameMP.so"
	else
		mv "${BUILD_TMP}/Debug/${MY_LIB1}" \
			"${D}/usr/lib64/${GN1}/Mods/${MY_MOD1}" \
				|| die "Failed to moved libEntities.so"
		mv "${BUILD_TMP}/Debug/${MY_LIB2}" \
			"${D}/usr/lib64/${GN1}/Mods/${MY_MOD1}" \
				|| die "Failed to moved libGame.so"
		mv "${BUILD_TMP}/Debug/${MY_LIB3}" \
			"${D}/usr/lib64/${GN2}/Mods/${MY_MOD2}" \
				|| die "Failed to moved libEntitiesMP.so"
		mv "${BUILD_TMP}/Debug/${MY_LIB4}" \
			"${D}/usr/lib64/${GN2}/Mods/${MY_MOD2}" \
				|| die "Failed to moved libGameMP.so"
	fi

	# moving HD libs
	if use x86; then
		mv "${BUILD_DIR}/Debug/${MY_LIB1}" \
			"${D}/usr/lib/${GN1}/Mods/${MY_MOD1}HD" \
				|| die "Failed to moved libEntities.so"
		mv "${BUILD_DIR}/Debug/${MY_LIB2}" \
			"${D}/usr/lib/${GN1}/Mods/${MY_MOD1}HD" \
				|| die "Failed to moved libGame.so"
		mv "${BUILD_DIR}/Debug/${MY_LIB2}" \
			"${D}/usr/lib/${GN2}/Mods/${MY_MOD2}HD" \
				|| die "Failed to moved libEntitiesMP.so"
		mv "${BUILD_DIR}/Debug/${MY_LIB3}" \
			"${D}/usr/lib/${GN2}/Mods/${MY_MOD2}HD" \
				|| die "Failed to moved ibGameMP.so"
	else
		mv "${BUILD_DIR}/Debug/${MY_LIB1}" \
			"${D}/usr/lib64/${GN1}/Mods/${MY_MOD1}HD" \
				|| die "Failed to moved libEntities.so"
		mv "${BUILD_DIR}/Debug/${MY_LIB2}" \
			"${D}/usr/lib64/${GN1}/Mods/${MY_MOD1}HD" \
				|| die "Failed to moved libGame.so"
		mv "${BUILD_DIR}/Debug/${MY_LIB3}" \
			"${D}/usr/lib64/${GN2}/Mods/${MY_MOD2}HD" \
				|| die "Failed to moved libEntitiesMP.so"
		mv "${BUILD_DIR}/Debug/${MY_LIB4}" \
			"${D}/usr/lib64/${GN2}/Mods/${MY_MOD2}HD" \
				|| die "Failed to moved ibGameMP.so"
	fi

	# removing temp stuff
	rm -f  "${BUILD_DIR}"/{*.cmake,*.txt,*.a,*.ninja,.gitkeep} \
		|| die "Failed to remove temp stuff"
	rm -fr "${BUILD_DIR}"/Debug && rm -fr "${BUILD_DIR}"/CMakeFiles \
		|| die "Failed to remov temp stuff"
	rm -fr "${MY_CONTENT1}" && rm -fr "${MY_CONTENT2}" && rm -fr \
		"${BUILD_DIR}"/XPLUS || die "Failed remove temp stuff"
}

pkg_postinst() {
	elog "     Serious Sam Parse Error Modifications installed"
}
