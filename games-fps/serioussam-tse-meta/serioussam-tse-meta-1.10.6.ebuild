# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == 9999 ]]; then
	SSAM_BRANCH=9999
else
	SSAM_BRANCH="${PV}"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Meta package for Serious Sam: The Second Encounter addons"
HOMEPAGE="https://github.com/tx00100xt"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
IUSE=""

DEPEND="games-fps/serioussam-dancesworld
	games-fps/serioussam-parseerror
	games-fps/serioussam-hno
	games-fps/serioussam-xplus
	games-fps/serioussam-st8vi
	games-fps/serioussam-st8vipe
	games-fps/serioussam-brightisland-mappack
	games-fps/serioussam-nextencounter-mappack
	games-fps/serioussam-rakanishu-mappacks
	games-fps/serioussam
"
