CC=gcc
default:

	$(CC) -L. -lJTool -mmacosx-version-min=10.6 -DLP64 -Wall wifi.c nstat.c procexp.c power.c gestalt.c processor.c -o procexp -lcurses -g2 -framework CoreFoundation -framework IOKit -g2

static:
	$(CC) -DLP64 -I../JTool -L.  -mmacosx-version-min=10.6 -DLP64 -Wall disass.c sha1.c gestalt.c decorate.c arm64.c arm32.c common.c machlib.c wifi.c nstat.c procexp.c power.c processor.c -o procexp -lcurses -g2 -framework CoreFoundation -framework IOKit -g2

arm64static:
	gcc-iphone -DLP64 decorate.c -I../JTool -L.  -DARM -Wall disass.c sha1.c gestalt.c arm64.c arm32.c common.c machlib.c wifi.c nstat.c procexp.c power.c processor.c -o procexp.arm64 -lcurses -g2 -framework CoreFoundation -framework IOKit -g2
	ldid -Sent.xml procexp.arm64

armstatic:
	gcc-armv7  decorate.c -I../JTool -L.  -DARM -Wall disass.c sha1.c gestalt.c arm64.c arm32.c common.c machlib.c wifi.c nstat.c procexp.c power.c processor.c -o procexp.armv7 -lcurses -g2 -framework CoreFoundation -framework IOKit -g2
	ldid -Sent.xml procexp.armv7

arm:
	gcc-iphone armv7 -DARM -Wall *.c -o procexp.arm -lcurses -framework CoreFoundation -framework IOKit -L. -I../JTool
	ldid -Sent.xml procexp.arm


dist:	static arm64static armstatic
	lipo -create -arch arm procexp.armv7 -arch arm64v8 procexp.arm64 -arch x86_64 procexp -output procexp.universal
	tar cvf procexp.tar libJTool.dylib procexp.1 procexp.universal README WhatsNew.txt Makefile 78/xterm-256color


backup:
	tar cvf ~/procexp.$(shell date +%y.%m.%d).tar libjmacho.dylib *
