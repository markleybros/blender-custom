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

_log Cloning blender...
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

# Currently the freetype library included in linux_centos7_x86_64 has an unresolved link-type dependency on brotli.
_log Fixing broken freetype...
cd ~/blender-git
FREETYPE_VERSION=2.11.0
FREETYPE_HASH=a45c6b403413abd5706f3582f04c8339d26397c4304b78fa552f2215df64101f
wget --no-check-certificate "https://download.savannah.gnu.org/releases/freetype/freetype-${FREETYPE_VERSION}.tar.gz" || _die failed downloading freetype
echo "${FREETYPE_HASH}  freetype-${FREETYPE_VERSION}.tar.gz" | sha256sum -c || _die freetype hash mismatch
tar xvf "freetype-${FREETYPE_VERSION}.tar.gz" || _die freetype untar failed
cd "freetype-${FREETYPE_VERSION}" || _die cd into freetype directory failed
./configure --prefix="${HOME}"/blender-git/lib/linux_centos7_x86_64/freetype --with-brotli=no --enable-static --disable-shared || _die freetype configure failed
make || _die freetype make failed
make install || _die freetype make install failed

_log Compiling blender...
cd ~/blender-git/blender || _die failed to change to build directory
### make update || _die failed make update
make release || _die failed make
GIT_COMMIT=$(git rev-parse --short HEAD) || _die git rev-parse failed

_log Compressing archive...
cd ~/blender-git/build_linux_release || _die change to output directory failed
mv bin blender-2.93-"${GIT_COMMIT}"-linux-x64 || _die rename output directory failed
tar cJvf blender-2.93-"${GIT_COMMIT}"-linux-x64.tar.xz blender-2.93-"${GIT_COMMIT}"-linux-x64 || _dir tar failed
_log Created output archive. $(pwd)/blender-2.93-"${GIT_COMMIT}"-linux-x64.tar.xz

_log All done.
exit 0

