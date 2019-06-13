#!/bin/sh

packages=('android-bzip2 bzip2'
          'android-ffmpeg ffmpeg'
          'android-giflib giflib'
          'android-lame lame'
          'android-libjpeg-turbo libjpeg-turbo'
          'android-libogg libogg'
          'android-libtheora libtheora'
          'android-libvorbis libvorbis'
          'android-libvpx libvpx'
          'android-opus opus'
          'android-qt5 qt5-base'
          'android-speex speex'
          'android-speexdsp speexdsp'
          'android-xz xz'
          'android-zlib zlib'
          'mingw-w64-ffmpeg-zeranoe ffmpeg')

export LC_ALL=C

for package in "${packages[@]}"; do
    pkg=$(echo $package | awk '{print $1}')
    pkg_ver=$(grep 'pkgver=' $pkg/PKGBUILD | awk -F'=' '{print $2}')
    pkg_orig=$(echo $package | awk '{print $2}')
    pkg_orig_ver=$(pacman -Si $pkg_orig | grep Version | awk '{print $3}' | cut -d "-" -f1 | cut -d ":" -f2)
    older_ver=$(printf "${pkg_ver}\n${pkg_orig_ver}" | sort -V | head -n 1)

    if [ "${older_ver}" = "${pkg_orig_ver}" ]; then
        echo -e "$pkg \e[32m$pkg_ver\e[0m"
    else
        echo -e "$pkg \e[31m$pkg_ver -> ${pkg_orig_ver}\e[0m"
    fi
done
