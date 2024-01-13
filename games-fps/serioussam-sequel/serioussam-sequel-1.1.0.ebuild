# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GN1U General Public License v2

EAPI=7

inherit cmake

MY_MOD="TheSequel"
MY_DEP_LIB="ParametricParticles"
MY_DEP_LIB_VER="1.2.1"
# Game name
GN="serioussamse"
# URL prefix
URL1="https://github.com/tx00100xt/"
URL2="https://archive.org/download/"

DESCRIPTION="Serious Sam The Sequel Modification"
HOMEPAGE="https://github.com/tx00100xt/SE1-TSE-Sequel"
SRC_URI="${URL1}SE1-TSE-Sequel/archive/refs/tags/v${PV}-beta.tar.gz -> ${P}.tar.gz
	${URL1}SE1-${MY_DEP_LIB}/archive/refs/tags/v${MY_DEP_LIB_VER}.tar.gz -> ${MY_DEP_LIB}-${MY_DEP_LIB_VER}.tar.gz
	${URL2}sam-tse-sequel/SamTSE-Sequel.tar.xz"
TMP_S1="${WORKDIR}/SE1-TSE-Sequel-${PV}-beta/Sources"
TMP_S2="${WORKDIR}/SE1-${MY_DEP_LIB}-${MY_DEP_LIB_VER}/Sources"
S="${TMP_S1}"

MY_LIB1="libEntitiesMP.so"
MY_LIB2="libGameMP.so"
MY_LIB3="libParametricParticlesMP.so"

LICENSE="GPL-2+ BSD ZLIB"
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
	einfo "Configure Sequel..."
	BUILD_DIR="${BUILD_TMP}/Sequel"
	cmake_src_configure
	einfo "Configure Parametric Particles..."
	BUILD_DIR="${BUILD_TMP}/ParametricParticles"
	S="${TMP_S2}"
	CMAKE_USE_DIR="${TMP_S2}"
	cmake_src_configure
}

src_compile() {
	einfo "Compiling ParametricParticles ..."
	cmake_src_compile
	einfo "Compiling Sequel ..."
	S="${TMP_S1}"
	CMAKE_USE_DIR="${TMP_S1}"
	BUILD_DIR="${BUILD_TMP}/Sequel"
	cmake_src_compile
}

src_install() {
	local dir="/usr/share/${GN}"
	if use x86; then
		local libdir="/usr/lib"
	else
		local libdir="/usr/lib64"
	fi

	# crerate install dirs
	einfo "Crerate install dirs ..."
	mkdir "${D}/usr" && mkdir "${D}/usr/share" mkdir "${D}${libdir}" \
		|| die "Failed create install dir"
	for gamedir in ${GN} ${GN}/Mods ${GN}/Mods/${MY_MOD}
	do
		mkdir "${D}${libdir}/${gamedir}" || die "Failed create mod dir"
	done

	mkdir "${D}${dir}" && mkdir "${D}${dir}/Mods" \
		|| die "Failed to create mod dir"

	# moving mod libs
	einfo "Moving mod libs ..."
	if use x86; then
		mv "${BUILD_TMP}/ParametricParticles/Debug/${MY_LIB3}" \
			"${D}/usr/lib/${GN}/Mods/${MY_MOD}" \
				|| die "Failed to moved libParametricParticlesMP.so"
		mv "${BUILD_TMP}/Sequel/Debug/${MY_LIB1}" \
			"${D}/usr/lib/${GN}/Mods/${MY_MOD}" \
				|| die "Failed to moved libEntitiesMP.so"
		mv "${BUILD_TMP}/Sequel/Debug/${MY_LIB2}" \
			"${D}/usr/lib/${GN}/Mods/${MY_MOD}" \
				|| die "Failed to moved libGameMP.so"
	else
		mv "${BUILD_TMP}/ParametricParticles/Debug/${MY_LIB3}" \
			"${D}/usr/lib64/${GN}/Mods/${MY_MOD}" \
				|| die "Failed to moved libParametricParticlesMP.so"
		mv "${BUILD_TMP}/Sequel/Debug/${MY_LIB1}" \
			"${D}/usr/lib64/${GN}/Mods/${MY_MOD}" \
				|| die "Failed to moved libEntitiesMP.so"
		mv "${BUILD_TMP}/Sequel/Debug/${MY_LIB2}" \
			"${D}/usr/lib64/${GN}/Mods/${MY_MOD}" \
				|| die "Failed to moved libGameMP.so"
	fi

	# moving content
	mv "${WORKDIR}/Mods" "${D}${dir}" || die "Failed to moving content"
}

pkg_postinst() {
	elog "     Serious Sam The Sequel Modifications installed"
}
