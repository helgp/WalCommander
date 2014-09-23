DEBUG=1

.SUFFIXES: .cpp .o

CFLAGS= -Wall -Wextra -Werror -D_FILE_OFFSET_BITS=64  -pthread -std=c++11
CFLAGS+= -I wal -I swl 
LIBS = -l stdc++  -l pthread
LDFLAGS += -static
UNAME_S := $(shell uname -s)
ARCH    := $(shell uname -m)
UNAME_OS:= $(shell uname -o)

$(info "Target:"$(UNAME_S)/$(UNAME_OS))

ifeq ($(UNAME_S),Darwin)
# make it buildable with XQuartz
CFLAGS += -I /opt/X11/include
CFLAGS += -Wno-logical-op-parentheses -Wno-bitwise-op-parentheses
CFLAGS += -I /opt/X11/include/freetype2 -D USEFREETYPE
LIBS   += -l freetype
else
endif

ifeq ($(UNAME_OS),Cygwin)
LIBS   += -lgdi32 -lcomdlg32 -lws2_32 -lwsock32 -lmpr 
else
CFLAGS += -I /usr/local/include -I/usr/src/contrib/libstdc++/include/backward
LIBS   += -l ssh2 
LIBS   += -l smbclient
LIBS   += -l freetype
LIBS   += -l X11  
LIBS   += -L /usr/local/lib -L /usr/X11R6/lib
CFLAGS += -I /usr/include/freetype2 -I /usr/local/include/freetype2 -D USEFREETYPE
endif

INSTALL_DIR = install -d
INSTALL_PROGRAM = install -c -m 755
INSTALL_TREE = cp -R
BIN_DIR=$(DESTDIR)/usr/bin
TARGET_DIR=$(DESTDIR)/usr/

CC  = gcc
CPP = g++
 

OUTDIR=../build/$(CC)/$(ARCH)/$(BLDOPTIM)
OBJDIR=$(OUTDIR)/obj
VPATH=swl:wal:$(OBJDIR)

.PATH.cpp = .:swl:wal
.PATH.o = $(OBJDIR)

ifdef DEBUG
	BLDOPTIM=debug
	CFLAGS+=-g
	LDFLAGS+=-g
else
	BLDOPTIM=release
	CLFAGS+=-O2
	BINDIR=$(OUTDIR)
endif

ifeq ($(UNAME_OS),Cygwin)
OUTBIN=$(OUTDIR)/wcm.exe
else
OUTBIN=$(OUTDIR)/wcm
endif

OBJS_COMMON=\
	wal_tmpls.o \
	wal.o\
	wal_sys_api.o\
	wal_charset.o\
	wal_exceptions.o\
	wal_files.o\
	swl_button.o \
	swl_editline.o  \
	swl_layout.o    \
	swl_menubox.o    \
	swl_menutextinfo.o \
	swl_popupmenu.o   \
	swl_sbutton.o     \
	swl_scrollbar.o   \
	swl_staticlabel.o   \
	swl_textlist.o    \
	swl_vlist.o       \
	swl_winbase.o     \
	swl_wincore.o     \
	operthread.o \
	operwin.o \
	vfs.o \
	vfspath.o \
	vfs-smb.o \
	tcp_sock.o \
	vfs-ftp.o \
	vfs-uri.o \
	termwin.o \
	ncdialogs.o \
	unicode_lc.o \
	nchistory.o \
	panel_list.o \
	panel.o \
	nc.o \
	ncwin.o \
	ncedit.o \
	ncview.o \
	fileopers.o \
	eloadsave.o \
	smblogon.o \
	wcm-config.o \
	ftplogon.o \
	charsetdlg.o \
	vfs-sftp2.o \
	sftpdlg.o \
	color-style.o\
	filesearch.o\
	help.o\
	helpres.o\
	strconfig.o \
	shortcuts.o \
	fileassociations.o \
	shl.o \
	ncfonts.o \
	toolbar.o \
	search-dlg.o \
	search-tools.o \
	shell-tools.o \
	t-emulator.o \
	dircalc.o \
	ltext.o 

OBJS_WIN=\
	swl_wincoreMS.o \
	w32cons.o \
	w32util.o \
	ext-app.o

OBJS_UX=\
	swl_wincoreUX.o \
	ext-app-ux.o \
	ux_util.o\
	fontdlg.o \
	shell.o \
	terminal.o 


OBJNAMES=$(OBJS_COMMON)
ifeq ($(UNAME_OS),Cygwin)
OBJNAMES+=$(OBJS_WIN)
else
OBJNAMES+=$(OBJS_UX)
endif
OBJS=$(addprefix $(OBJDIR)/,$(OBJNAMES))

all: $(OUTBIN)

$(OUTBIN): $(OBJDIR) $(OBJS) $(OUTDIR)
	$(CPP) $(LDFLAGS) -o $@ -pipe $(OBJS) $(LIBS)

# pull in dependency info for *existing* .o files
-include $(OBJS:.o=.d)

$(OBJDIR):
	mkdir -p $(OBJDIR)

$(OURDIR):
	mkdir -p $(OURDIR)

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

install: wcm
	$(INSTALL_DIR)	$(BIN_DIR)
	$(INSTALL_DIR)	$(TARGET_DIR)
	$(INSTALL_PROGRAM) wcm $(BIN_DIR)
	$(INSTALL_TREE) install-files/* $(TARGET_DIR)

run: $(OUTBIN)
	$(OUTBIN)

debug: $(OUTBIN)
	gdb $(OUTBIN)
