# Компилятор и флаги
CC = gcc
CFLAGS = -Wall -Wextra -std=c11 -pedantic -D_POSIX_C_SOURCE=200809L
LDFLAGS = 
TARGET = sed-simplified

# Директории
SRC_DIR = src
OBJ_DIR = obj

# Файлы исходного кода
SOURCES = $(SRC_DIR)/main.c $(SRC_DIR)/sed_operations.c
OBJECTS = $(SOURCES:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)

# Основная цель
all: $(TARGET)

# Сборка исполняемого файла
$(TARGET): $(OBJECTS)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

# Компиляция объектных файлов
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Создание директории для объектных файлов
$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

# Очистка
clean:
	rm -rf $(OBJ_DIR) $(TARGET)

# Тестирование
test: $(TARGET)
	@echo "Running basic tests..."
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

# Установка (опционально)
install: $(TARGET)
	cp $(TARGET) /usr/local/bin/

# Отладка
debug: CFLAGS += -g -O0
debug: clean $(TARGET)

.PHONY: all clean test install debug