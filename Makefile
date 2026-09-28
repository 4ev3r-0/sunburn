ifeq ($(OS),Windows_NT)
    PLATFORM_OS   := WINDOWS
    EXE_EXT       := .exe
    RAYLIB_LIBS   := -Wl,-Bstatic -lraylib -Wl,-Bdynamic -lopengl32 -lgdi32 -lwinmm -luser32 -lshell32 -lole32
    RAYLIB_SRC    := raylib/src
    RAYLIB_INC    := -I$(RAYLIB_SRC)
    RAYLIB_LIBDIR := -L$(RAYLIB_SRC)
    MKDIR         := if not exist "$(BUILD_DIR)" mkdir "$(BUILD_DIR)"
    RMDIR         := if exist "$(BUILD_DIR)" rmdir /S /Q "$(BUILD_DIR)"
    RMDIR_RAYLIB  := if exist "raylib" rmdir /S /Q "raylib"
    RM_TARGET     := if exist "$(TARGET)" del /Q "$(TARGET)"
    CHECK_RAYLIB  := if not exist "raylib\src\libraylib.a" if not exist "raylib\src\libraylib.dll.a" $(MAKE) raylib-setup
else
    PLATFORM_OS   := LINUX
    EXE_EXT       :=
    RAYLIB_LIBS   := -Wl,-Bstatic -lraylib -Wl,-Bdynamic -lGL -lm -lpthread -ldl -lrt -lX11
    RAYLIB_SRC    := raylib/src
    RAYLIB_INC    := -I$(RAYLIB_SRC)
    RAYLIB_LIBDIR := -L$(RAYLIB_SRC)
    MKDIR         := mkdir -p "$(BUILD_DIR)"
    RMDIR         := rm -rf "$(BUILD_DIR)"
    RMDIR_RAYLIB  := rm -rf "raylib"
    RM_TARGET     := rm -f "$(TARGET)"
    CHECK_RAYLIB  := if [ ! -f "raylib/src/libraylib.a" ] && [ ! -f "raylib/src/libraylib.dll.a" ]; then $(MAKE) raylib-setup; fi
endif

TARGET    := game$(EXE_EXT)
SRC_DIR   := src
BUILD_DIR := build
SRCS      := $(wildcard $(SRC_DIR)/*.c)
OBJS      := $(patsubst $(SRC_DIR)/%.c,$(BUILD_DIR)/%.o,$(SRCS))

CC        := gcc
CFLAGS    := -std=c99 -Wall -Wextra -O2 -I$(SRC_DIR) $(RAYLIB_INC)
LDFLAGS   := $(RAYLIB_LIBDIR) $(RAYLIB_LIBS)

.PHONY: all clean distclean run raylib-setup rebuild

all: $(TARGET)

$(TARGET): $(OBJS) | raylib-check
	$(CC) $(OBJS) -o $@ $(LDFLAGS)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR):
	$(MKDIR)

raylib-check:
	@$(CHECK_RAYLIB)

raylib-setup:
	@echo --- Setting up raylib (this may take a minute) ---
	@if not exist "raylib" git clone --depth 1 https://github.com/raysan5/raylib.git raylib
	@$(MAKE) -C raylib/src PLATFORM=PLATFORM_DESKTOP
	@echo --- Raylib setup complete ---

run: all
	./$(TARGET)

clean:
	$(RM_TARGET)
	$(RMDIR)

distclean: clean
	$(RMDIR_RAYLIB)

rebuild: clean all
