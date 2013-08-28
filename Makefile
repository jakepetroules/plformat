all:
	xcrun -sdk macosx clang -Wall plformat.m -framework Foundation -o plformat

clean:
	rm -f plformat

test:	all
	plutil -convert json test.plist
	./plformat test.plist
	plutil -convert binary1 test.plist
	./plformat test.plist
	plutil -convert xml1 test.plist
	./plformat test.plist
