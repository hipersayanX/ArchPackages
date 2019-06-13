ARCHS = aarch64 armv7a-eabi x86 x86-64
MKDIR = mkdir -pv
COPY = cp -vf
REMOVE = rm -vf
RMDIR = rm -rvf
LINK = ln -fvs
DOWNLOAD = wget -c
MAKEPKG = MAKEFLAGS=-j4 makepkg -sf
MAKEPKGDO = makepkg -do

all: prepare
	pkgname=$$(grep '^pkgname=android-' "$$PWD/PKGBUILD" | sed 's/pkgname=android-$${_android_arch}-//'); \
	for arch in $(ARCHS); do \
		pkgfolder=android-$$arch-$$pkgname; \
		cd $$pkgfolder; \
		$(MAKEPKG); \
		cd ..; \
	done

.PHONY: clean

clean:
	pkgname=$$(grep '^pkgname=android-' "$$PWD/PKGBUILD" | sed 's/pkgname=android-$${_android_arch}-//'); \
	for arch in $(ARCHS) ; do \
		pushd android-$$arch-$$pkgname; \
			$(RMDIR) pkg; \
			$(RMDIR) src; \
			$(RMDIR) $$pkgname; \
			$(REMOVE) *.bz2; \
			$(REMOVE) *.gz; \
			$(REMOVE) *.xz; \
		popd; \
	done

publish:
	pkgname=$$(grep '^pkgname=android-' "$$PWD/PKGBUILD" | sed 's/pkgname=android-$${_android_arch}-//'); \
	for arch in $(ARCHS); do \
		pkgfolder=android-$$arch-$$pkgname; \
		cd $$pkgfolder; \
		mksrcinfo; \
		git add .; \
		cd ..; \
	done

prepare: PKGBUILD
	pkgname=$$(grep '^pkgname=android-' "$$PWD/PKGBUILD" | sed 's/pkgname=android-$${_android_arch}-//'); \
	srcUrl=$$(sh -c 'source $$PWD/PKGBUILD; echo $${source[0]}'); \
	fileName=$$(basename "$$srcUrl"); \
	if [ ! -f "$$fileName" ] && [[ ! "$$srcUrl" =~ ^git\+.* ]]; then \
		$(DOWNLOAD) "$$srcUrl"; \
	fi; \
	checksum=$$(grep '.sums=' PKGBUILD | awk -F 's=' '{print $$1}'); \
	if [[ ! "$$srcUrl" =~ ^git\+.* ]]; then \
		sum=$$($$checksum $$fileName | awk '{print $$1}'); \
	fi; \
	for arch in $(ARCHS); do \
		pkgfolder=android-$$arch-$$pkgname; \
		$(MKDIR) $$pkgfolder; \
		$(COPY) *.patch $$pkgfolder; \
		$(COPY) .gitignore $$pkgfolder; \
		$(COPY) android-$$pkgname.install $$pkgfolder/android-$$arch-$$pkgname.install; \
		$(COPY) PKGBUILD $$pkgfolder; \
		sed -i "s/_android_arch=/_android_arch=$$arch/g" $$pkgfolder/PKGBUILD; \
		if [[ ! "$$srcUrl" =~ ^git\+.* ]]; then \
			$(LINK) ../$$fileName $$pkgfolder/$$fileName; \
			sed -i "s/$$checksum""s=('SKIP'/$$checksum""s=('$$sum'/g" $$pkgfolder/PKGBUILD; \
		fi; \
	done

do:
	pkgname=$$(grep '^pkgname=android-' "$$PWD/PKGBUILD" | sed 's/pkgname=android-$${_android_arch}-//'); \
	for arch in $(ARCHS); do \
		pkgfolder=android-$$arch-$$pkgname; \
		cd $$pkgfolder; \
		$(MAKEPKGDO); \
		cd ..; \
	done

install:
	pkgname=$$(grep '^pkgname=android-' "$$PWD/PKGBUILD" | sed 's/pkgname=android-$${_android_arch}-//'); \
	pkgver=$$(grep '^pkgver=' PKGBUILD | awk -F '=' '{print $$2}'); \
	pkgrel=$$(grep '^pkgrel=' PKGBUILD | awk -F '=' '{print $$2}'); \
	for arch in $(ARCHS); do \
		pacman -U android-$$arch-$$pkgname/android-$$arch-$$pkgname-$$pkgver-$$pkgrel-*.pkg.tar.xz --noconfirm; \
	done

repo:
	pkgname=$$(grep '^pkgname=android-' "$$PWD/PKGBUILD" | sed 's/pkgname=android-$${_android_arch}-//'); \
	for arch in $(ARCHS); do \
		git clone ssh://aur@aur.archlinux.org/android-$$arch-$$pkgname.git; \
	done
