CC = gcc
CFLAGS = -Wall -Wextra -std=c11 -pedantic -D_POSIX_C_SOURCE=200809L
LDFLAGS = 
TARGET = prgrm

SRC_DIR = src
OBJ_DIR = obj

SOURCES = $(SRC_DIR)/main.c $(SRC_DIR)/sed_operations.c
OBJECTS = $(SOURCES:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)


all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

clean:
	rm -rf $(OBJ_DIR) $(TARGET)


test: $(TARGET)
	@echo "Hello World" > test.txt
	./$(TARGET) test.txt 's/World/Universe/'
	@echo "File content after replacement:"
	@cat test.txt
	@rm -f test.txt
	@echo -e "\nTest 2: Delete lines containing 'test'"
	@echo -e "line1\nthis is a test\nline3" > test2.txt
	./$(TARGET) test2.txt '/test/d'
	@echo "File content after deletion:"
	@cat test2.txt
	@rm -f test2.txt
	@echo -e "\nAll tests completed."

install: $(TARGET)
	cp $(TARGET) /usr/local/bin/

debug: CFLAGS += -g -O0
debug: clean $(TARGET)

.PHONY: all clean test install debug
