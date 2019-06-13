PKGBASE = xz
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
	for arch in $(ARCHS); do \
		pkgfolder=android-$$arch-$(PKGBASE); \
		cd $$pkgfolder; \
		$(MAKEPKG); \
		cd ..; \
	done

.PHONY: clean

clean:
	for arch in $(ARCHS) ; do \
		pushd android-$$arch-$(PKGBASE); \
			$(RMDIR) pkg; \
			$(RMDIR) src; \
			$(RMDIR) $(PKGBASE); \
			$(REMOVE) *.tar.bz2; \
			$(REMOVE) *.tar.gz; \
			$(REMOVE) *.tar.xz; \
		popd; \
	done

publish:
	for arch in $(ARCHS); do \
		pkgfolder=android-$$arch-$(PKGBASE); \
		cd $$pkgfolder; \
		mksrcinfo; \
		git add .; \
		cd ..; \
	done

prepare: PKGBUILD
	srcUrl=$$(sh -c 'PATH="$$PWD/..:$$PATH" source $$PWD/PKGBUILD; echo $${source[0]}'); \
	fileName=$$(basename "$$srcUrl"); \
	if [ ! -f $$fileName ]; then \
		$(DOWNLOAD) "$$srcUrl"; \
	fi; \
	checksum=$$(grep '.sums=' PKGBUILD | awk -F 's=' '{print $$1}'); \
	sum=$$($$checksum $$fileName | awk '{print $$1}'); \
	for arch in $(ARCHS); do \
		pkgfolder=android-$$arch-$(PKGBASE); \
		$(MKDIR) $$pkgfolder; \
		$(LINK) ../$$fileName $$pkgfolder/$$fileName; \
		$(COPY) *.patch $$pkgfolder; \
		$(COPY) .gitignore $$pkgfolder; \
		$(COPY) android-$(PKGBASE).install $$pkgfolder/android-$$arch-$(PKGBASE).install; \
		$(COPY) PKGBUILD $$pkgfolder; \
		sed -i "s/_android_arch=/_android_arch=$$arch/g" $$pkgfolder/PKGBUILD; \
		sed -i "s/$$checksum""s=('SKIP'/$$checksum""s=('$$sum'/g" $$pkgfolder/PKGBUILD; \
	done

do:
	for arch in $(ARCHS); do \
		pkgfolder=android-$$arch-$(PKGBASE); \
		cd $$pkgfolder; \
		$(MAKEPKGDO); \
		cd ..; \
	done

install:
	pkgver=$$(grep '^pkgver=' PKGBUILD | awk -F '=' '{print $$2}'); \
	pkgrel=$$(grep '^pkgrel=' PKGBUILD | awk -F '=' '{print $$2}'); \
	for arch in $(ARCHS); do \
		pacman -U android-$$arch-$(PKGBASE)/android-$$arch-$(PKGBASE)-$$pkgver-$$pkgrel-*.pkg.tar.xz --noconfirm; \
	done

repo:
	for arch in $(ARCHS); do \
		git clone ssh://aur@aur.archlinux.org/android-$$arch-$(PKGBASE).git; \
	done
