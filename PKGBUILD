# Maintainer: Vladimir Kamensky  <mastersoft24@yandex.ru>



_pkgname=browser-beta
pkgname=yandex-${_pkgname}
pkgver=24.10.4.648_1
_pkgver=24.10.4.648-1
pkgrel=1
#epoch=1

pkgdesc="The web browser from Yandex.
 Yandex Browser is a browser that combines a minimal design with sophisticated technology to make the web faster, safer, and easier."
arch=("x86_64")
license=("custom:yandex-browser")
categories=("network")

options=(!strip)
url=https://browser.yandex.com

depends=("flac" "gconf" "gtk2" "harfbuzz-icu" "libxss" "nss" "opus" "snappy" "ttf-font" "xdg-utils" "libxkbfile" "jq" )
optdepends=(
    "speech-dispatcher" 
    "ttf-liberation: fix fonts for some PDFs"
    "yandex-libffmpeg"
)

provides=(yandex-browser-beta)
conflicts=(yandex-browser-beta)

source=("${pkgname}-${pkgver}.deb::http://repo.yandex.ru/yandex-browser/deb/pool/main/y/yandex-browser-beta/yandex-browser-beta_${_pkgver}_amd64.deb")
sha256sums=("1a0176c2aa6d457a0f2caf7b9fda1ab68d3a93b949b9abcc45f2b2ba67666340")
install=yandex-browser.install

prepare() {
    tar -xf data.tar.xz
}

package() {
    cp -dr --no-preserve=ownership opt usr "${pkgdir}"/
    install -D -m0644 "${pkgdir}"/opt/yandex/${_pkgname}/product_logo_128.png "${pkgdir}"/usr/share/pixmaps/${pkgname}.png
    chmod 4755 "${pkgdir}"/opt/yandex/${_pkgname}/yandex_browser-sandbox
}
