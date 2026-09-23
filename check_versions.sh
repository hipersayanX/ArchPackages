#!/bin/sh

packages=('android-a52dec a52dec'
          'android-abseil-cpp abseil-cpp'
          'android-aom aom'
          'android-argparse argparse'
          'android-brotli brotli'
          'android-bzip2 bzip2'
          'android-cdparanoia cdparanoia'
          'android-cmocka cmocka'
          'android-cracklib cracklib'
          'android-dav1d dav1d'
          'android-eigen eigen'
          'android-expat expat'
          'android-faac faac'
          'android-ffmpeg ffmpeg'
          'android-fftw fftw'
          'android-flac flac'
          'android-fmt fmt'
          'android-fontconfig fontconfig'
          'android-freetype2 freetype2'
          'android-fribidi fribidi'
          'android-gettext gettext'
          'android-giflib giflib'
          'android-glib2 glib2'
          'android-gmp gmp'
          'android-gnutls gnutls'
          'android-graphite graphite'
          'android-gsm gsm'
          'android-gtest gtest'
          'android-jbigkit jbigkit'
          'android-json-c json-c'
          'android-judy judy'
          'android-kmod kmod'
          'android-l-smash l-smash'
          'android-lame lame'
          'android-lcms2 lcms2'
          'android-libasyncns libasyncns'
          'android-libavc1394 libavc1394'
          'android-libdatrie libdatrie'
          'android-libdv libdv'
          'android-libffi libffi'
          'android-libiconv libiconv'
          'android-libidn2 libidn2'
          'android-libiec61883 libiec61883'
          'android-libjpeg-turbo libjpeg-turbo'
          'android-libmodplug libmodplug'
          'android-libmp4v2 libmp4v2'
          'android-libmpeg2 libmpeg2'
          'android-libnl libnl'
          'android-libogg libogg'
          'android-libpng libpng'
          'android-libraw1394 libraw1394'
          'android-libshout libshout'
          'android-libsoxr libsoxr'
          'android-libssh libssh'
          'android-libssh2 libssh2'
          'android-libtasn1 libtasn1'
          'android-libthai libthai'
          'android-libtheora libtheora'
          'android-libtiff libtiff'
          'android-libtool libtool'
          'android-libtpms libtpms'
          'android-libudfread libudfread'
          'android-libunistring libunistring'
          'android-libvorbis libvorbis'
          'android-libvpx libvpx'
          'android-libwebm libwebm'
          'android-libwebp libwebp'
          'android-libxcrypt libxcrypt'
          'android-libxml2 libxml2'
          'android-lz4 lz4'
          'android-lzo lzo'
          'android-mpg123 mpg123'
          'android-nettle nettle'
          'android-npth npth'
          'android-opencore-amr opencore-amr'
          'android-openjpeg2 openjpeg2'
          'android-openssl openssl'
          'android-opentimelineio opentimelineio'
          'android-opus opus'
          'android-p11-kit p11-kit'
          'android-pcre pcre'
          'android-pcre2 pcre2'
          'android-popt popt'
          'android-qt6-base qt6-base'
          'android-qt6-declarative qt6-declarative'
          'android-qt6-imageformats qt6-imageformats'
          'android-qt6-multimedia qt6-multimedia'
          'android-qt6-shadertools qt6-shadertools'
          'android-qt6-svg qt6-svg'
          'android-qt6-tools qt6-tools'
          'android-rav1e rav1e'
          'android-snappy snappy'
          'android-speex speex'
          'android-speexdsp speexdsp'
          'android-sqlite sqlite'
          'android-srt srt'
          'android-svt-av1 svt-av1'
          'android-tcl tcl'
          'android-termcap termcap'
          'android-unixodbc unixodbc'
          'android-vid.stab vid.stab'
          'android-vmaf vmaf'
          'android-wavpack wavpack'
          'android-x264 x264'
          'android-x264-bootstrap x264'
          'android-x265 x265'
          'android-xvidcore xvidcore'
          'android-xxhash xxhash'
          'android-xz xz'
          'android-zlib zlib'
          'android-zstd zstd'
          'weblate-wlc weblate-wlc')

export LC_ALL=C

for package in "${packages[@]}"; do
    pkg=$(echo $package | awk '{print $1}')
    pkgbuild="${PWD}/${pkg}/PKGBUILD"

    if [ ! -e "${pkgbuild}" ]; then
        echo -e "$pkg \e[31mmissing\e[0m"

        continue
    fi

    lines=$(grep -n 'build() {' "${pkgbuild}" | awk -F: '{print $1}')
    lines=$(echo "${lines} - 1" | bc)
    pkgBuildLines=$(head -n "${lines}" "${pkgbuild}")
    pkgverLine="${pkgBuildLines};"$'\n'"echo \${pkgver}"
    pkg_ver=$(echo "${pkgverLine}" | sh)
    pkg_orig=$(echo $package | awk '{print $2}')
    pkg_info=$(pacman -Si $pkg_orig 2>/dev/null)

    if [ "$?" = 0 ]; then
        pkg_orig_ver=$(echo "${pkg_info}" | grep 'Version\s*:' | awk '{print $3}' | cut -d "-" -f1 | cut -d ":" -f2)
        pkg_orig_ver=${pkg_orig_ver%%+*}
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
