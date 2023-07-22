# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

MY_PN="serioussam"
MY_MOD="PEFE2"
# Game name
GN="serioussam"

DESCRIPTION="Serious Sam Classic Parse Error FE Modification"
HOMEPAGE="https://github.com/tx00100xt/SE1-ParseError"
SRC_URI="https://github.com/tx00100xt/SE1-ParseError/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/tx00100xt/serioussam-mods/raw/main/SamTFE-ParseError/SamTFE-ParseError.tar.xz.partaa
	https://github.com/tx00100xt/serioussam-mods/raw/main/SamTFE-ParseError/SamTFE-ParseError.tar.xz.partab
	https://github.com/tx00100xt/serioussam-mods/raw/main/SamTFE-ParseError/SamTFE-ParseError.tar.xz.partac
	https://github.com/tx00100xt/serioussam-mods/raw/main/SamTFE-ParseError/SamTFE-ParseError.tar.xz.partad
	https://github.com/tx00100xt/serioussam-mods/raw/main/SamTFE-ParseError/SamTFE-ParseError.tar.xz.partae
"

MY_MOD_ARC="SamTFE-ParseError.tar.xz"
MY_LIB1="libEntities.so"
MY_LIB2="libGame.so"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
RESTRICT="bindist mirror"
IUSE=""

RDEPEND="
	|| ( games-fps/serioussam-tfe-vk games-fps/serioussam-tfe )
"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/SE1-ParseError-${PV}/Sources"
MY_CONTENT="${WORKDIR}/SE1-ParseError-${PV}/${MY_PN}"
BUILD_TMP=${BUILD_DIR}

PATCHES=(
	"${FILESDIR}/0001-CMakeLists.patch"
)

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
	rm -f "${S}"/EntitiesMP/PlayerWeapons.es || die "Failed to removed PlayerWeapons.es"
	mv "${S}"/EntitiesMP/PlayerWeaponsHD.es "${S}"/EntitiesMP/PlayerWeapons.es || die "Failed to moved PlayerWeapons.es"
	BUILD_DIR="${BUILD_TMP}/XPLUS"
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
	mkdir "${D}/usr" && mkdir "${D}/usr/share" mkdir "${D}${libdir}"
	for gamedir in ${GN} ${GN}/Mods ${GN}/Mods/${MY_MOD} ${GN}/Mods/${MY_MOD}HD
	do
		mkdir "${D}${libdir}/${gamedir}" || die "Failed to create mod dir"
	done
	mkdir "${D}${dir}"

	# unpack mod content
	cat "${DISTDIR}/${MY_MOD_ARC}".part* > "${MY_MOD_ARC}"
	unpack ./"${MY_MOD_ARC}"
	mv Mods "${D}${dir}" || die "Failed to moved mod content"

	# moving standart libs
	if use x86; then
		mv "${BUILD_TMP}"/Debug/libEntitiesMP.so \
			"${D}/usr/lib/${GN}/Mods/${MY_MOD}"/${MY_LIB1} || die "Failed to moved libEntities.so"
		mv "${BUILD_TMP}"/Debug/libGameMP.so \
			"${D}/usr/lib/${GN}/Mods/${MY_MOD}"/${MY_LIB2} || die "Failed to moved libGame.so"
	else
		mv "${BUILD_TMP}"/Debug/libEntitiesMP.so \
			"${D}/usr/lib64/${GN}/Mods/${MY_MOD}"/${MY_LIB1} || die "Failed to moved libEntities.so"
		mv "${BUILD_TMP}"/Debug/libGameMP.so \
			"${D}/usr/lib64/${GN}/Mods/${MY_MOD}"/${MY_LIB2} || die "Failed to moved libGame.so"
	fi

	# moving HD libs
	if use x86; then
		mv "${BUILD_DIR}"/Debug/libEntitiesMP.so \
			"${D}/usr/lib/${GN}/Mods/${MY_MOD}HD"/${MY_LIB1} || die "Failed to moved libEntities.so"
		mv "${BUILD_DIR}"/Debug/libGameMP.so \
			"${D}/usr/lib/${GN}/Mods/${MY_MOD}HD"/${MY_LIB2} || die "Failed to moved libGame.so"
	else
		mv "${BUILD_DIR}"/Debug/libEntitiesMP.so \
			"${D}/usr/lib64/${GN}/Mods/${MY_MOD}HD"/${MY_LIB1} || die "Failed to moved libEntities.so"
		mv "${BUILD_DIR}"/Debug/libGameMP.so \
			"${D}/usr/lib64/${GN}/Mods/${MY_MOD}HD"/${MY_LIB2} || die "Failed to moved libGame.so"
	fi

	# removing temp stuff
	rm -f  "${BUILD_TMP}"/{*.cmake,*.txt,*.a,*.ninja,.gitkeep} || die "Failed to removed temp stuff"
	rm -fr "${BUILD_TMP}"/Debug && rm -fr "${BUILD_TMP}"/CMakeFiles && rm -fr "${MY_CONTENT}"
	rm -fr "${BUILD_TMP}"/XPLUS

	insinto /usr

}

pkg_postinst() {
	elog ""
	elog "     **************************************************"
	elog "     Serious Sam Parse Error FE Modifications installed"
	elog "     **************************************************"
	elog ""
	echo
}
