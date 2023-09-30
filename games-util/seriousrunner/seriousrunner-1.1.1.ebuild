# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake desktop

MY_PN="seriousrunner"

DESCRIPTION="Serious Runner program that loads and runs content created by users"
HOMEPAGE="https://github.com/tx00100xt/Serious-Runner"
SRC_URI="https://github.com/tx00100xt/Serious-Runner/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="bindist mirror"
IUSE=""

RDEPEND="
	app-arch/bzip2
	app-arch/xz-utils
	app-arch/libarchive
	dev-qt/qtcore
	dev-qt/qtgui
	dev-qt/qtnetwork
	dev-qt/qtsql
	dev-qt/qtwidgets
	sys-libs/zlib
"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/Serious-Runner-${PV}"

src_configure() {
	einfo "Setting build type Release..."
	CMAKE_BUILD_TYPE="Release"
	cmake_src_configure
}

src_install() {
	local dir="/usr/share/${MY_PN}"

	# crerate install dirs
	mkdir "${D}/usr" && mkdir "${D}/usr/share" && mkdir "${D}/usr/bin"
	mkdir "${D}${dir}" && mkdir "${D}${dir}/DB" 

	# moving DB
	cp "${S}/DB/seriousrunner.db" "${D}${dir}/DB"
	# moving binares
	mv "${BUILD_DIR}/${MY_PN}" "${D}/usr/bin"  || die "Failed to moved Serious Runner"

	insinto /usr
	cd "${D}/${dir}"
	newicon "${S}/Icons/${MY_PN}.png" ${MY_PN}.xpm
	make_desktop_entry ${MY_PN} "Serious Runner" ${MY_PN}
}

pkg_postinst() {
	elog ""
	elog "     *****************************"
	elog "        Serious Runner installed"
	elog "     *****************************"
	elog ""
	echo
}
