PKGBASE = qt5
ARCHS = aarch64 armv7a-eabi x86 x86-64
MKDIR = mkdir -pv
COPY = cp -vf
REMOVE = rm -vf
RMDIR = rm -rvf
LINK = ln -fvs
DOWNLOAD = wget -c
MAKEPKG = MAKEFLAGS=-j4 makepkg -s

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
			$(REMOVE) PKGBUILD; \
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
	pkgver=$$(grep '^pkgver=' PKGBUILD | awk -F '=' '{print $$2}'); \
	fileName=qt-everywhere-src-$$pkgver.tar.xz; \
	if [ ! -f $$fileName ]; then \
		$(DOWNLOAD) http://download.qt-project.org/official_releases/qt/$${pkgver:0:4}/$$pkgver/single/$$fileName; \
	fi; \
	for arch in $(ARCHS); do \
		pkgfolder=android-$$arch-$(PKGBASE); \
		$(MKDIR) $$pkgfolder; \
		$(LINK) "$$PWD/$$fileName" $$pkgfolder/$$fileName; \
		$(COPY) *.patch $$pkgfolder; \
		$(COPY) .gitignore $$pkgfolder; \
		$(COPY) android-qt5.install $$pkgfolder/android-$$arch-qt5.install; \
		sed "s/_android_arch=/_android_arch=$$arch/g" PKGBUILD > $$pkgfolder/PKGBUILD; \
	done

install:
	pkgver=$$(grep '^pkgver=' PKGBUILD | awk -F '=' '{print $$2}'); \
	pkgrel=$$(grep '^pkgrel=' PKGBUILD | awk -F '=' '{print $$2}'); \
	for arch in $(ARCHS); do \
		pacman -U android-$$arch-qt5/android-$$arch-qt5-$$pkgver-$$pkgrel-x86_64.pkg.tar.xz --noconfirm; \
	done
