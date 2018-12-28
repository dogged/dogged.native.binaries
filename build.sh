#!/bin/sh

SOURCE_DIR=${SOURCE_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}
LIBGIT2_DIR="${SOURCE_DIR}/libgit2"
BUILD_DIR=$(pwd)
SHA=${SHA:-$(git --git-dir="${LIBGIT2_DIR}/.git" rev-parse --short=7 HEAD)}

LIBGIT2_BASENAME="git2-${SHA}"

if [[ $(uname -s) == "Darwin" ]]; then
    LIBGIT2_FILENAME="lib${LIBGIT2_BASENAME}.dylib"
else
    LIBGIT2_FILENAME="lib${LIBGIT2_BASENAME}.so"
fi

cmake "${LIBGIT2_DIR}" \
      -DCMAKE_BUILD_TYPE=Release \
      -DBUILD_CLAR=OFF \
      -DUSE_SSH=OFF \
      -DUSE_BUNDLED_ZLIB=ON \
      -DLIBGIT2_FILENAME="${LIBGIT2_BASENAME}"
cmake --build .

echo "##vso[task.setvariable variable=libgit2.outputdir]${BUILD_DIR}"
echo "##vso[task.setvariable variable=libgit2.libraryname]${LIBGIT2_FILENAME}"
