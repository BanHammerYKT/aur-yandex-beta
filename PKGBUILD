# Maintainer: Vladimir Kamensky  <mastersoft24@yandex.ru>



_pkgname=browser-beta
pkgname=yandex-${_pkgname}
pkgver=25.4.1.1017_1
_pkgver=25.4.1.1017-1
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
sha256sums=("e97236bed54b0f77bf2382b46dd13d31618b5ab7572284caa8ac55a55d93709d")
install=yandex-browser.install

prepare() {
    tar -xf data.tar.xz
}

package() {
    cp -dr --no-preserve=ownership opt usr "${pkgdir}"/
    install -D -m0644 "${pkgdir}"/opt/yandex/${_pkgname}/product_logo_128.png "${pkgdir}"/usr/share/pixmaps/${pkgname}.png
    chmod 4755 "${pkgdir}"/opt/yandex/${_pkgname}/yandex_browser-sandbox
}
