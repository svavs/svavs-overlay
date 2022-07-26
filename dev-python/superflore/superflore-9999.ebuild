# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{8,9,10} pypy )

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
  # EGIT_REPO_URI="https://github.com/ros-infrastructure/${PN}.git"
  EGIT_REPO_URI="https://github.com/svavs/${PN}.git"
	EGIT_BRANCH="develop"
fi

inherit ${SCM} distutils-r1

if [ "${PV#9999}" != "${PV}" ] ; then
	SRC_URI=""
else
  SRC_URI="https://github.com/svavs/superflore/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="Super Bloom - an extended release manager for ROS"
HOMEPAGE="https://pypi.python.org/pypi/superflore/"

LICENSE="( Apache-2.0 MIT )"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm64 ~arm"
IUSE="test"

RDEPEND="dev-python/xmltodict
	dev-python/termcolor
	dev-python/setuptools
	dev-python/rosdistro
	dev-python/catkin_pkg
	dev-python/git-python
	dev-python/PyGithub
	dev-python/pyyaml
	dev-python/docker-py
	dev-python/requests
	dev-util/rosinstall_generator
	dev-util/rosdep
	dev-vcs/git
	dev-lang/python
	app-containers/docker
	app-containers/docker-cli"

DEPEND="${RDEPEND}
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
	)
	"

python_test() {
>---nosetests --with-coverage --cover-package=rospkg --with-xunit test || die
}
