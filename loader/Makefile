TARGET = loader

LIBS = -lprussdrv

CC = arm-linux-gcc

$(TARGET) : loader.c
	$(CC) loader.c $(LIBS) -o $(TARGET)

clean:
	rm -f $(TARGET)
