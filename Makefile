PKGBASE = android-qt5
ARCHS = arm64-v8a armeabi-v7a x86 x86_64
MKDIR = mkdir -pv
COPY = cp -vf
REMOVE = rm -vf
RMDIR = rm -rvf
LINK = ln -fvs
DOWNLOAD = wget -c
MAKEPKG = MAKEFLAGS=-j4 makepkg -s

all: prepare
	for arch in $(ARCHS); do \
		pkgfolder=$(PKGBASE)-$$arch; \
		cd $$pkgfolder; \
		$(MAKEPKG); \
		cd ..; \
	done

.PHONY: clean

clean:
	for arch in $(ARCHS) ; do \
		pushd $(PKGBASE)-$$arch; \
			$(RMDIR) pkg; \
			$(RMDIR) src; \
			$(REMOVE) PKGBUILD; \
			$(REMOVE) *.tar.xz; \
		popd; \
	done

publish:
	for arch in $(ARCHS); do \
		pkgfolder=$(PKGBASE)-$$arch; \
		cd $$pkgfolder; \
		mksrcinfo; \
		git add .; \
		cd ..; \
	done

prepare: PKGBUILD
	_pkgfqn=$$(grep '_pkgfqn=' PKGBUILD | awk -F '=' '{print $$2}'); \
	pkgver=$$(grep '^pkgver=' PKGBUILD | awk -F '=' '{print $$2}'); \
	fileName=qt-everywhere-src-$$pkgver.tar.xz; \
	if [ ! -f $$fileName ]; then \
		$(DOWNLOAD) http://download.qt-project.org/official_releases/qt/$${pkgver:0:4}/$$pkgver/single/$$fileName; \
	fi; \
	for arch in $(ARCHS); do \
		pkgfolder=$(PKGBASE)-$$arch; \
		$(MKDIR) $$pkgfolder; \
		$(LINK) "$$PWD/$$fileName" $$pkgfolder/$$fileName; \
		sed "s/android_arch=/android_arch=$$arch/g" PKGBUILD > $$pkgfolder/PKGBUILD; \
	done
