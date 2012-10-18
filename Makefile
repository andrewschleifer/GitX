SOURCE=src/*

app: $(SOURCE)
	xcodebuild build OBJROOT=build SYMROOT=build

clean:
	xcodebuild -alltargets clean OBJROOT=build SYMROOT=build

