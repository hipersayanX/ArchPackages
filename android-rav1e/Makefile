ARCHS = aarch64 armv7a-eabi x86 x86-64
MKDIR = mkdir -pv
COPY = cp -vf
REMOVE = rm -vf
RMDIR = rm -rvf
LINK = ln -fvs
DOWNLOAD = wget -c
MAKEPKG = MAKEFLAGS=-j4 makepkg -sf
MAKEPKGDO = makepkg -do
LOCALREPONAME = local-packages
LOCALREPOARCH = any
LOCALREPO = ${HOME}/.arch-repo
LOCALREPODIR = $(LOCALREPO)/$(LOCALREPONAME)/os/$(LOCALREPOARCH)
LOCALDB = $(LOCALREPODIR)/$(LOCALREPONAME).db.tar.zst
FILE_PASSWORD =
BASE_PACKAGES = android-cmake android-configure android-environment android-meson android-pkg-config
AUR_BASE_PACKAGES = android-ndk android-platform-21 android-platform-24 android-platform android-sdk android-sdk-build-tools android-sdk-platform-tools

all: prepare
	lines=$$(grep -n 'build() {' $$PWD/PKGBUILD | awk -F: '{print $$1}'); \
	lines=$$(echo "$$lines - 1" | bc); \
	pkgBuildLines=$$(head -n $$lines $$PWD/PKGBUILD); \
	pkgnameLine="$$pkgBuildLines;"$$'\n'"echo \$${pkgname[0]}"; \
	pkgname=$$(echo "$$pkgnameLine" | sh); \
	pkgname=$${pkgname//android--/}; \
	set -e; \
	for arch in $(ARCHS); do \
		pkgfolder=android-$$arch-$$pkgname; \
		pushd $$pkgfolder; \
		$(MAKEPKG); \
		mkdir -p "$(LOCALREPODIR)"; \
		cp -vf android-$$arch-*.pkg.tar.zst "$(LOCALREPODIR)/"; \
		repo-add -Rnp "$(LOCALDB)" android-$$arch-*.pkg.tar.zst; \
		popd; \
	done

.PHONY: clean

clean:
	lines=$$(grep -n 'build() {' $$PWD/PKGBUILD | awk -F: '{print $$1}'); \
	lines=$$(echo "$$lines - 1" | bc); \
	pkgBuildLines=$$(head -n $$lines $$PWD/PKGBUILD); \
	pkgnameLine="$$pkgBuildLines;"$$'\n'"echo \$${pkgname[0]}"; \
	pkgname=$$(echo "$$pkgnameLine" | sh); \
	pkgname=$${pkgname//android--/}; \
	for arch in $(ARCHS) ; do \
		pushd android-$$arch-$$pkgname; \
			$(RMDIR) pkg; \
			$(RMDIR) src; \
			$(RMDIR) $$pkgname; \
			$(REMOVE) *.sig; \
			$(REMOVE) *.sign; \
			$(REMOVE) *.asc; \
			$(REMOVE) *.tgz; \
			$(REMOVE) *.bz2; \
			$(REMOVE) *.gz; \
			$(REMOVE) *.xz; \
			$(REMOVE) *.zst; \
			$(REMOVE) *.zip; \
			$(REMOVE) *.lzma; \
		popd; \
	done

publish:
	lines=$$(grep -n 'build() {' $$PWD/PKGBUILD | awk -F: '{print $$1}'); \
	lines=$$(echo "$$lines - 1" | bc); \
	pkgBuildLines=$$(head -n $$lines $$PWD/PKGBUILD); \
	pkgnameLine="$$pkgBuildLines;"$$'\n'"echo \$${pkgname[0]}"; \
	pkgname=$$(echo "$$pkgnameLine" | sh); \
	pkgname=$${pkgname//android--/}; \
	for arch in $(ARCHS); do \
		pkgfolder=android-$$arch-$$pkgname; \
		cd $$pkgfolder; \
		mksrcinfo; \
		git add .; \
		cd ..; \
	done

prepare: PKGBUILD
	lines=$$(grep -n 'build() {' $$PWD/PKGBUILD | awk -F: '{print $$1}'); \
	lines=$$(echo "$$lines - 1" | bc); \
	pkgBuildLines=$$(head -n $$lines $$PWD/PKGBUILD); \
	pkgnameLine="$$pkgBuildLines;"$$'\n'"echo \$${pkgname[0]}"; \
	pkgname=$$(echo "$$pkgnameLine" | sh); \
	pkgname=$${pkgname//android--/}; \
	srcUrlLine="$$pkgBuildLines;"$$'\n'"echo \$${source[0]}"; \
	srcUrl=$$(echo "$$srcUrlLine" | sh); \
	pkgFilesLine="$$pkgBuildLines;"$$'\n'"echo \$${source[*]}"; \
	pkgFiles=$$(echo "$$pkgFilesLine" | sh); \
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
		$(REMOVE) $$pkgfolder/*.patch; \
		$(MKDIR) $$pkgfolder; \
		for f in $$pkgFiles; do \
			if [ -e $$f ]; then \
				$(COPY) $$f $$pkgfolder; \
			fi; \
		done; \
		$(COPY) .gitignore $$pkgfolder; \
		$(COPY) android-$$pkgname.install $$pkgfolder/android-$$arch-$$pkgname.install; \
		$(COPY) PKGBUILD $$pkgfolder; \
		sed -i "s/_android_arch=/_android_arch=$$arch/g" $$pkgfolder/PKGBUILD; \
		sed -i "s/package_android-$$pkgname/package_android-$$arch""-$$pkgname/g" $$pkgfolder/PKGBUILD; \
		if [[ ! "$$srcUrl" =~ ^git\+.* ]]; then \
			$(LINK) ../$$fileName $$pkgfolder/$$fileName; \
			sed -i "s/$$checksum""s=('SKIP'/$$checksum""s=('$$sum'/g" $$pkgfolder/PKGBUILD; \
		fi; \
	done

do:
	lines=$$(grep -n 'build() {' $$PWD/PKGBUILD | awk -F: '{print $$1}'); \
	lines=$$(echo "$$lines - 1" | bc); \
	pkgBuildLines=$$(head -n $$lines $$PWD/PKGBUILD); \
	pkgnameLine="$$pkgBuildLines;"$$'\n'"echo \$${pkgname[0]}"; \
	pkgname=$$(echo "$$pkgnameLine" | sh); \
	pkgname=$${pkgname//android--/}; \
	set -e; \
	for arch in $(ARCHS); do \
		pkgfolder=android-$$arch-$$pkgname; \
		pushd $$pkgfolder; \
		$(MAKEPKGDO); \
		popd; \
	done;

install:
	lines=$$(grep -n 'build() {' $$PWD/PKGBUILD | awk -F: '{print $$1}'); \
	lines=$$(echo "$$lines - 1" | bc); \
	pkgBuildLines=$$(head -n $$lines $$PWD/PKGBUILD); \
	pkgnameLine="$$pkgBuildLines;"$$'\n'"echo \$${pkgname[0]}"; \
	pkgname=$$(echo "$$pkgnameLine" | sh); \
	pkgname=$${pkgname//android--/}; \
	set -e; \
	for arch in $(ARCHS); do \
		pacman -U android-$$arch-$$pkgname/android-$$arch-*.pkg.tar.zst --noconfirm; \
	done

repo:
	lines=$$(grep -n 'build() {' $$PWD/PKGBUILD | awk -F: '{print $$1}'); \
	lines=$$(echo "$$lines - 1" | bc); \
	pkgBuildLines=$$(head -n $$lines $$PWD/PKGBUILD); \
	pkgnameLine="$$pkgBuildLines;"$$'\n'"echo \$${pkgname[0]}"; \
	pkgname=$$(echo "$$pkgnameLine" | sh); \
	pkgname=$${pkgname//android--/}; \
	for arch in $(ARCHS); do \
		git clone ssh://aur@aur.archlinux.org/android-$$arch-$$pkgname.git; \
	done

localrepo:
	mkdir -p "$(LOCALREPODIR)"; \
	repo-add "$(LOCALDB)"

localrepoadd:
	mkdir -p "$(LOCALREPODIR)"; \
	lines=$$(grep -n 'build() {' $$PWD/PKGBUILD | awk -F: '{print $$1}'); \
	lines=$$(echo "$$lines - 1" | bc); \
	pkgBuildLines=$$(head -n $$lines $$PWD/PKGBUILD); \
	pkgnameLine="$$pkgBuildLines;"$$'\n'"echo \$${pkgname[0]}"; \
	pkgname=$$(echo "$$pkgnameLine" | sh); \
	pkgname=$${pkgname//android--/}; \
	set -e; \
	for arch in $(ARCHS); do \
		cp -vf android-$$arch-$$pkgname/android-$$arch-*.pkg.tar.zst "$(LOCALREPODIR)/"; \
		repo-add -Rnp "$(LOCALDB)" android-$$arch-$$pkgname/android-$$arch-*.pkg.tar.zst; \
	done

gitinit:
	lines=$$(grep -n 'build() {' $$PWD/PKGBUILD | awk -F: '{print $$1}'); \
	lines=$$(echo "$$lines - 1" | bc); \
	pkgBuildLines=$$(head -n $$lines $$PWD/PKGBUILD); \
	pkgnameLine="$$pkgBuildLines;"$$'\n'"echo \$${pkgname[0]}"; \
	pkgname=$$(echo "$$pkgnameLine" | sh); \
	pkgname=$${pkgname//android--/}; \
	set -e; \
	for arch in $(ARCHS); do \
		mkdir -p "android-$$arch-$$pkgname"; \
		cd "android-$$arch-$$pkgname"; \
		git -c init.defaultBranch=master init; \
		git remote add origin ssh://aur@aur.archlinux.org/android-$$arch-$$pkgname.git; \
		git branch --set-upstream-to=upstream/master master; \
		cd ..; \
	done

basepackages:
	set -e; \
	for package in $(BASE_PACKAGES); do \
		pushd $$package; \
		$(MAKEPKG); \
		mkdir -p "$(LOCALREPODIR)"; \
		cp -vf $$package-*.pkg.tar.zst "$(LOCALREPODIR)/"; \
		repo-add -Rnp "$(LOCALDB)" $$package-*.pkg.tar.zst; \
		rm -rvf pkg src $$package-*.pkg.tar.zst; \
		popd; \
	done; \
	for package in $(AUR_BASE_PACKAGES); do \
		git clone https://aur.archlinux.org/$$package.git /tmp/$$package; \
		pushd /tmp/$$package; \
		$(MAKEPKG); \
		mkdir -p "$(LOCALREPODIR)"; \
		cp -vf $$package-*.pkg.tar.zst "$(LOCALREPODIR)/"; \
		repo-add -Rnp "$(LOCALDB)" $$package-*.pkg.tar.zst; \
		popd; \
		rm -rvf /tmp/$$package; \
	done; \

package:
	if [ -z "$(FILE_PASSWORD)" ] ; then \
		7z a "arch-repo-$(LOCALREPONAME).7z" "${LOCALREPO}"/* ; \
	else \
		7z a -p"$(FILE_PASSWORD)" "arch-repo-$(LOCALREPONAME).7z" "${LOCALREPO}"/* ; \
	fi
