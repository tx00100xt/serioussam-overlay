# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake desktop

MY_PN="SamTSE"
# Game name
GN="serioussamse"

DESCRIPTION="Linux port of Serious Sam Classic The Second Encounter with Vulkan support"
HOMEPAGE="https://github.com/tx00100xt/SeriousSamClassic-VK"
SRC_URI="https://github.com/tx00100xt/SeriousSamClassic-VK/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm64"
RESTRICT="bindist mirror"
IUSE=""

RDEPEND="
    !games-fps/serioussam-tse
	media-libs/libsdl2[video,joystick,opengl]
	media-libs/libvorbis
    sys-libs/zlib
	sys-devel/flex
    sys-devel/bison
    dev-util/vulkan-headers
    media-libs/vulkan-layers
    sys-devel/bison
	alsa? (
		>=media-libs/libsdl-2.0.6[alsa,sound]
	)
	pipewire? (
		>=media-libs/libsdl-2.0.6[pipewire,sound]
	)
"


DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/SeriousSamClassic-VK-${PV}/${MY_PN}/Sources"
MY_CONTENT="${WORKDIR}/SeriousSamClassic-VK-${PV}/${MY_PN}"

QA_TEXTRELS="
usr/lib/${GN}/libEntitiesMP.so
usr/lib/${GN}/libGameMP.so
usr/lib/${GN}/libamp11lib.so
usr/lib/${GN}/libShaders.so
usr/lib/libEngineMP.so
usr/lib64/${GN}/libEntitiesMP.so
usr/lib64/${GN}/libGameMP.so
usr/lib64/${GN}/libamp11lib.so
usr/lib64/${GN}/libShaders.so
usr/lib64/libEngineMP.so
"

QA_FLAGS_IGNORED="
usr/lib/${GN}/libEntitiesMP.so
usr/lib/${GN}/libGameMP.so
usr/lib/${GN}/libamp11lib.so
usr/lib/${GN}/libShaders.so
usr/lib/libEngineMP.so
usr/lib64/${GN}/libEntitiesMP.so
usr/lib64/${GN}/libGameMP.so
usr/lib64/${GN}/libamp11lib.so
usr/lib64/${GN}/libShaders.so
usr/lib64/libEngineMP.so
"

PATCHES=(
	"${FILESDIR}/samtse-vk-1.10.4-to-1.10.5-pre.patch"
	"${FILESDIR}/0002-Fixed_Platform_definition.patch"
	"${FILESDIR}/rparh_security_vk_1.10.4.patch"
)

src_configure() {
    rm -rf "${MY_CONTENT}"/Tools.Win32 || die "Failed to removed Win32 stuff"
    einfo "Choosing the player's standard weapon..."
	rm -f "${MY_CONTENT}/Sources/EntitiesMP/PlayerWeapons.es" || die "Failed to removed PlayerWeapons.es"
    mv "${MY_CONTENT}/Sources/EntitiesMP/PlayerWeapons_old.es" "${MY_CONTENT}/Sources/EntitiesMP/PlayerWeapons.es" || die "Failed to moved PlayerWeapons.es"

    einfo "Setting build type Release..."
    CMAKE_BUILD_TYPE="Release"
    if use arm64
    then
        local mycmakeargs=(
            -DTFE=FALSE
            -DRPI4=TRUE
        )
    else
        local mycmakeargs=(
            -DTFE=FALSE
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
        mv "${BUILD_DIR}"/Debug/libEngineMP.so "${D}/usr/lib" || die "Failed to moved libEngine.so"
        mv "${BUILD_DIR}"/Debug/* "${D}/usr/lib/${GN}" || die "Failed to moved game libs"
    else
    	mkdir "${D}/usr/lib64" && mkdir "${D}/usr/lib64/${GN}"  && mkdir "${D}/usr/lib64/${GN}/Mods"
        # moving libs 
        mv "${BUILD_DIR}"/Debug/libEngineMP.so "${D}/usr/lib64" || die "Failed to moved libEngine.so"
        mv "${BUILD_DIR}"/Debug/* "${D}/usr/lib64/${GN}" || die "Failed to moved game libs"
    fi

    # removing temp stuff
    rm -f  "${BUILD_DIR}"/{*.cmake,*.txt,*.a,*.ninja,.gitkeep} || die "Failed to removed temp stuff"
    rm -fr "${BUILD_DIR}"/Debug && rm -fr "${BUILD_DIR}"/CMakeFiles && rm -fr "${MY_CONTENT}/Sources"
    # moving binares
    mv "${BUILD_DIR}"/serioussamse "${D}/usr/bin/${GN}"  || die "Failed to moved SeriousSam"
    # moving content
    cp -fr "${MY_CONTENT}"/* "${D}${dir}"
    cp "${FILESDIR}/ssam.xpm" "${D}/${dir}"
    # fixing start standard game after mod
    mv "${D}${dir}"/Mods/SecondEncounter "${D}${dir}"/Mods/SeriousSam
    mv "${D}${dir}"/Mods/SecondEncounter.des "${D}${dir}"/Mods/SeriousSam.des
    mv "${D}${dir}"/Mods/SecondEncounterTbn.tex "${D}${dir}"/Mods/SeriousSamTbn.tex

    # fix scripts for AMD cards
    sed -i 's/mdl_bFineQuality = 0;/mdl_bFineQuality = 1;/g' "${D}/${dir}"/Scripts/GLSettings/RAM.ini
    sed -i 's/mdl_bFineQuality = 0;/mdl_bFineQuality = 1;/g' "${D}/${dir}"/Scripts/GLSettings/ATI-RPRO.ini

    insinto /usr

    cd "${D}/${dir}"
    newicon ssam.xpm ${GN}.xpm

	make_desktop_entry ${GN} "Serious Sam The Second Encounter" ${GN}
}

pkg_postinst() {
	elog "     ***************************************************************************************"
	elog "     If you have access to a copy of the game (either by CD or through Steam),"
	elog "     you can copy the *.gro files to the /usr/share/serioussamse directory."
	elog "     /usr/share/serioussamse is the directory of the game Serious Sam Classic The Second Encounter"
	elog "     ***************************************************************************************"
	elog "     Copy all *.gro files and Help folder from the game directory to /serioussamse directory."
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
	elog "     ***************************************************************************************"
	elog "     You can also install:"
  	elog "                emerge serioussam-tse-data"
  	elog "     to extract game content from your CD or mounted image."
	elog "     ***************************************************************************************"
	elog "     Look at:"
	elog "        https://github.com/tx00100xt/serioussam-overlay/README.md"
	elog "     For information on the first launch of the game"
	elog ""
    echo
}
