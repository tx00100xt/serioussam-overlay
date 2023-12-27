# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GN1U General Public License v2

EAPI=8

inherit cmake

MY_PN1="SamTFE"
MY_PN2="SamTSE"
# Game name
GN1="serioussam"
GN2="serioussamse"
# URL prefix
URL1="https://github.com/tx00100xt/SeriousSamClassic/archive/"
URL2="https://github.com/tx00100xt/serioussam-mods/raw/main/"

DESCRIPTION="XPLUS modificarion for linux port of Serious Sam"
HOMEPAGE="https://github.com/tx00100xt/SeriousSamClassic"
SRC_URI="${URL1}$refs/tags/${PV}c.tar.gz -> ${P}.tar.gz
	${URL2}${MY_PN1}-XPLUS/${MY_PN1}-XPLUS.tar.xz.partaa
	${URL2}${MY_PN1}-XPLUS/${MY_PN1}-XPLUS.tar.xz.partab
	${URL2}${MY_PN1}-XPLUS/${MY_PN1}-XPLUS.tar.xz.partac
	${URL2}${MY_PN2}-XPLUS/${MY_PN2}-XPLUS.tar.xz.partaa
	${URL2}${MY_PN2}-XPLUS/${MY_PN2}-XPLUS.tar.xz.partab
	${URL2}${MY_PN2}-XPLUS/${MY_PN2}-XPLUS.tar.xz.partac
"
S="${WORKDIR}/SeriousSamClassic-tags-${PV}c"

MY_CONTENT1="${WORKDIR}/SeriousSamClassic-tags-${PV}c/${MY_PN1}"
MY_CONTENT2="${WORKDIR}/SeriousSamClassic-rags-${PV}c/${MY_PN2}"
XPLUS_ARC1="${MY_PN1}-XPLUS.tar.xz"
XPLUS_ARC2="${MY_PN2}-XPLUS.tar.xz"

LICENSE="GPL-2 BSD ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="games-fps/serioussam"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	einfo "Remove Win32 stuff..."
	rm -rf "${MY_CONTENT1}"/Tools.Win32 || \
		die "Failed to removed Win32 stuff"

	einfo "Setting build type Release, configure XPLUS..."
	CMAKE_BUILD_TYPE="Release"
	local mycmakeargs=(
		-DXPLUS=TRUE
	)
	cmake_src_configure
}

src_compile() {
	SE="Sources/Entities"
	einfo "Compiling with xplus weapon..."
	rm -f "${S}/${MY_PN1}/${SE}"/PlayerWeapons.es \
		|| die "Failed to removed PlayerWeapons.es"
	mv "${S}/${MY_PN1}/${SE}"/PlayerWeaponsHD.es \
		"${S}/${MY_PN1}/${SE}"/PlayerWeapons.es \
		|| die "Failed to moved PlayerWeapons.es"
	rm -f "${S}/${MY_PN2}/${SE}"MP/PlayerWeapons.es \
		|| die "Failed to removed PlayerWeapons.es"
	mv "${S}/${MY_PN2}/${SE}"MP/PlayerWeaponsHD.es \
		"${S}/${MY_PN2}/${SE}"MP/PlayerWeapons.es \
		|| die "Failed to moved PlayerWeapons.es"
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
	mkdir "${D}/usr" && mkdir "${D}/usr/share" && mkdir "${D}/usr/bin" \
		|| die "Failed to create install dir"
	mkdir "${D}${libdir}" && mkdir "${D}${dir1}" && mkdir "${D}${dir2}" \
		|| die "Failed to create install dir"
	for gamedir in ${GN1} ${GN1}/Mods ${GN2} ${GN2}/Mods
	do
		mkdir "${D}${libdir}/${gamedir}" || die "Failed create lib dir"
	done

	# moving libs
	mkdir "${D}${libdir}/${GN1}/Mods/XPLUS" || die "Failed create lib dir"
	mkdir "${D}${libdir}/${GN2}/Mods/XPLUS" || die "Failed create lib dir"
	mv "${BUILD_DIR}/${MY_PN1}"/Sources/Debug/lib*.so \
		"${D}/${libdir}/${GN1}/Mods/XPLUS" \
			|| die "Failed to moved XPLUS libs"
	mv "${BUILD_DIR}/${MY_PN2}"/Sources/Debug/lib*.so \
		"${D}/${libdir}/${GN2}/Mods/XPLUS" \
			|| die "Failed to moved XPLUS libs"

	# unpack mod content
	cat "${DISTDIR}/${XPLUS_ARC1}".part* > "${XPLUS_ARC1}" \
		|| die "Failed to unpack mod content"
	cat "${DISTDIR}/${XPLUS_ARC2}".part* > "${XPLUS_ARC2}" \
		|| die "Failed to unpack mod content"
	cd "${D}${dir1}"
	unpack "${S}/${XPLUS_ARC1}" || die "Failed to unpack mod content"
	cd "${D}${dir2}"
	unpack "${S}/${XPLUS_ARC2}" || die "Failed to unpack mod content"

	rm -f "${D}${dir1}"/Mods/XPLUS.des || die "Failed remove temp stuff"
	rm -f "${D}${dir1}"/Mods/XPLUSTbn.tex || die "Failed remove temp stuff"
	rm -f "${D}${dir2}"/Mods/XPLUS.des || die "Failed remove temp stuff"
	rm -f "${D}${dir2}"/Mods/XPLUSTbn.tex || die "Failed remove temp stuff"
}

pkg_postinst() {
	elog "     Serious Sam Classic XPLUS Modification installed"
}
