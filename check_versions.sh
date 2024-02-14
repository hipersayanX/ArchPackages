#!/bin/sh

packages=('android-brotli brotli'
          'android-bzip2 bzip2'
          'android-cairo-bootstrap cairo'
          'android-expat expat'
          'android-ffmpeg ffmpeg'
          'android-fontconfig fontconfig'
          'android-freetype2-bootstrap freetype2'
          'android-fribidi fribidi'
          'android-gettext gettext'
          'android-giflib giflib'
          'android-glib2 glib2'
          'android-gmp gmp'
          'android-graphite graphite'
          'android-harfbuzz harfbuzz'
          'android-icu icu'
          'android-l-smash l-smash'
          'android-lame lame'
          'android-lcms2 lcms2'
          'android-libffi libffi'
          'android-libiconv libiconv'
          'android-libjpeg-turbo libjpeg-turbo'
          'android-libogg libogg'
          'android-libpng libpng'
          'android-libtasn1 libtasn1'
          'android-libtheora libtheora'
          'android-libtiff libtiff'
          'android-libunistring libunistring'
          'android-libvorbis libvorbis'
          'android-libvpx libvpx'
          'android-libwebp libwebp'
          'android-libxml2 libxml2'
          'android-lzo lzo'
          'android-ncurses ncurses'
          'android-openjpeg2 openjpeg2'
          'android-opus opus'
          'android-pcre pcre'
          'android-pcre2 pcre2'
          'android-pixman pixman'
          'android-readline readline'
          'android-speex speex'
          'android-speexdsp speexdsp'
          'android-termcap termcap'
          'android-x264 x264'
          'android-x264-bootstrap x264'
          'android-x265 x265'
          'android-xz xz'
          'android-zlib zlib'
          'weblate-wlc weblate-wlc')

export LC_ALL=C

for package in "${packages[@]}"; do
    pkg=$(echo $package | awk '{print $1}')
    lines=$(grep -n 'build() {' "${PWD}/${pkg}/PKGBUILD" | awk -F: '{print $1}')
    lines=$(echo "${lines} - 1" | bc)
    pkgBuildLines=$(head -n "${lines}" "${PWD}/${pkg}/PKGBUILD")
    pkgverLine="${pkgBuildLines};echo \${pkgver}"
    pkg_ver=$(echo "${pkgverLine}" | sh)
    pkg_orig=$(echo $package| awk '{print $2}')
    pkg_info=$(pacman -Si $pkg_orig 2>/dev/null)

    if [ "$?" = 0 ]; then
        pkg_orig_ver=$(echo "${pkg_info}" | grep Version | awk '{print $3}' | cut -d "-" -f1 | cut -d ":" -f2)
        older_ver=$(printf "${pkg_ver}\n${pkg_orig_ver}" | sort -V | head -n 1)

        if [ "${older_ver}" = "${pkg_orig_ver}" ]; then
            echo -e "$pkg \e[32m$pkg_ver\e[0m"
        else
            echo -e "$pkg \e[31m$pkg_ver -> ${pkg_orig_ver}\e[0m"
        fi
    else
        echo -e "$pkg \e[33m$pkg_ver !\e[0m"
    fi
done
