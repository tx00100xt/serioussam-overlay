# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cdrom unpacker

PATCH_PREFIX="Patch_1.07_SE"
# Game name
GN="serioussamse"

DESCRIPTION="Croteam's Serious Sam Classic The Second Encounter ... the data files"
HOMEPAGE="http://www.croteam.com/
	https://store.steampowered.com/app/41060/Serious_Sam_Classic_The_Second_Encounter/"
SRC_URI="https://github.com/tx00100xt/serioussam-mods/raw/main/Patches/${PATCH_PREFIX}.tar.xz"

S="${WORKDIR}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="ru"

DEPEND="|| ( games-fps/serioussam-vk games-fps/serioussam )"

S=${WORKDIR}

pkg_setup() {
	cdrom_get_cds "Install/SE1_00_Levels.gro"
}

src_unpack() {
	mkdir Levels Mods
	cat "${DISTDIR}/${PATCH_PREFIX}.tar.xz" > "${PATCH_PREFIX}.tar.xz"
	unpack "${WORKDIR}/${PATCH_PREFIX}.tar.xz"
}

src_install() {
	local dir="/usr/share/${GN}"

	einfo "Copying from ${CDROM_ROOT}"
	insinto "${dir}"
	doins -r "${CDROM_ROOT}"/Install/*

	mv "${WORKDIR}"/*.gro "${D}/${dir}" || die "failed to moved patch 1.07"
	mv "${D}/${dir}"/Scripts/PersistentSymbols.ini "${WORKDIR}" || die "failed to moved PersistentSymbols.ini"

	rm -rf "${D}/${dir}"/Bin || die "failed to removed stuff"
	rm -rf "${D}/${dir}"/Controls || die "failed to removed stuff"
	rm -rf "${D}/${dir}"/Data || die "failed to removed stuff"
	rm -rf "${D}/${dir}"/Demos || die "failed to removed stuff"
	rm -rf "${D}/${dir}"/Mods || die "failed to removed stuff"
	rm -rf "${D}/${dir}"/Players || die "failed to removed stuff"
	rm -rf "${D}/${dir}"/Scripts || die "failed to removed stuff"
	rm -rf "${D}/${dir}"/VirtualTrees || die "failed to removed stuff"
	rm -f  "${D}/${dir}"/Help/ShellSymbols.txt || die "failed to removed stuff"
	rm -f  "${D}/${dir}"/ModEXT.txt  || die "failed to removed stuff"
	mkdir "${D}/${dir}/Scripts"
	mv "${WORKDIR}"/PersistentSymbols.ini "${D}/${dir}/Scripts" || die "failed to moved PersistentSymbols.ini"

	if use ru; then
		 mv "${D}/${dir}"/Locales/rus/SE1_00_Sounds_RUS.gro "${D}/${dir}"
		 mv "${D}/${dir}"/Locales/rus/SE1_00_Texts_RUS.gro "${D}/${dir}"
		 mv "${D}/${dir}"/Locales/rus/SEGold_DM.gro "${D}/${dir}"
	fi

	rm -rf "${D}/${dir}"/Locales || die "failed to removed stuff"

	# Remove useless Windows files
	rm -f "${D}/${dir}"/{*.exe,*.ex_,*.bmp,*.inx,*.hdr,*.bin,*.cab,*.ini,*.log} || die "Failed to remove windows cruft"

	# Ensure that file datestamps from the CD are sane
	find "${D}/${dir}"/Levels -exec touch -d '09 May 2020 14:00' '{}' \; || die "touch failed"
}

pkg_postinst() {
	elog "Important information about the Linux port is at:"
	elog "  https://github.com/tx00100xt/SeriousSamClassic or"
	elog "  https://github.com/tx00100xt/SeriousSamClassic-VK"
	elog "    look at:"
	elog "  https://github.com/tx00100xt/serioussam-overlay/README.md"
	elog "   For information on the first launch of the game"

	echo
}
