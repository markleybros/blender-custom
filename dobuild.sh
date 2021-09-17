#!/bin/bash

BASEPATH="$( cd "$(dirname "${0}")" ; pwd -P )"

function _log() {
	echo dobuild.sh: "${@}" 1>&2
}

function _die() {
	_log FATAL: "${@}"
	exit 1
}

set -o pipefail

_log Startup with basepath: "${BASEPATH}"

_log Setting up working directories...
mkdir -p ~/blender-git || _die failed to make build directory
cd ~/blender-git || _die failed to change to build directory

#_log Cloning blender...
git clone https://github.com/blender/blender.git || _die failed to clone blender
cd blender || _die failed cd
git checkout blender-v2.93-release || _die failed checkout
git pull --ff-only || _die failed pull
git submodule update --init --recursive || _die failed submodule init
git submodule foreach git checkout blender-v2.93-release || _die failed submodule checkout
git submodule foreach git pull --ff-only || _die failed submodule pull

_log Patching blender...
patch -p0 <"${BASEPATH}"/D7270.diff || _die patch failed to apply

_log Downloading precompiled dependencies
mkdir -p ~/blender-git/lib || _die failed to make lib directory
cd ~/blender-git/lib || _die failed to change to lib directory
svn checkout https://svn.blender.org/svnroot/bf-blender/trunk/lib/linux_centos7_x86_64 || _die failed to checkout pre-built libs

_log Compiling blender...
cd ~/blender-git/blender || _die failed to change to build directory
### make update || _die failed make update
make release || _die failed make

_log All done.
exit 0

