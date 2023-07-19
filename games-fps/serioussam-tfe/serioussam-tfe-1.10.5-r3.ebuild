# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake desktop

MY_PN="SamTFE"
# Game name
GN="serioussam"

DESCRIPTION="Linux port of Serious Sam Classic The First Encounter"
HOMEPAGE="https://github.com/tx00100xt/SeriousSamClassic"
SRC_URI="https://github.com/tx00100xt/SeriousSamClassic/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
RESTRICT="bindist mirror"
IUSE="alsa pipewire"

RDEPEND="
	!games-fps/serioussam-tfe-vk
	media-libs/libsdl2[video,joystick,opengl]
	media-libs/libvorbis
	sys-libs/zlib
	sys-devel/flex
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

S="${WORKDIR}/SeriousSamClassic-${PV}/${MY_PN}/Sources"
MY_CONTENT="${WORKDIR}/SeriousSamClassic-${PV}/${MY_PN}"

QA_TEXTRELS="
usr/lib/${GN}/libEntities.so
usr/lib/${GN}/libGame.so
usr/lib/${GN}/libamp11lib.so
usr/lib/${GN}/libShaders.so
usr/lib/libEngine.so
usr/lib64/${GN}/libEntities.so
usr/lib64/${GN}/libGame.so
usr/lib64/${GN}/libamp11lib.so
usr/lib64/${GN}/libShaders.so
usr/lib64/libEngine.so
"

QA_FLAGS_IGNORED="
usr/lib/${GN}/libEntities.so
usr/lib/${GN}/libGame.so
usr/lib/${GN}/libamp11lib.so
usr/lib/${GN}/libShaders.so
usr/lib/libEngine.so
usr/lib64/${GN}/libEntities.so
usr/lib64/${GN}/libGame.so
usr/lib64/${GN}/libamp11lib.so
usr/lib64/${GN}/libShaders.so
usr/lib64/libEngine.so
usr/bin/${GN}
usr/bin/${GN}-ded
"

PATCHES=(
	"${FILESDIR}/0001-remove_SE1_10b_depend.patch"
	"${FILESDIR}/0002-Fixed_Platform_definition.patch"
	"${FILESDIR}/0003-Fix-load-some-incorrect-custom-maps.patch"
	"${FILESDIR}/rparh_security.patch"
)

src_configure() {
	rm -rf "${MY_CONTENT}"/Tools.Win32 || die "Failed to removed Win32 stuff"

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
	mkdir "${D}/usr" && mkdir "${D}/usr/share" && mkdir "${D}/usr/bin" && mkdir "${D}${dir}"
	if use x86; then
		mkdir "${D}/usr/lib" && mkdir "${D}/usr/lib/${GN}"  && mkdir "${D}/usr/lib/${GN}/Mods"
		# moving libs
		mv "${BUILD_DIR}"/Debug/libEngine.so "${D}/usr/lib" || die "Failed to moved libEngine.so"
		mv "${BUILD_DIR}"/Debug/* "${D}/usr/lib/${GN}" || die "Failed to moved game libs"
	else
		mkdir "${D}/usr/lib64" && mkdir "${D}/usr/lib64/${GN}"  && mkdir "${D}/usr/lib64/${GN}/Mods"
		# moving libs
		mv "${BUILD_DIR}"/Debug/libEngine.so "${D}/usr/lib64" || die "Failed to moved libEngine.so"
		mv "${BUILD_DIR}"/Debug/* "${D}/usr/lib64/${GN}" || die "Failed to moved game libs"
	fi

	# removing temp stuff
	rm -f  "${BUILD_DIR}"/{*.cmake,*.txt,*.a,*.ninja,.gitkeep} || die "Failed to removed temp stuff"
	rm -fr "${BUILD_DIR}"/Debug && rm -fr "${BUILD_DIR}"/CMakeFiles && rm -fr "${MY_CONTENT}/Sources"
	# moving binares
	mv "${BUILD_DIR}"/serioussam "${D}/usr/bin/${GN}"  || die "Failed to moved SeriousSam"
	# moving content
	cp -fr "${MY_CONTENT}"/* "${D}${dir}"
	cp "${FILESDIR}/ssam.xpm" "${D}/${dir}"

	# fix scripts for AMD cards
	sed -i 's/mdl_bFineQuality = 0;/mdl_bFineQuality = 1;/g' "${D}/${dir}"/Scripts/GLSettings/RAM.ini
	sed -i 's/mdl_bFineQuality = 0;/mdl_bFineQuality = 1;/g' "${D}/${dir}"/Scripts/GLSettings/ATI-RPRO.ini

	insinto /usr

	cd "${D}/${dir}"
	newicon ssam.xpm ${GN}.xpm

	make_desktop_entry ${GN} "Serious Sam The First Encounter" ${GN}
}

pkg_postinst() {
	elog "     ***************************************************************************************"
	elog "     If you have access to a copy of the game (either by CD or through Steam),"
	elog "     you can copy the *.gro files to the /usr/share/serioussam directory."
	elog "     /usr/share/serioussam is the directory of the game Serious Sam Classic The First Encounter"
	elog "     ***************************************************************************************"
	elog "     Copy all *.gro files and Help folder from the game directory to serioussam directory."
	elog "     At the current time the files are:"
	elog "      - Help (folder)"
	elog "      - Levels (folder)"
	elog "      - 1_00_ExtraTools.gro"
	elog "      - 1_00_music.gro"
	elog "      - 1_00c.gro"
	elog "      - 1_00c_scripts.gro"
	elog "      - 1_04_patch.gro"
	elog "     ***************************************************************************************"
	elog "     You can also install:"
	elog "                emerge serioussam-tfe-data"
	elog "     to extract game content from your CD or mounted image."
	elog "     ***************************************************************************************"
	elog "     Look at:"
	elog "        https://github.com/tx00100xt/serioussam-overlay/README.md"
	elog "     For information on the first launch of the game"
	elog ""
	echo
}
