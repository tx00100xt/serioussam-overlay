# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == 9999 ]]; then
	SSAM_BRANCH=9999
else
	SSAM_BRANCH="${PV}"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Meta package for Serious Sam: The First Encounter addons"
HOMEPAGE="https://github.com/tx00100xt"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"

DEPEND="games-fps/serioussam-alpharemake
	games-fps/serioussam-oddworld
	games-fps/serioussam-parseerror
	games-fps/serioussam-tower
	games-fps/serioussam-xplus
	games-fps/serioussam
"
