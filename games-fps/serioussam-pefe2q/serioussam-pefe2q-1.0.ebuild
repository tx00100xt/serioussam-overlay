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

QA_TEXTRELS="
usr/lib/${GN}/Mods/${MY_MOD}/Bin/libEntities.so
usr/lib/${GN}/Mods/${MY_MOD}/Bin/libGame.so
usr/lib/${GN}/Mods/${MY_MOD}HD/Bin/libEntities.so
usr/lib/${GN}/Mods/${MY_MOD}HD/Bin/libGame.so
usr/lib64/${GN}/Mods/${MY_MOD}/Bin/libEntities.so
usr/lib64/${GN}/Mods/${MY_MOD}/Bin/libGame.so
usr/lib64/${GN}/Mods/${MY_MOD}HD/Bin/libEntities.so
usr/lib64/${GN}/Mods/${MY_MOD}HD/Bin/libGame.so
"

QA_FLAGS_IGNORED="
usr/lib/${GN}/Mods/${MY_MOD}/Bin/libEntities.so
usr/lib/${GN}/Mods/${MY_MOD}/Bin/libGame.so
usr/lib/${GN}/Mods/${MY_MOD}HD/Bin/libEntities.so
usr/lib/${GN}/Mods/${MY_MOD}HD/Bin/libGame.so
usr/lib64/${GN}/Mods/${MY_MOD}/Bin/libEntities.so
usr/lib64/${GN}/Mods/${MY_MOD}/Bin/libGame.so
usr/lib64/${GN}/Mods/${MY_MOD}HD/Bin/libEntities.so
usr/lib64/${GN}/Mods/${MY_MOD}HD/Bin/libGame.so
"

src_configure() {
	einfo "Choosing the player's standart weapon..."
	rm -f "${S}/EntitiesMP/PlayerWeapons.es" || die "Failed to removed PlayerWeapons.es"
	mv "${S}/EntitiesMP/PlayerWeapons_old.es" "${S}/EntitiesMP/PlayerWeapons.es" || die "Failed to moved PlayerWeapons.es"

	einfo "Setting build type Release..."
	CMAKE_BUILD_TYPE="Release"
	local mycmakeargs=(
		-DTFE=FALSE
	)
	cmake_src_configure
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

	# moving libs
	if use x86; then
		mv "${BUILD_DIR}"/Debug/libEntitiesMP.so "${D}/usr/lib/${GN}/Mods/${MY_MOD}"/libEntities.so || die "Failed to moved libEntities.so"
		mv "${BUILD_DIR}"/Debug/libGameMP.so "${D}/usr/lib/${GN}/Mods/${MY_MOD}"/libGame.so || die "Failed to moved libGame.so"
		# dosym "/usr/lib/${GN}/libamp11lib.so" "/usr/lib/${GN}/Mods/${MY_MOD}/libamp11lib.so"
	else
		mv "${BUILD_DIR}"/Debug/libEntitiesMP.so "${D}/usr/lib64/${GN}/Mods/${MY_MOD}"/libEntities.so || die "Failed to moved libEntities.so"
		mv "${BUILD_DIR}"/Debug/libGameMP.so "${D}/usr/lib64/${GN}/Mods/${MY_MOD}"/libGame.so || die "Failed to moved libGame.so"
		# dosym "/usr/lib64/${GN}/libamp11lib.so" "/usr/lib64/${GN}/Mods/${MY_MOD}/libamp11lib.so"
	fi

	# build HD
	einfo "Choosing the player's xplus weapon..."
	rm -f "${S}"/Sources/EntitiesMP/PlayerWeapons.es || die "Failed to removed PlayerWeapons.es"
	mv "${S}"/EntitiesMP/PlayerWeaponsHD.es "${S}"/EntitiesMP/PlayerWeapons.es || die "Failed to moved PlayerWeapons.es"
	cd "${S}"
	rm -fr cmake-build
	mkdir cmake-build && cd cmake-build
	# set cmake keys
	if use arm64
	then
	   cmake -DCMAKE_BUILD_TYPE=Release -DTFE=FALSE -DRPI4=TRUE ..
	elif use amd64
	then
	   cmake -DCMAKE_BUILD_TYPE=Release -DTFE=FALSE ..
	elif use x86
	then
	   cmake -DCMAKE_BUILD_TYPE=Release -DTFE=FALS -DCMAKE_C_FLAGS=-m32 -DCMAKE_CXX_FLAGS=-m32 -DUSE_I386_NASM_ASM=TRUE ..
	fi
	NCPU=`cat /proc/cpuinfo |grep vendor_id |wc -l`
	make -j"${NCPU}"

	# moving libs
	if use x86; then
		mv "${S}"/cmake-build/Debug/libEntitiesMP.so "${D}/usr/lib/${GN}/Mods/${MY_MOD}HD"/libEntities.so || die "Failed to moved libEntities.so"
		mv "${S}"/cmake-build/Debug/libGameMP.so "${D}/usr/lib/${GN}/Mods/${MY_MOD}HD"/libGame.so || die "Failed to moved libGame.so"
		# dosym "/usr/lib/${GN}/libamp11lib.so" "/usr/lib/${GN}/Mods/${MY_MOD}HD/libamp11lib.so"
	else
		mv "${S}"/cmake-build/Debug/libEntitiesMP.so "${D}/usr/lib64/${GN}/Mods/${MY_MOD}HD"/libEntities.so || die "Failed to moved libEntities.so"
		mv "${S}"/cmake-build/Debug/libGameMP.so "${D}/usr/lib64/${GN}/Mods/${MY_MOD}HD"/libGame.so || die "Failed to moved libGame.so"
		# dosym "/usr/lib64/${GN}/libamp11lib.so" "/usr/lib64/${GN}/Mods/${MY_MOD}HD/libamp11lib.so"
	fi

	# removing temp stuff
	rm -f  "${BUILD_DIR}"/{*.cmake,*.txt,*.a,*.ninja,.gitkeep} || die "Failed to removed temp stuff"
	rm -fr "${BUILD_DIR}"/Debug && rm -fr "${BUILD_DIR}"/CMakeFiles && rm -fr "${MY_CONTENT}"

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
