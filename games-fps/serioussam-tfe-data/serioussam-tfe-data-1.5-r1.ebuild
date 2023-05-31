# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cdrom eutils unpacker

# Game name
GN="serioussam"

LOKI_PACKAGE="ssam-tfe-lnx-beta1a.run"
# mirror
# LOKI_PACKAGE="serious.sam.tfe_1.05beta3-english-2.run"

DESCRIPTION="Croteam's Serious Sam Classic The First Encounter ... the data files"
HOMEPAGE="http://www.croteam.com/
	https://store.steampowered.com/app/41050/Serious_Sam_Classic_The_First_Encounter/"
SRC_URI="http://icculus.org/betas/ssam/${LOKI_PACKAGE}"
# mirror
# SRC_URI="https://lutris.net/files/games/serious-sam/${LOKI_PACKAGE}"

S="${WORKDIR}"

LICENSE="LOKI-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm64"
IUSE="ru"

DEPEND="|| ( games-fps/serioussam-tfe-vk games-fps/serioussam-tfe )"

S=${WORKDIR}

pkg_setup() {
	cdrom_get_cds "Install/1_00_music.gro"
}

src_unpack() {
	mkdir Levels Mods
    unpack_makeself "${LOKI_PACKAGE}"
}

src_install() {
	local dir="/usr/share/${GN}"

	einfo "Copying from ${CDROM_ROOT}"
	insinto "${dir}"
	doins -r "${CDROM_ROOT}"/Install/*
    nonfatal unpack ./SeriousSamPatch105_USA_linux.tar.bz2
    mv "${WORKDIR}"/*.gro "${D}/${dir}" || die "failed to moved patch 1.05"
    mv "${D}/${dir}"/Scripts/PersistentSymbols.ini "${WORKDIR}" || die "failed to moved PersistentSymbols.ini"

	rm -rf "${D}/${dir}"/Bin || die "failed to removed stuff"
	rm -rf "${D}/${dir}"/Controls || die "failed to removed stuff"
	rm -rf "${D}/${dir}"/Data || die "failed to removed stuff"
	rm -rf "${D}/${dir}"/Demos || die "failed to removed stuff"
	rm -rf "${D}/${dir}"/Mods || die "failed to removed stuff"
	rm -rf "${D}/${dir}"/Players || die "failed to removed stuff"
	rm -rf "${D}/${dir}"/Scripts || die "failed to removed stuff"
	rm -rf "${D}/${dir}"/VirtualTrees || die "failed to removed stuff"
	rm -f  "${D}/${dir}"/Help/ShellSymbols.txt  || die "failed to removed stuff"
    mkdir "${D}/${dir}/Scripts"
    mv "${WORKDIR}"/PersistentSymbols.ini "${D}/${dir}/Scripts" || die "failed to moved PersistentSymbols.ini"

	if use ru; then
	     mv "${D}/${dir}"/Locales/rus/1_00*_Sounds_RUS.gro "${D}/${dir}" 
	     mv "${D}/${dir}"/Locales/rus/1_00*_Texts_RUS.gro "${D}/${dir}"
	fi
    "${D}/${dir}"

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
