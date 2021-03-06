# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake desktop

MY_PN="SamTFE"
# Game name
GN="serioussam-tfe"

DESCRIPTION="Linux port of Serious Sam Classic The First Encounter with Vulkan support"
HOMEPAGE="https://github.com/tx00100xt/SeriousSamClassic-VK"
SRC_URI="https://github.com/tx00100xt/SeriousSamClassic-VK/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm64"
RESTRICT="bindist mirror"
IUSE=""

RDEPEND="
    !games-fps/serioussam-tfe
	media-libs/libsdl2[alsa,video,joystick,opengl]
	media-libs/libvorbis
    sys-libs/zlib
	sys-devel/flex
    sys-devel/bison
    dev-util/vulkan-headers
    media-libs/vulkan-layers
    media-libs/vulkan-loader"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/SeriousSamClassic-VK-${PV}/${MY_PN}/Sources"
MY_CONTENT="${WORKDIR}/SeriousSamClassic-VK-${PV}/${MY_PN}"

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
	"${FILESDIR}/vk_lost_headers.patch"
	"${FILESDIR}/vulkan_features.patch"
    "${FILESDIR}/added_memory_for_textures.patch"
    "${FILESDIR}/fixed_vendor_id.patch"
    "${FILESDIR}/crashfix_in_recovery_mode.patch"
    "${FILESDIR}/print_error_when_creating_vkdevice.patch"
	"${FILESDIR}/rparh_security_tfe_vk.patch"
	"${FILESDIR}/fixed_broken_timer.patch"
	"${FILESDIR}/fixed_validation_layers.patch"
	"${FILESDIR}/critical_section_multitread.patch"
	"${FILESDIR}/user_data_in_home_dir.patch"
	"${FILESDIR}/gcc-11.3_fixed_mod_startup.patch"
	"${FILESDIR}/usr_system_dir.patch"
	"${FILESDIR}/usr_system_dir_2.patch"
)

src_configure() {
    rm -rf "${MY_CONTENT}"/Tools.Win32 || die "Failed to removed Win32 stuff"
    einfo "Choosing the player's standard weapon..."
    rm -f "${MY_CONTENT}/Sources/Entities/PlayerWeapons.es" || die "Failed to removed PlayerWeapons.es"
    mv "${MY_CONTENT}/Sources/Entities/PlayerWeapons_old.es" "${MY_CONTENT}/Sources/Entities/PlayerWeapons.es" || die "Failed to moved PlayerWeapons.es"

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
    mv "${BUILD_DIR}"/SeriousSam "${D}/usr/bin/${GN}"  || die "Failed to moved libEntities.so"
    mv "${BUILD_DIR}"/DedicatedServer "${D}/usr/bin/${GN}-ded"  || die "Failed to moved libEntities.so"
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
	elog "     you can copy the *.gro files to the /usr/share/serioussam-tfe directory."
	elog "     /usr/share/serioussam-tfe is the directory of the game Serious Sam Classic The First Encounter"
	elog "     ***************************************************************************************"
	elog "     Copy all *.gro files and Help folder from the game directory to serioussam-tfe directory."
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
