#!/bin/bash

LOCAL_VERSION=""
REPO_VERSION=""
LOCAL_FORMATTED_VERSION=""
REPO_FORMATTED_VERSION=""
REPO_DEB_URL="https://repo.yandex.ru/yandex-browser/deb/pool/main/y/yandex-browser-beta/yandex-browser-beta_%version%_amd64.deb"


# format version AA.B.C.DDD-E to AABBCCDDDDEE
getformattedversion() {
    version=$1
    IFS='.-' read -r -a parts <<< "$version"
    formatted_version=$(printf "%02d%02d%02d%04d%02d" "${parts[0]}" "${parts[1]}" "${parts[2]}" "${parts[3]}" "${parts[4]}")
    echo "$formatted_version"
}

# get formatted version from PKGBUILD
getlocalversion() {
    version=$(cat .SRCINFO | grep 'pkgver = ' | cut -d '=' -f 2 | sed "s/_/-/g;s/ //g")
    echo "$version"
}

# get formatted version from repo
getrepoversion() {
    html=$(curl -ks "https://repo.yandex.ru/yandex-browser/deb/pool/main/y/yandex-browser-beta/")
    version=$(echo $html | grep -oP '"yandex-browser-beta_\K.+?(?=_)' | sort -V | tail -n 1)
    echo "$version"
}

updatelocalrepo() {
    curl -LO "$REPO_DEB_URL"
    debfile=$(basename "$REPO_DEB_URL")
    if [[ ! -f "$debfile" ]]; then
        echo "Error: file '$debfile' not found." >&2
        return 1
    fi
    sha256=$(sha256sum $debfile | cut -d ' ' -f 1)
    pkgversion=$(echo "$REPO_VERSION" | sed "s/-/_/")
    sed -i "s/^_pkgver=.*/_pkgver=$REPO_VERSION/" PKGBUILD
    sed -i "s/^pkgver=.*/pkgver=$pkgversion/" PKGBUILD
    sed -i "s/^sha256sums=.*/sha256sums=\(\""$sha256"\"\)/" PKGBUILD
    sed -i "s/pkgver = .*/pkgver = $pkgversion/" .SRCINFO
    sed -i "s/sha256sums = .*/sha256sums = "$sha256"/" .SRCINFO
}

LOCAL_VERSION=$(getlocalversion)
REPO_VERSION=$(getrepoversion)

if [[ -z "$REPO_VERSION" ]]; then
    echo "Error: Could not retrieve the remote version." >&2
    exit 1
fi

LOCAL_FORMATTED_VERSION=$(getformattedversion $LOCAL_VERSION)
REPO_FORMATTED_VERSION=$(getformattedversion $REPO_VERSION)
REPO_DEB_URL=$(echo $REPO_DEB_URL | sed "s/\%version\%/$REPO_VERSION/")
echo "Local version: $LOCAL_VERSION"
echo "Repo version: $REPO_VERSION"
echo "Local formatted version: $LOCAL_FORMATTED_VERSION"
echo "Repo formatted version: $REPO_FORMATTED_VERSION"
echo "Repo deb url: $REPO_DEB_URL"

if (($LOCAL_FORMATTED_VERSION < $REPO_FORMATTED_VERSION)); then
    echo "New version detected. Updating local repo ..."
    updatelocalrepo
    echo "REPO_VERSION=$REPO_VERSION" >> "$GITHUB_OUTPUT"
else
    echo "No new version detected."
fi
