CC=gcc
ASMBIN=nasm

EXE_FILE=sfade

all : asm cc link

asm :
	$(ASMBIN) -o sunfade.o -f elf -g -F dwarf sunfade.asm
cc :
	$(CC) -m32 -c -g -O0 sfade.c
link :
	$(CC) -m32 -g -o $(EXE_FILE) sunfade.o sfade.o

clean :
	rm *.o
	rm $(EXE_FILE)
