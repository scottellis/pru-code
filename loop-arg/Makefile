LIBS = -lprussdrv
CC = arm-linux-gcc

all: loop.bin loop_loader

loop_loader: loop_loader.c
	$(CC) loop_loader.c $(LIBS) -o loop_loader

loop.bin : loop.p
	pasm -b loop.p

clean:
	rm -f loop.bin loop_loader
