#!/bin/sh

packages=('android-brotli brotli'
          'android-bzip2 bzip2'
          'android-cairo cairo'
          'android-cairo-bootstrap cairo'
          'android-cmocka cmocka'
          'android-cracklib cracklib'
          'android-curl curl'
          'android-expat expat'
          'android-ffmpeg ffmpeg'
          'android-fontconfig fontconfig'
          'android-freetype2-bootstrap freetype2'
          'android-fribidi fribidi'
          'android-gdbm gdbm'
          'android-gettext gettext'
          'android-giflib giflib'
          'android-glib2 glib2'
          'android-gmp gmp'
          'android-gnutls gnutls'
          'android-graphite graphite'
          'android-harfbuzz harfbuzz'
          'android-hwdata hwdata'
          'android-hwloc hwloc'
          'android-icu icu'
          'android-jemalloc jemalloc'
          'android-json-c json-c'
          'android-judy judy'
          'android-kmod kmod'
          'android-l-smash l-smash'
          'android-lame lame'
          'android-lcms2 lcms2'
          'android-libassuan libassuan'
          'android-libevent libevent'
          'android-libfabric libfabric'
          'android-libffi libffi'
          'android-libgcrypt libgcrypt'
          'android-libgpg-error libgpg-error'
          'android-libiconv libiconv'
          'android-libidn2 libidn2'
          'android-libjpeg-turbo libjpeg-turbo'
          'android-libksba libksba'
          'android-libnghttp2 libnghttp2'
          'android-libnghttp3 libnghttp3'
          'android-libnl libnl'
          'android-libogg libogg'
          'android-libpciaccess libpciaccess'
          'android-libpsl libpsl'
          'android-libpng libpng'
          'android-libsasl libsasl'
          'android-libsasl-bootstrap libsasl'
          'android-libsodium libsodium'
          'android-libssh libssh'
          'android-libssh2 libssh2'
          'android-libtasn1 libtasn1'
          'android-libtheora libtheora'
          'android-libtiff libtiff'
          'android-libtool libtool'
          'android-libtpms libtpms'
          'android-libunistring libunistring'
          'android-liburing liburing'
          'android-libvorbis libvorbis'
          'android-libvpx libvpx'
          'android-libwebp libwebp'
          'android-libx11 libx11'
          'android-libxau libxau'
          'android-libxcb libxcb'
          'android-libxcrypt libxcrypt'
          'android-libxdmcp libxdmcp'
          'android-libxext libxext'
          'android-libxml2 libxml2'
          'android-libxrender libxrender'
          'android-lz4 lz4'
          'android-lzo lzo'
          'android-mariadb mariadb'
          'android-ncurses ncurses'
          'android-nettle nettle'
          'android-nspr nspr'
          'android-nss nss'
          'android-numactl numactl'
          'android-openjpeg2 openjpeg2'
          'android-openldap libldap'
          'android-openmpi openmpi'
          'android-openpmix openpmix'
          'android-opus opus'
          'android-p11-kit p11-kit'
          'android-pciutils pciutils'
          'android-pcre pcre'
          'android-pcre2 pcre2'
          'android-pixman pixman'
          'android-postgresql postgresql'
          'android-prrte prrte'
          'android-readline readline'
          'android-speex speex'
          'android-speexdsp speexdsp'
          'android-sqlite sqlite'
          'android-tcl tcl'
          'android-termcap termcap'
          'android-unixodbc unixodbc'
          'android-x264 x264'
          'android-x264-bootstrap x264'
          'android-x265 x265'
          'android-xcb-proto xcb-proto'
          'android-xorg-util-macros xorg-util-macros'
          'android-xorgproto xorgproto'
          'android-xtrans xtrans'
          'android-zstd zstd'
          'android-xz xz'
          'android-zlib zlib'
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
    pkg_orig=$(echo $package| awk '{print $2}')
    pkg_info=$(pacman -Si $pkg_orig 2>/dev/null)

    if [ "$?" = 0 ]; then
        pkg_orig_ver=$(echo "${pkg_info}" | grep Version | awk '{print $3}' | cut -d "-" -f1 | cut -d ":" -f2)
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
