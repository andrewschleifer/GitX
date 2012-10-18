SOURCE=src/*

DATE=`date +"%Y.%m.%d"`
BUILD=`git log --oneline | wc -l`
COMMIT=`git rev-parse --verify HEAD`

DEFAULT: debug

debug: debug-build
	./build/Debug/GitX.app/Contents/MacOS/GitX
debug-build: $(SOURCE)
	xcodebuild -configuration Debug build OBJROOT=build SYMROOT=build

release: release-app
	git tag -a $(DATE) -m"$(DATE)"
	cd build/Release && zip -9r ../../GitX-$(DATE).zip GitX.app
release-app: release-build
	/usr/libexec/PlistBuddy \
		-c "Set :CFBundleShortVersionString $(DATE)" \
		-c "Set :CFBundleGitVersionString $(COMMIT)" \
		-c "Set :CFBundleVersion $(BUILD)" \
		build/Release/GitX.app/Contents/Info.plist
release-build: $(SOURCE)
	xcodebuild -configuration Release build OBJROOT=build SYMROOT=build

clobber:
	rm -r build

