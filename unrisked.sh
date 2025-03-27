#!/bin/sh

ignore=('android-cmake'
        'android-configure'
        'android-environment'
        'android-libdovi'
        'android-librsvg'
        'android-meson'
        'android-pcre'
        'android-pkg-config'
        'android-rav1e'
        'android-rust')

isPackageignored() {
    for pkg in "${ignore[@]}"; do
        if [ "$pkg" == "$1" ]; then
            return 1
        fi
    done

    return 0
}

IFS=$'\n'

for d in $(ls | grep '^android-'); do
    isPackageignored $d

    if [ "$?" == 1 ]; then
        continue
    fi

    if [ ! -e $d/android-riscv64-* ]; then
        echo $d
    elif [ ! -e $d/android-riscv64-*/.git ]; then
        echo $d !
    fi
done
