# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} == 9999 ]]; then
	SSAM_BRANCH=9999
else
	inherit eapi7-ver
	SSAM_BRANCH="${PV}"
	KEYWORDS="~amd64 ~x86 ~arm64"
fi

DESCRIPTION="Meta package for Serious Sam Classic and Mods"
HOMEPAGE="https://github.com/tx00100xt"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
IUSE="vulkan"

DEPEND=""
RDEPEND="
	games-fps/serioussam-dancesworld
	games-fps/serioussam-pese2q
	games-fps/serioussam-tse-data
	games-fps/serioussam-tse-xplus
	games-fps/serioussam-hno
	games-fps/serioussam-st8vi
	games-fps/serioussam-st8vipe
	vulkan? ( =games-fps/serioussam-tse-vk-${SSAM_BRANCH}-r2 )
	!vulkan? ( =games-fps/serioussam-tse-${SSAM_BRANCH}-r2 )
"
