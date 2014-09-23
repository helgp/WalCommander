-include makefile.local

.SUFFIXES: .cpp .o

CFLAGS+= -Wall -Wextra -D_FILE_OFFSET_BITS=64  -pthread -std=c++11
#CFLAGS+= -Werror
CFLAGS+= -I wal -I swl 
LIBS = -l stdc++  -l pthread
UNAME_S := $(shell uname -s)
ARCH    := $(shell uname -m)
UNAME_OS:= $(shell uname -o)


ifeq ($(UNAME_S),Darwin)
# make it buildable with XQuartz
CFLAGS += -I /opt/X11/include
CFLAGS += -Wno-logical-op-parentheses -Wno-bitwise-op-parentheses
CFLAGS += -I /opt/X11/include/freetype2 -D USEFREETYPE
LIBS   += -l freetype
OS = $(UNAME_S)
else ifeq ($(UNAME_OS),Cygwin)
LIBS   += -lgdi32 -lcomdlg32 -lws2_32 -lwsock32 -lmpr 
LDFLAGS += -static
OS = Windows
else
CFLAGS += -I /usr/local/include -I/usr/src/contrib/libstdc++/include/backward
LIBS   += -l ssh2 
LIBS   += -l smbclient
LIBS   += -l freetype
LIBS   += -l X11  
LIBS   += -L /usr/local/lib -L /usr/X11R6/lib
CFLAGS += -I /usr/include/freetype2 -I /usr/local/include/freetype2 -D USEFREETYPE
OS=$(UNAME_S)
endif

INSTALL_DIR = install -d
INSTALL_PROGRAM = install -c -m 755
INSTALL_TREE = cp -R
BIN_DIR=$(DESTDIR)/usr/bin
TARGET_DIR=$(DESTDIR)/usr/

CC  = gcc
CPP = g++

BUILD=$(OS)/$(CC)/$(ARCH)/$(BLDOPTIM)
$(info Build: $(BUILD))

OUTDIR=../build/$(BUILD)
OBJDIR=$(OUTDIR)/obj
VPATH=swl:wal:$(OBJDIR)

.PATH.cpp = .:swl:wal
.PATH.o = $(OBJDIR)

ifdef DEBUG
	BLDOPTIM=debug
	CFLAGS+=-g -DDEBUG
	LDFLAGS+=-g
else
	BLDOPTIM=release
	CLFAGS+=-O2 -D_NDEBUG
endif

ifeq ($(OS),Windows)
OUTBIN=$(OUTDIR)/wcm.exe
else
OUTBIN=$(OUTDIR)/wcm
endif

include makefile.objs

OBJNAMES=$(OBJS_COMMON)
ifeq ($(OS),Windows)
OBJNAMES+=$(OBJS_WIN)
else
OBJNAMES+=$(OBJS_UX)
endif
OBJS=$(addprefix $(OBJDIR)/,$(OBJNAMES))

ifeq ($(OS),Darwin)
all: $(OUTBIN)
else ifeq ($(OS),Windows)
all: $(OUTBIN)
else
all: libconf_ux.h $(OUTBIN)
endif

$(OUTBIN): $(OBJDIR) $(OBJS) $(OUTDIR)
	$(CPP) $(LDFLAGS) -o $@ -pipe $(OBJS) $(LIBS)

# pull in dependency info for *existing* .o files
-include $(OBJS:.o=.d)

$(OBJDIR):
	mkdir -p $(OBJDIR)

$(OUTDIR):
	mkdir -p $(OUTDIR)

# compile and generate dependency info
$(OBJDIR)/%.o: %.cpp
	$(CPP) -c $(CFLAGS) -o $@ -c $<
	$(CPP) -MM -MT $@ $(CFLAGS) $< > $(OBJDIR)/$*.d

clean:
	rm -rf $(OBJDIR)
	rm -f libconf_ux.h
	rm -f libtester/libsmbtest
	rm -f libtester/libsmb40test
	rm -f libtester/libssh2test
	rm -f libtester/libfreetype_test
	rm -f info.txt
	rm -f makelib.mk


ifneq ($(OS),Windows)
install: wcm
	$(INSTALL_DIR)	$(BIN_DIR)
	$(INSTALL_DIR)	$(TARGET_DIR)
	$(INSTALL_PROGRAM) wcm $(BIN_DIR)
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
