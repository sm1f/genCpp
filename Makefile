all:  genApp


SRC_DIR:=src
OBJ_DIR:=obj
APP_DIR:=app

SRCS:=$(wildcard $(SRC_DIR)/%.cpp)
MAIN_SOURCE:=$(wildcard $(SRC_DIR)/*Main.cpp)

ALL_OBJS:=  $(patsubst $(SRC_DIR)/%,$(OBJ_DIR)/%,$(SRCS:.cpp=.o))
MAIN_OBJS:= $(patsubst $(SRC_DIR)/%-Main,$(OBJ_DIR)/%-Main,$(SRCS:.cpp=.o))
NON_MAIN_OBJS:=$(filter-out $(MAIN_OBJS), $(ALL_OBJS))

ALL_EXES:= $(patSubst  $(SRC_DIR)/%-Main,app/%,$(SRCS:.cpp=))

BINS:=genApp

MK_OBJ_DIR:
	@mkdir -p $(OBJ_DIR)
MK_APP_DIR:
	@mkdir -p app

HEADERS=$(wildcard $(SRC_DIR)/*.h)
DEPS=$(SOURCES:.cpp=.d)

CFLAGS+=-MMD

CXXFLAGS+= -Wno-unused-parameter -Wall  -g -O2 -MMD -Wno-unused-variable -std=c++14 \
	-DHAVE_CONFIG_H -I. -I../.  -DDEBUG -D_GNU_SOURCE  \
        -DIB_USE_STD_STRING -Wextra \
	-MD -MP

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp | MK_OBJ_DIR
	g++ $(CXXFLAGS) -c -o $@ $<


genApp: $(NON_MAIN_OBJS) $(HEADERS) $(OBJ_DIR)/genApp-Main.o | MK_APP_DIR
	 g++ -Wall -Wextra -g -O2 -o app/genApp $(NON_MAIN_OBJS) $(OBJ_DIR)/genApp-Main.o

.PHONY: clean
clean:
	rm -f $(DEPS) $(OBJ_DIR)/*.d $(OBJ_DIR)/*.o app/*
	rmdir --ignore-fail-on-non-empty $(OBJ_DIR) app

.PHONY: cleanForGit
cleanForGit: clean
	rm -f $(SRC_DIR)/*~

-include $(DEPS)
