# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

MY_PN="SamTFE"

DESCRIPTION="Serious Sam Classic The First Encounter XPLUS Modification"
HOMEPAGE="https://github.com/tx00100xt/SeriousSamClassic"
SRC_URI="https://github.com/tx00100xt/SeriousSamClassic/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/tx00100xt/serioussam-mods/raw/main/SamTFE-XPLUS/SamTFE-XPLUS.tar.xz.partaa
	https://github.com/tx00100xt/serioussam-mods/raw/main/SamTFE-XPLUS/SamTFE-XPLUS.tar.xz.partab
	https://github.com/tx00100xt/serioussam-mods/raw/main/SamTFE-XPLUS/SamTFE-XPLUS.tar.xz.partac"

XPLUS_ARC="SamTFE-XPLUS.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
RESTRICT="bindist mirror"
IUSE=""

RDEPEND="
    || ( games-fps/serioussam-tfe-vk games-fps/serioussam-tfe )
	media-libs/libsdl2[alsa,video,joystick,opengl]
	media-libs/libvorbis
    sys-libs/zlib
	sys-devel/flex
    sys-devel/bison"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/SeriousSamClassic-${PV}/${MY_PN}/Sources"
MY_CONTENT="${WORKDIR}/SeriousSamClassic-${PV}/${MY_PN}"

QA_TEXTRELS="
usr/share/SamTFE/Mods/XPLUS/Bin/libEntities.so
usr/share/SamTFE/Mods/XPLUS/Bin/libGame.so
usr/share/SamTFE/Mods/XPLUS/BaseBrowseExclude.lst
usr/share/SamTFE/Mods/XPLUS/BaseWriteInclude.lst
usr/share/SamTFE/Mods/XPLUS/BaseBrowseInclude.lst
usr/share/SamTFE/Mods/XPLUS/Textures/General/Grid16x16-dot.tex
usr/share/SamTFE/Mods/XPLUS/Textures/General/Pointer.tex
usr/share/SamTFE/Mods/XPLUS/Textures/Logo/sam_menulogo256b.tex
usr/share/SamTFE/Mods/XPLUS/Textures/Logo/godgameslogo.tex
usr/share/SamTFE/Mods/XPLUS/Textures/Logo/sam_menulogo256a.tex
usr/share/SamTFE/Mods/XPLUS/Data/Var/ModName.var
usr/share/SamTFE/Mods/XPLUS/Data/Var/DefaultPlayer.var
usr/share/SamTFE/Mods/XPLUS/BaseWriteExclude.lst
"

QA_FLAGS_IGNORED="
usr/share/SamTFE/Mods/XPLUS/Bin/libEntities.so
usr/share/SamTFE/Mods/XPLUS/Bin/libGame.so
usr/share/SamTFE/Mods/XPLUS/BaseBrowseExclude.lst
usr/share/SamTFE/Mods/XPLUS/BaseWriteInclude.lst
usr/share/SamTFE/Mods/XPLUS/BaseBrowseInclude.lst
usr/share/SamTFE/Mods/XPLUS/Textures/General/Grid16x16-dot.tex
usr/share/SamTFE/Mods/XPLUS/Textures/General/Pointer.tex
usr/share/SamTFE/Mods/XPLUS/Textures/Logo/sam_menulogo256b.tex
usr/share/SamTFE/Mods/XPLUS/Textures/Logo/godgameslogo.tex
usr/share/SamTFE/Mods/XPLUS/Textures/Logo/sam_menulogo256a.tex
usr/share/SamTFE/Mods/XPLUS/Data/Var/ModName.var
usr/share/SamTFE/Mods/XPLUS/Data/Var/DefaultPlayer.var
usr/share/SamTFE/Mods/XPLUS/BaseWriteExclude.lst
"

PATCHES=(
	"${FILESDIR}/rparh_security.patch"
	"${FILESDIR}/fixed_broken_timer.patch"
	"${FILESDIR}/critical_section_multitread.patch"
)



src_configure() {
    einfo "Choosing the player's xplus weapon..."
	rm -f "${MY_CONTENT}/Sources/Entities/PlayerWeapons.es" || die "Failed to removed PlayerWeapons.es"
    mv "${MY_CONTENT}/Sources/Entities/PlayerWeaponsHD.es" "${MY_CONTENT}/Sources/Entities/PlayerWeapons.es" || die "Failed to moved PlayerWeapons.es"

    einfo "Setting build type Release..."
    CMAKE_BUILD_TYPE="Release"
	local mycmakeargs=(
		-DTFE=TRUE
	)
	cmake_src_configure
}

src_install() {
    local dir="/usr/share/${MY_PN}"

    # crerate install dirs
    mkdir "${D}/usr" && mkdir "${D}/usr/share" && mkdir "${D}/usr/bin"

    mkdir "${D}${dir}"
    cat "${DISTDIR}/${XPLUS_ARC}".part* > "${XPLUS_ARC}"
    unpack ./"${XPLUS_ARC}"
    mv Mods "${D}${dir}" || die "Failed to moved mod content"

    # moving libs 
    mv "${BUILD_DIR}"/Debug/libEntities.so "${D}${dir}"/Mods/XPLUS/Bin || die "Failed to moved libEntities.so"
    mv "${BUILD_DIR}"/Debug/libGame.so "${D}${dir}"/Mods/XPLUS/Bin || die "Failed to moved libGame.so"
    # removing temp stuff
	rm -f  "${BUILD_DIR}"/{*.cmake,*.txt,*.a,*.ninja,.gitkeep} || die "Failed to removed temp stuff"
    rm -fr "${BUILD_DIR}"/Debug && rm -fr "${BUILD_DIR}"/CMakeFiles && rm -fr "${MY_CONTENT}"
	rm -f  "${D}${dir}"/Mods/XPLUS.des || die "Failed to removed temp stuff"
    rm -f  "${D}${dir}"/Mods/XPLUSTbn.tex || die "Failed to removed temp stuff"

	insinto /usr/share

}

pkg_postinst() {
	elog ""
	elog "     *************************************************************"
	elog "     Serious Sam The First Encounter XPLUS Modifications installed"
	elog "     *************************************************************"
	elog ""
    echo
}
