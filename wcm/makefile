# for -DDEBUG, and other local stuff
-include makefile.local

.SUFFIXES: .cpp .o

CC  ?= gcc
C++ ?= g++

CFLAGS+= -Wall -Wextra -D_FILE_OFFSET_BITS=64  -pthread -std=c++11
#CFLAGS+= -Werror
CFLAGS+= -I wal -I swl 
UNAME_S := $(shell uname -s)
ARCH    := $(shell $(CC) -dumpmachine)


ifneq (,$(findstring Darwin,$(UNAME_S)))
# make it buildable with XQuartz
CFLAGS += -I /opt/X11/include
CFLAGS += -I /opt/X11/include/freetype2 -D USEFREETYPE
LIBS   += -l freetype -lpthread
OS = MACOS
else ifneq (,$(findstring NT-,$(UNAME_S)))
#mingw env does not have this defined. 0x501 = NT
CFLAGS +=-D_WIN32_WINNT=0x501
LIBS   += 
LIBS   += -lssh2 -lws2_32 -lwsock32 -lssl -lcrypto
LIBS   += -lz 
LIBS   += -lmpr -lgdi32 -lcomdlg32 
LDFLAGS += -static -static-libgcc -static-libstdc++
OS = WINDOWS
else #ifneq (,$(findstring Linux,$(UNAME_S))) # everythig else falls under Linux
CFLAGS += -I /usr/local/include -I/usr/src/contrib/libstdc++/include/backward
LIBS   += -l ssh2 
LIBS   += -l smbclient
LIBS   += -l freetype
LIBS   += -l X11
LIBS   += -l pthread  
LIBS   += -L /usr/local/lib -L /usr/X11R6/lib
CFLAGS += -I /usr/include/freetype2 -I /usr/local/include/freetype2 -D USEFREETYPE
OS=LINUX
endif
LIBS += -lstdc++ #-l pthread

INSTALL_DIR = install -d
INSTALL_PROGRAM = install -c -m 755
INSTALL_TREE = cp -R
BIN_DIR=$(DESTDIR)/usr/bin
TARGET_DIR=$(DESTDIR)/usr/

ifdef DEBUG
	BLDOPTIM=debug
	CFLAGS+=-g -DDEBUG
	LDFLAGS+=-g
else
	BLDOPTIM=release
	CLFAGS+=-O2 -D_NDEBUG
endif

BUILD=$(OS)/$(CC)/$(ARCH)/$(BLDOPTIM)
$(info Build: $(BUILD))

OUTDIR=../build/$(BUILD)
OBJDIR=$(OUTDIR)/obj
VPATH=swl:wal:$(OBJDIR)

.PATH.cpp = .:swl:wal
.PATH.o = $(OBJDIR)

ifeq ($(OS),WINDOWS)
OUTBIN=$(OUTDIR)/wcm.exe
else
OUTBIN=$(OUTDIR)/wcm
endif

include makefile.objs

OBJNAMES=$(OBJS_COMMON)
ifeq ($(OS),WINDOWS)
OBJNAMES+=$(OBJS_WIN)
else
OBJNAMES+=$(OBJS_UX)
endif
OBJS=$(addprefix $(OBJDIR)/,$(OBJNAMES))

ifeq ($(OS),MACOS)
all: $(OUTBIN)
else ifeq ($(OS),WINDOWS)
all: $(OUTBIN)
else
all: libconf_ux.h $(OUTBIN)
endif

libconf_ux.h: libtester/libconf.create
	cd libtester &&	. ./libconf.create && cd ..

$(OUTBIN): $(OBJDIR) $(OBJS) $(OUTDIR)
	$(CC) $(LDFLAGS) -o $@ -pipe $(OBJS) $(LIBS)
# pull in dependency info for *existing* .o files
-include $(OBJS:.o=.d)

$(OBJDIR):
	mkdir -p $(OBJDIR)

$(OUTDIR):
	mkdir -p $(OUTDIR)

# compile and generate dependency info
$(OBJDIR)/%.o: %.cpp
	$(C++) -c $(CFLAGS) -o $@ -c $<
	$(C++) -MM -MT $@ $(CFLAGS) $< > $(OBJDIR)/$*.d

clean:
	rm -rf $(OBJDIR)
	rm -f libconf_ux.h
	rm -f libtester/libsmbtest
	rm -f libtester/libsmb40test
	rm -f libtester/libssh2test
	rm -f libtester/libfreetype_test
	rm -f info.txt
	rm -f makelib.mk


ifneq ($(OS),WINDOWS)
install: $(OUTBIN)
	$(INSTALL_DIR)	$(BIN_DIR)
	$(INSTALL_DIR)	$(TARGET_DIR)
	$(INSTALL_PROGRAM) $(OUTBIN) $(BIN_DIR)
	$(INSTALL_TREE) install-files/* $(TARGET_DIR)

uninstall:
	rm -f $(BIN_DIR)/wcm
	rm -rf $(TARGET_DIR)/share/wcm
	rm -rf $(TARGET_DIR)/applications/wcm.desktop
endif

run: $(OUTBIN)
	$(OUTBIN)

debug: $(OUTBIN)
	gdb $(OUTBIN)
