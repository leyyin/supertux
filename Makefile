# Makefile for supertux

# by Bill Kendrick & Tobias Glaesser
# bill@newbreedsoftware.com
# tobi.web@gmx.de
# http://www.newbreedsoftware.com/

# Version 0.0.6 (in development)

# April 11, 2000 - December 29, 2000


# User-definable stuff:

ifeq ($(PREFIX),)
ifeq ($(USERNAME),root)
PREFIX=/usr/local
else
PREFIX=$(PWD)
endif
DATA_PREFIX=$(PWD)/data/
else
DATA_PREFIX=$(PREFIX)/share/games/supertux/data/
endif
JOY=YES


#undefine this for non debugging compilation

DEBUG_FLAG=-DDEBUG -pg

# Defaults for Linux:

TARGET=supertux
TARGET_DEF=LINUX

CFLAGS=-Wall -O2 $(SDL_CFLAGS) -DDATA_PREFIX=\"$(DATA_PREFIX)\" \
	-D$(NOSOUNDFLAG) -D$(NOOPENGLFLAG) -D$(TARGET_DEF) -DJOY_$(JOY) $(DEBUG_FLAG)


# Other definitions:

SDL_MIXER=-lSDL_mixer
SDL_IMAGE=-lSDL_image
NOSOUNDFLAG=__SOUND
NOOPENGLFLAG=__OPENGL
SDL_LIB=$(SDL_MIXER) $(SDL_IMAGE) $(SDL_LDFLAGS) 
SDL_CFLAGS := $(shell sdl-config --cflags)
SDL_LDFLAGS := $(shell sdl-config --libs)
GL_LIB =  -L/usr/X11R6/lib -lGL
installbin = install -g $(USERNAME) -o $(USERNAME) -m 755 
installdat = install -g $(USERNAME) -o $(USERNAME) -m 644


OBJECTS=obj/supertux.o obj/setup.o obj/intro.o obj/title.o obj/scene.o obj/collision.o obj/bitmask.o obj/type.o \
	obj/timer.o obj/text.o obj/texture.o obj/badguy.o obj/special.o  obj/world.o obj/player.o obj/level.o obj/gameloop.o \
	obj/screen.o obj/sound.o obj/high_scores.o obj/menu.o obj/leveleditor.o

# Make commands:

all:	$(TARGET)

install: $(TARGET)
	mkdir -p $(PREFIX)/games/$(TARGET)
	mkdir -p $(PREFIX)/share/games/$(TARGET)
	mkdir -p $(PREFIX)/bin/
	cp -r data $(PREFIX)/share/games/$(TARGET)/
	chmod -R 0755 $(PREFIX)/share/games/$(TARGET)/data/
	-$(installbin) $(TARGET) $(PREFIX)/games/$(TARGET)/$(TARGET)
	ln -sf $(PREFIX)/games/$(TARGET)/$(TARGET) $(PREFIX)/bin/$(TARGET)

uninstall:
	rm -r $(PREFIX)/games/$(TARGET)
	rm -r $(PREFIX)/share/games/$(TARGET)
	rm $(PREFIX)/bin/$(TARGET)

nosound:
	make supertux SDL_MIXER= NOSOUNDFLAG=NOSOUND

noopengl:
	make supertux GL_LIB= NOOPENGLFLAG=NOOPENGL
	
nosoundopengl:
	make supertux GL_LIB= SDL_MIXER= NOSOUNDFLAG=NOSOUND NOOPENGLFLAG=NOOPENGL
	
win32:
	make TARGET_DEF=WIN32 TARGET=supertux.exe \
		DATA_PREFIX=data/
	cp /usr/local/cross-tools/i386-mingw32/lib/SDL*.dll .
	chmod 644 SDL*.dll

clean:
	-rm -f supertux supertux.exe
	-rm -f obj/*.o
	-rm -f SDL*.dll


# Main executable:

$(TARGET):	$(OBJECTS)
	$(CC) $(CFLAGS) $(OBJECTS) -o $(TARGET) $(SDL_LIB)  $(GL_LIB)

# Objects:

obj/supertux.o:	src/supertux.c src/supertux.h src/defines.h src/globals.h \
		obj/setup.o obj/intro.o obj/title.o obj/gameloop.o \
		obj/screen.o obj/sound.o obj/leveleditor.o
	$(CC) $(CFLAGS) src/supertux.c -c -o obj/supertux.o

obj/setup.o:	src/setup.c src/setup.h obj/sound.o \
		src/defines.h src/globals.h obj/screen.o
	$(CC) $(CFLAGS) src/setup.c -c -o obj/setup.o

obj/intro.o:	src/intro.c src/intro.h \
		src/defines.h src/globals.h src/screen.h
	$(CC) $(CFLAGS) src/intro.c -c -o obj/intro.o

obj/title.o:	src/title.c src/title.h \
		src/defines.h src/globals.h src/screen.h
	$(CC) $(CFLAGS) src/title.c -c -o obj/title.o

obj/level.o:	src/level.c src/defines.h src/globals.h \
			src/level.h src/gameloop.h src/screen.h src/badguy.h
	$(CC) $(CFLAGS) src/level.c -c -o obj/level.o

obj/scene.o:	src/scene.c src/scene.h \
		src/defines.h src/globals.h src/screen.h src/scene.h src/gameloop.h obj/sound.o \
		src/setup.h obj/level.o
	$(CC) $(CFLAGS) src/scene.c -c -o obj/scene.o
	
obj/collision.o:	src/collision.c src/collision.h \
		src/defines.h src/globals.h src/screen.h src/scene.h src/gameloop.h obj/sound.o \
		src/setup.h obj/level.o
	$(CC) $(CFLAGS) src/collision.c -c -o obj/collision.o
	
obj/bitmask.o:	src/bitmask.c src/bitmask.h \
		src/defines.h src/globals.h src/screen.h src/scene.h src/gameloop.h obj/sound.o \
		src/setup.h obj/level.o
	$(CC) $(CFLAGS) src/bitmask.c -c -o obj/bitmask.o
		
obj/type.o:	src/type.c src/type.h \
		src/defines.h src/globals.h src/screen.h src/scene.h src/gameloop.h obj/sound.o \
		src/setup.h obj/level.o
	$(CC) $(CFLAGS) src/type.c -c -o obj/type.o
	
obj/timer.o:	src/timer.c src/timer.h \
		src/defines.h src/globals.h src/screen.h src/scene.h src/gameloop.h obj/sound.o \
		src/setup.h obj/level.o
	$(CC) $(CFLAGS) src/timer.c -c -o obj/timer.o
	
obj/texture.o:	src/texture.c src/texture.h \
		src/defines.h src/globals.h src/screen.h src/scene.h src/gameloop.h obj/sound.o \
		src/setup.h obj/level.o
	$(CC) $(CFLAGS) src/texture.c -c -o obj/texture.o

obj/text.o:	src/text.c src/text.h \
		src/defines.h src/globals.h src/screen.h src/scene.h src/gameloop.h obj/sound.o \
		src/setup.h obj/level.o
	$(CC) $(CFLAGS) src/text.c -c -o obj/text.o
	
obj/badguy.o:	src/badguy.c src/badguy.h \
		src/defines.h src/globals.h src/screen.h src/gameloop.h obj/sound.o \
		src/setup.h obj/level.o
	$(CC) $(CFLAGS) src/badguy.c -c -o obj/badguy.o

obj/special.o:	src/special.c src/special.h \
		src/defines.h src/globals.h src/screen.h src/gameloop.h obj/sound.o \
		src/setup.h obj/level.o
	$(CC) $(CFLAGS) src/special.c -c -o obj/special.o

obj/world.o:	src/world.c src/world.h \
		src/defines.h src/globals.h src/screen.h src/gameloop.h obj/sound.o \
		src/setup.h obj/level.o
	$(CC) $(CFLAGS) src/world.c -c -o obj/world.o
		
obj/player.o:	src/player.c src/player.h \
		src/defines.h src/globals.h src/screen.h src/gameloop.h obj/sound.o \
		src/setup.h obj/level.o
	$(CC) $(CFLAGS) src/player.c -c -o obj/player.o
	
obj/gameloop.o:	src/gameloop.c src/gameloop.h \
		src/defines.h src/globals.h src/screen.h obj/sound.o \
		src/setup.h obj/level.o obj/player.o
	$(CC) $(CFLAGS) src/gameloop.c -c -o obj/gameloop.o

obj/screen.o:	src/screen.c src/defines.h src/globals.h src/screen.h
	$(CC) $(CFLAGS) src/screen.c -c -o obj/screen.o

obj/sound.o:	src/sound.c src/defines.h src/globals.h src/sound.h
	$(CC) $(CFLAGS) src/sound.c -c -o obj/sound.o

obj/high_scores.o:	src/high_scores.c src/defines.h src/globals.h \
	 			obj/sound.o
	$(CC) $(CFLAGS) src/high_scores.c -c -o obj/high_scores.o

obj/menu.o:	src/menu.c src/defines.h src/globals.h \
			obj/sound.o src/menu.h src/leveleditor.h
	$(CC) $(CFLAGS) src/menu.c -c -o obj/menu.o

obj/leveleditor.o:	src/leveleditor.c src/defines.h src/globals.h \
			src/leveleditor.h src/gameloop.h src/screen.h src/badguy.h
	$(CC) $(CFLAGS) src/leveleditor.c -c -o obj/leveleditor.o