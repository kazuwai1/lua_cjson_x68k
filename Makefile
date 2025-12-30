##### Available defines for CJSON_CFLAGS #####
##
## USE_INTERNAL_ISINF:      Workaround for Solaris platforms missing isinf().
## DISABLE_INVALID_NUMBERS: Permanently disable invalid JSON numbers:
##                          NaN, Infinity, hex.
##
## Optional built-in number conversion uses the following defines:
## USE_INTERNAL_FPCONV:     Use builtin strtod/dtoa for numeric conversions.
## IEEE_BIG_ENDIAN:         Required on big endian architectures.
## MULTIPLE_THREADS:        Must be set when Lua CJSON may be used in a
##                          multi-threaded application. Requries _pthreads_.

##### Build defaults #####
LUA_VERSION =       5.5
TARGET =            cjson.so
PREFIX =            ..
#CFLAGS =            -g -Wall -pedantic -fno-inline
CFLAGS =            -O3 -Wall -pedantic -DNDEBUG -g
CJSON_CFLAGS =      -fpic
CJSON_LDFLAGS =     -shared
LUA_INCLUDE_DIR ?=   $(PREFIX)/include
LUA_CMODULE_DIR ?=   $(PREFIX)/lib/lua/$(LUA_VERSION)
LUA_MODULE_DIR ?=    $(PREFIX)/share/lua/$(LUA_VERSION)
LUA_BIN_DIR ?=       $(PREFIX)/bin

AR= $(CC) -o

##### Platform overrides #####
##
## Tweak one of the platform sections below to suit your situation.
##
## See http://lua-users.org/wiki/BuildingModules for further platform
## specific details.

## Linux

## FreeBSD
#LUA_INCLUDE_DIR =   $(PREFIX)/include/lua51

## MacOSX (Macports)
#PREFIX =            /opt/local
#CJSON_LDFLAGS =     -bundle -undefined dynamic_lookup

## Solaris
#PREFIX =            /home/user/opt
#CC =                gcc
#CJSON_CFLAGS =      -fpic -DUSE_INTERNAL_ISINF

## Windows (MinGW)
#TARGET =            cjson.dll
#PREFIX =            /home/user/opt
#CJSON_CFLAGS =      -DDISABLE_INVALID_NUMBERS
#CJSON_LDFLAGS =     -shared -L$(PREFIX)/lib -llua51
#LUA_BIN_SUFFIX =    .lua

## Human68k (x68k)
LUA_VERSION = 5.5
TARGET = lua_cjson.l
PREFIX = ..
CC = gcc2
AR = oar -c
CFLAGS = -O2 -fomit-frame-pointer -fstrength-reduce -finline-functions -m68000 -Wall -pedantic -DNDEBUG
CJSON_CFLAGS =
CJSON_LDFLAGS =
LUA_INCLUDE_DIR =   $(PREFIX)/include
LUA_CMODULE_DIR =   $(PREFIX)/lib/lua/$(LUA_VERSION)
LUA_MODULE_DIR =    $(PREFIX)/share/lua/$(LUA_VERSION)
LUA_BIN_DIR =       $(PREFIX)/bin
LUA_BIN_SUFFIX =    .lua

##### Number conversion configuration #####

## Use Libc support for number conversion (default)
FPCONV_OBJS =       fpconv.o

## Use built in number conversion
#FPCONV_OBJS =       g_fmt.o dtoa.o
#CJSON_CFLAGS +=     -DUSE_INTERNAL_FPCONV

## Compile built in number conversion for big endian architectures
#CJSON_CFLAGS +=     -DIEEE_BIG_ENDIAN

## Compile built in number conversion to support multi-threaded
## applications (recommended)
#CJSON_CFLAGS +=     -pthread -DMULTIPLE_THREADS
#CJSON_LDFLAGS +=    -pthread

##### End customisable sections #####

TEST_FILES =        README bench.lua genutf8.pl test.lua octets-escaped.dat \
                    example1.json example2.json example3.json example4.json \
                    example5.json numbers.json rfc-example1.json \
                    rfc-example2.json types.json
DATAPERM =          644
EXECPERM =          755

ASCIIDOC =          asciidoc

BUILD_CFLAGS =      -I$(LUA_INCLUDE_DIR) $(CJSON_CFLAGS)
OBJS =              lua_cjson.o strbuf.o $(FPCONV_OBJS)

.PHONY: all clean install install-extra doc

.SUFFIXES: .html .adoc

.c.o:
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $(BUILD_CFLAGS) -o $@ $<

.adoc.html:
	$(ASCIIDOC) -n -a toc $<

all: $(TARGET)

doc: manual.html performance.html

$(TARGET): $(OBJS)
	$(AR) $(LDFLAGS) $(CJSON_LDFLAGS) $@ $(OBJS)
#	$(AR) $@ $(LDFLAGS) $(CJSON_LDFLAGS) $(OBJS)

install: $(TARGET)
	mkdir.x -p $(LUA_CMODULE_DIR)
	rm -f $(LUA_CMODULE_DIR)/$(TARGET)
	cp -p -m $(EXECPERM) $(TARGET) $(LUA_CMODULE_DIR)
	cp -p -m $(EXECPERM) $(TARGET) ../lib/

install-extra:
	mkdir.x -p $(LUA_MODULE_DIR)/cjson/tests $(LUA_BIN_DIR)
	cp -p -m $(DATAPERM) lua/cjson/util.lua $(LUA_MODULE_DIR)/cjson
	cp -p -m $(EXECPERM) lua/lua2json.lua $(LUA_BIN_DIR)/lua2json$(LUA_BIN_SUFFIX)
	cp -p -m $(EXECPERM) lua/json2lua.lua $(LUA_BIN_DIR)/json2lua$(LUA_BIN_SUFFIX)
#	cd tests; cp $(TEST_FILES) $(DESTDIR)$(LUA_MODULE_DIR)/cjson/tests
#	cd tests; chmod $(DATAPERM) $(TEST_FILES); chmod $(EXECPERM) *.lua *.pl

clean:
	rm -f $(OBJS) $(TARGET)

