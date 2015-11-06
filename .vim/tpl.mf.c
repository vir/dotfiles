# Use "gmake" on BSD and "make" on Linux

#include MKCONF

NAME = xxx
VERSION = 0.0.1
TARNAME = ${NAME}-${VERSION}.tar.gz
BINS = ${NAME}
#DLLS = ext.so
OBJS_MAIN = ${NAME}.o
OBJS_ALL = ${OBJS_MAIN}
PREFIX = /usr/local
#INCLUDEDIR = -I./inc

all: ${BINS} ${DLLS}

.SUFFIXES: .cxx .so

.c.o:
	gcc -Wall -pipe -c ${INCLUDEDIR} -DVERSION=${VERSION} -o $*.o $<

.cxx.o:
	g++ -Wall -pipe -c ${INCLUDEDIR} -DVERSION=${VERSION} -o $*.o $<

.o.so: $<
	gcc -Wall -pipe -shared -nostartfiles -nostdlib -o $@ $^

${NAME}: ${OBJS_MAIN}
	gcc -o $@ $^
#	gcc -rdynamic -ldl -lpthread -o $@ $^
#	strip $@

#---------------------------------------------------------------------------
.PHONY: clean
clean:
	-rm -f ${OBJS_ALL} ${BINS} ${DLLS} .depend core

tgz: clean
	rm -f ${TARNAME}
	tar czf --exclude '*.o' ${TARNAME} *

install:
	install -d ${DESTDIR}${PREFIX}/bin
	install -s ${BINS} ${DESTDIR}${PREFIX}/bin
#	install -d ${DESTDIR}${PREFIX}/lib
#	install    ${DLLS} ${DESTDIR}${PREFIX}/lib

.depend:
	gcc -MM -MG *.c *.cxx >.depend

ifeq (.depend,$(wildcard .depend))
include .depend
endif

# vim: ft=make

