CC=gcc
all: arm osx
	lipo -create -arch arm arm/jtool  -arch x86_64 x86_64/jtool -output jtool
	lipo -create -arch arm arm/libJTool.dylib -arch x86_64 x86_64/libJTool.dylib -output libJTool.dylib
	# Update version
	@./incrementVersion
 


debug:
	$(CC)  -mmacosx-version-min=10.6 -Wall sha1.c companion.c  jtool.c decorate.c disass.c machlib.c common.c  arm32.c arm64.c -o jtool -g2

static:
	$(CC)  -mmacosx-version-min=10.6 -Wall sha1.c companion.c  jtool.c decorate.c disass.c machlib.c common.c  arm32.c arm64.c -o jtool.x64  -g2
	cp jtool.x64 jtool

static108:
	$(CC)   -Wall sha1.c  jtool.c decorate.c disass.c machlib.c common.c  companion.c arm32.c arm64.c -o jtool.x64.108
arm64:
	gcc-iphone5s -DARM -Wall  jtool.c decorate.c machlib.c disass.c sha1.c common.c companion.c arm32.c arm64.c -o jtool.armv8

armstatic64:
	gcc-iphone -DARM -Wall sha1.c  jtool.c decorate.c machlib.c disass.c common.c companion.c arm64.c arm32.c -o jtool.arm64

armstatic32:
	gcc-armv7  -DARM -Wall sha1.c  jtool.c decorate.c machlib.c disass.c common.c companion.c arm64.c arm32.c -o jtool.arm32

universal: static armstatic64 armstatic32
	lipo -create -arch armv7 jtool.arm32 -arch arm64v8 jtool.arm64 -arch x86_64 jtool.x64 -output jtool

osx:
	$(CC) disass.c sha1.c machlib.c common.c pelib.c arm32.c arm64.c -shared -dynamic -o libJTool.dylib -g2
	cp libJTool.dylib x86_64/libJTool.dylib 
	@echo SO FAR SO GOOD
	$(CC) -mmacosx-version-min=10.6 -Wall  jtool.c decorate.c -L . -o x86_64/jtool -g2  -l jtool

arm:
	gcc-iphone armv7 -DARM machlib.c common.c pelib.c arm64.c -shared -dynamic -o libJTool.dylib
	cp ./libJTool.dylib arm/libJTool.dylib 
	gcc-iphone armv7 -DARM -Wall  jtool.c decorate.c -l JTool -L . -o arm/jtool -g2

linux32:
	$(CC) -m32 -D__DARWIN_UNIX03 -I./include -DLINUX -Wall companion.c  jtool.c decorate.c elflib.c arm64.c common.c machlib.c pelib.c sha1.c  arm32.c disass.c -o jtool.ELF32 -g2
linux:
	$(CC)  -D__DARWIN_UNIX03 -I./include -DLINUX -Wall companion.c  jtool.c decorate.c elflib.c arm64.c common.c machlib.c pelib.c sha1.c  arm32.c disass.c -o jtool.ELF -g2

joker:
	$(CC) -I./include joker.c machlib.c common.c  arm32.c arm64.c -o joker1 -framework CoreFoundation

clean:
	rm -fR libJTool.dylib jtool *.o x86_64 jtool.x64

backup:
	tar cvf ~/jtool.`date +%d%m%y`.tar *.c *.h 2.DO *.1 Makefile WhatsNew.txt

dist: 
	tar cvf jtool.tar Makefile jtool.1 jtool.universal jtool.ELF* WhatsNew.txt
	

