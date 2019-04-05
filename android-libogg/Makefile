PKGBASE = libogg
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
	for arch in $(ARCHS); do \
		pkgfolder=android-$$arch-$(PKGBASE); \
		$(MKDIR) $$pkgfolder; \
		$(COPY) *.patch $$pkgfolder; \
		$(COPY) .gitignore $$pkgfolder; \
		$(COPY) ../android-env.sh $$pkgfolder; \
		$(COPY) PKGBUILD $$pkgfolder; \
		sed -i "s/_android_arch=/_android_arch=$$arch/g" $$pkgfolder/PKGBUILD; \
	done

do: prepare
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
		pacman -U android-$$arch-$(PKGBASE)/android-$$arch-$(PKGBASE)-$$pkgver-$$pkgrel-any.pkg.tar.xz --noconfirm; \
	done

repo:
	for arch in $(ARCHS); do \
		git clone ssh://aur@aur.archlinux.org/android-$$arch-$(PKGBASE).git; \
	done
