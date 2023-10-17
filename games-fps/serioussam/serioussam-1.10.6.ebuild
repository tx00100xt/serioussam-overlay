# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GN1U General Public License v2

EAPI=7

inherit cmake desktop

MY_PN1="SamTFE"
MY_PN2="SamTSE"
# Game name
GN1="serioussam"
GN2="serioussamse"

DESCRIPTION="Linux port of Serious Sam Classic"
HOMEPAGE="https://github.com/tx00100xt/SeriousSamClassic"
SRC_URI="https://github.com/tx00100xt/SeriousSamClassic/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	xplus? ( https://github.com/tx00100xt/serioussam-mods/raw/main/${MY_PN1}-XPLUS/${MY_PN1}-XPLUS.tar.xz.partaa
	https://github.com/tx00100xt/serioussam-mods/raw/main/${MY_PN1}-XPLUS/${MY_PN1}-XPLUS.tar.xz.partab
	https://github.com/tx00100xt/serioussam-mods/raw/main/${MY_PN1}-XPLUS/${MY_PN1}-XPLUS.tar.xz.partac
	https://github.com/tx00100xt/serioussam-mods/raw/main/${MY_PN2}-XPLUS/${MY_PN2}-XPLUS.tar.xz.partaa
	https://github.com/tx00100xt/serioussam-mods/raw/main/${MY_PN2}-XPLUS/${MY_PN2}-XPLUS.tar.xz.partab
	https://github.com/tx00100xt/serioussam-mods/raw/main/${MY_PN2}-XPLUS/${MY_PN2}-XPLUS.tar.xz.partac )
"

XPLUS_ARC1="${MY_PN1}-XPLUS.tar.xz"
XPLUS_ARC2="${MY_PN2}-XPLUS.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
RESTRICT="bindist mirror"
IUSE="alsa pipewire xplus"

RDEPEND="
	!games-fps/serioussam-vk
	media-libs/libsdl2[video,joystick,opengl,vulkan]
	media-libs/libvorbis
	sys-libs/zlib
	sys-devel/flex
	sys-devel/bison
	sys-devel/bison
	alsa? (
		>=media-libs/libsdl2-2.0.6[alsa,sound]
	)
	pipewire? (
		>=media-libs/libsdl2-2.0.6[pipewire,sound]
	)
"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/SeriousSamClassic-${PV}"
MY_CONTENT1="${WORKDIR}/SeriousSamClassic-${PV}/${MY_PN1}"
MY_CONTENT2="${WORKDIR}/SeriousSamClassic-${PV}/${MY_PN2}"
BUILD_TMP=${BUILD_DIR}

PATCHES=(
	"${FILESDIR}/0010-rparh_security.patch"
)

src_configure() {
	einfo "Remove Win32 stuff..."
	rm -rf "${MY_CONTENT1}"/Tools.Win32 || die "Failed to removed Win32 stuff"

	if use xplus; then
		einfo "Setting build type Release, configure XPLUS..."
		CMAKE_BUILD_TYPE="Release"
		local mycmakeargs=(
			-DXPLUS=TRUE
		)
		BUILD_DIR="${BUILD_TMP}/XPLUS"
		cmake_src_configure
	fi

	einfo "Setting build type Release..."
	CMAKE_BUILD_TYPE="Release"
	if use arm64; then
		local mycmakeargs=(
			-DRPI4=TRUE
			-DXPLUS=FALSE
		)
	else
		local mycmakeargs=(
			-DXPLUS=FALSE
		)
	fi
	BUILD_DIR="${BUILD_TMP}"
	cmake_src_configure
}

src_compile() {
	einfo "Compiling with standart weapon..."
	cmake_src_compile
	if use xplus; then
		SE="Sources/Entities"
		einfo "Compiling with xplus weapon..."
		rm -f "${S}/${MY_PN1}/${SE}"/PlayerWeapons.es || die "Failed to removed PlayerWeapons.es"
		mv "${S}/${MY_PN1}/${SE}"/PlayerWeaponsHD.es \
			"${S}/${MY_PN1}/${SE}"/PlayerWeapons.es || die "Failed to moved PlayerWeapons.es"
		rm -f "${S}/${MY_PN2}/${SE}"MP/PlayerWeapons.es || die "Failed to removed PlayerWeapons.es"
		mv "${S}/${MY_PN2}/${SE}"MP/PlayerWeaponsHD.es \
			"${S}/${MY_PN2}/${SE}"MP/PlayerWeapons.es || die "Failed to moved PlayerWeapons.es"
			BUILD_DIR="${BUILD_TMP}/XPLUS"
		cmake_src_compile
	fi
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
	mkdir "${D}/usr" && mkdir "${D}/usr/share" && mkdir "${D}/usr/bin"
	mkdir "${D}${libdir}" && mkdir "${D}${dir1}" && mkdir "${D}${dir2}"
	for gamedir in ${GN1} ${GN1}/Mods ${GN2} ${GN2}/Mods
	do
		mkdir "${D}${libdir}/${gamedir}" || die "Failed to create lib dir"
	done

	# moving libs
	BUILD_DIR="${BUILD_TMP}"
	mv "${BUILD_DIR}/${MY_PN1}"/Sources/Debug/libEngine.so "${D}/${libdir}" || die "Failed to moved libEngine.so"
	mv "${BUILD_DIR}/${MY_PN1}"/Sources/Debug/lib*.so "${D}/${libdir}/${GN1}" || die "Failed to moved game libs"
	mv "${BUILD_DIR}/${MY_PN2}"/Sources/Debug/libEngineMP.so "${D}/${libdir}" || die "Failed to moved libEngineMP.so"
	mv "${BUILD_DIR}/${MY_PN2}"/Sources/Debug/lib*.so "${D}/${libdir}/${GN2}" || die "Failed to moved game libs"

	if use xplus; then
		mkdir "${D}${libdir}/${GN1}/Mods/XPLUS" || die "Failed to create mod lib dir"
		mkdir "${D}${libdir}/${GN2}/Mods/XPLUS" || die "Failed to create mod lib dir"
		mv "${BUILD_DIR}/XPLUS//${MY_PN1}"/Sources/Debug/lib*.so \
			"${D}/${libdir}/${GN1}/Mods/XPLUS" || die "Failed to moved XPLUS libs"
		mv "${BUILD_DIR}/XPLUS/${MY_PN2}"/Sources/Debug/lib*.so \
			"${D}/${libdir}/${GN2}/Mods/XPLUS" || die "Failed to moved XPLUS libs"
	fi

	# removing stuff
	rm -fr "${MY_CONTENT1}/Sources"&& rm -fr "${MY_CONTENT2}/Sources"
	# moving binares
	mv "${BUILD_DIR}/${MY_PN1}/Sources/${GN1}" "${D}/usr/bin"  || die "Failed to moved SeriousSam"
	mv "${BUILD_DIR}/${MY_PN1}/Sources/${GN1}-ded" "${D}/usr/bin"  || die "Failed to moved DedicaredServer"
	mv "${BUILD_DIR}/${MY_PN1}/Sources/${GN1}-mkfont" "${D}/usr/bin"  || die "Failed to moved MakeFONT"
	mv "${BUILD_DIR}/${MY_PN2}/Sources/${GN2}" "${D}/usr/bin"  || die "Failed to moved SeriousSam"
	mv "${BUILD_DIR}/${MY_PN2}/Sources/${GN2}-ded" "${D}/usr/bin"  || die "Failed to moved DedicaredServer"
	mv "${BUILD_DIR}/${MY_PN2}/Sources/${GN2}-mkfont" "${D}/usr/bin"  || die "Failed to moved MakeFONT"
	# moving content
	cp -fr "${MY_CONTENT1}"/* "${D}/${dir1}"
	cp "${FILESDIR}/ssam.xpm" "${D}/${dir1}"
	cp -fr "${MY_CONTENT2}"/* "${D}/${dir2}"
	cp "${FILESDIR}/ssam.xpm" "${D}/${dir2}"
	rm -f  "${D}/${dir1}"/{*.png,*.desktop} || die "Failed to removed temp stuff"
	rm -f  "${D}/${dir2}"/{*.png,*.desktop} || die "Failed to removed temp stuff"

	if use xplus; then
		# unpack mod content
		cat "${DISTDIR}/${XPLUS_ARC1}".part* > "${XPLUS_ARC1}"
		cat "${DISTDIR}/${XPLUS_ARC2}".part* > "${XPLUS_ARC2}"
		cd "${D}${dir1}"
		unpack "${S}/${XPLUS_ARC1}" || die "Failed to unpack mod content"
		cd "${D}${dir2}"
		unpack "${S}/${XPLUS_ARC2}" || die "Failed to unpack mod content"
	fi

	insinto /usr

	cd "${D}/${dir1}"
	newicon ssam.xpm ${GN1}.xpm
	cd "${D}/${dir2}"
	newicon ssam.xpm ${GN2}.xpm

	make_desktop_entry ${GN1} "Serious Sam The First Encounter" ${GN1}
	make_desktop_entry ${GN2} "Serious Sam The Second Encounter" ${GN2}
}

pkg_postinst() {
	elog "     *********************************************************************************************"
	elog "     If you have access to a copy of the game (either by CD or through Steam),"
	elog "     you can copy the *.gro files to the /usr/share/serioussam directory."
	elog "     /usr/share/serioussam is the directory of the game Serious Sam Classic The First Encounter"
	elog "     /usr/share/serioussamse is the directory of the game Serious Sam Classic The Second Encounter"
	elog "     *********************************************************************************************"
	elog "     Copy all *.gro files and Help folder from the game directory to serioussam directory."
	elog "     At the current time the files are:"
	elog "      - Help (folder)"
	elog "      - Levels (folder)"
	elog "      - 1_00_ExtraTools.gro"
	elog "      - 1_00_music.gro"
	elog "      - 1_00c.gro"
	elog "      - 1_00c_scripts.gro"
	elog "      - 1_04_patch.gro"
	elog "     *********************************************************************************************"
	elog "     Copy all *.gro files and Help folder from the game directory to serioussamse directory."
	elog "     At the current time the files are:"
	elog "      - Help (folder)"
	elog "      - SE1_00.gro"
	elog "      - SE1_00_Extra.gro"
	elog "      - SE1_00_ExtraTools.gro"
	elog "      - SE1_00_Levels.gro"
	elog "      - SE1_00.gro"
	elog "      - SE1_00_Music.gro"
	elog "      - 1_04_patch.gro"
	elog "      - 1_07_patch.gro"
	elog "     *********************************************************************************************"
	elog "     You can also install:"
	elog "                emerge serioussam-tfe-data serioussam-tse-data"
	elog "     to extract game content from your CD or mounted image."
	elog "     *********************************************************************************************"
	elog "     Look at:"
	elog "        https://github.com/tx00100xt/serioussam-overlay/README.md"
	elog "        https://github.com/tx00100xt/SeriousSamClassic/wiki"
	elog "     For information on the first launch of the game"
	elog ""
	echo
}
