# my makefile

#include MKCONF

VERSION = 0.0.1
TARNAME = proga-${VERSION}.tar.gz
BINS = main
#DLLS = main.so
OBJS_MAIN = main.o
OBJS_ALL = ${OBJS_MAIN}
#INCLUDEDIR = -I./inc

all: ${BINS} ${DLLS}

.SUFFIXES: .cxx .so

.c.o:
	gcc -Wall -pipe -c ${INCLUDEDIR} -DVERSION=${VERSION} -o $*.o $<

.cxx.o:
	g++ -Wall -pipe -c ${INCLUDEDIR} -DVERSION=${VERSION} -o $*.o $<
        
.o.so: $<
	gcc -Wall -pipe -shared -nostartfiles -nostdlib -o $@ $^

main: ${OBJS_MAIN}
	gcc -o $@ $^
#	gcc -rdynamic -ldl -lpthread -o $@ $^
#	strip $@

#---------------------------------------------------------------------------
.PHONY: clean
clean:
	-rm -f ${OBJS_ALL} ${BINS} ${DLLS} .depend core

tgz: clean
	rm -f ${TARNAME}
	tar czf ${TARNAME} *

#install:
#	install -d ${DIR_BINS}
#	install -d ${DIR_LIBS}
#	install -s -m 500 ${BINS} ${DIR_BINS}
#	install    -m 500 ${DLLS} ${DIR_LIBS}

.depend:
	gcc -MM -MG *.c *.cxx >.depend

ifeq (.depend,$(wildcard .depend))
include .depend
endif



