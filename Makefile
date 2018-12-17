SRC_DIR:=src
OBJ_DIR:=obj
APP_DIR:=app

SRCS_ALL:= $(wildcard $(SRC_DIR)/*.cpp)
SRCS_MAIN:= $(wildcard $(SRC_DIR)/*Main.cpp)

OBJS_ALL:=  $(patsubst $(SRC_DIR)/%.cpp,$(OBJ_DIR)/%.o,$(SRCS_ALL))
OBJS_MAIN:=  $(patsubst $(SRC_DIR)/%Main.cpp,$(OBJ_DIR)/%Main.o,$(SRCS_MAIN))
OBJS_NON_MAIN:= $(filter-out $(OBJS_MAIN), $(OBJS_ALL))

ALL_APPS:= $(patSubst $(SRC_DIR)/%-Main.cpp,$(APP_DIR)/%,$(SRCS:.cpp=.exe))
#ALL_APPS:= $(APP_DIR)/genApp

all: app/genApp app/genApp2
	echo $(ALL_APPS)
	echo $(SRCS_ALL)
	echo $(OBJS_ALL)
	echo "OBJS_MAIN:" $(OBJS_MAIN)
	echo $(OBJS_NON_MAIN)


MK_OBJ_DIR:
	@mkdir -p $(OBJ_DIR)
MK_APP_DIR:
	@mkdir -p $(APP_DIR)

HEADERS=$(wildcard $(SRC_DIR)/*.h)
DEPS=$(SOURCES:.cpp=.d)

CFLAGS+=-MMD

CXXFLAGS+= -Wno-unused-parameter -Wall  -g -O2 -MMD -Wno-unused-variable -std=c++14 \
	-DHAVE_CONFIG_H -I. -I../.  -DDEBUG -D_GNU_SOURCE  \
        -DIB_USE_STD_STRING -Wextra \
	-MD -MP

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp | MK_OBJ_DIR
	g++ $(CXXFLAGS) -c -o $@ $<


$(APP_DIR)/%:  $(OBJ_DIR)/%-Main.o $(OBJS_NON_MAIN) $(HEADERS) | MK_APP_DIR
	g++ -Wall -Wextra -g -O2 -o $@ $(OBJS_NON_MAIN) $(OBJ_DIR)/$(notdir $@)-Main.o

.PRECIOUS: $(OBJ_DIR)/%.o

.PHONY: clean
clean:
	rm -f $(DEPS) $(OBJ_DIR)/*.d $(OBJ_DIR)/*.o $(APP_DIR)/*
	rmdir --ignore-fail-on-non-empty $(OBJ_DIR) $(APP_DIR)

.PHONY: cleanForGit
cleanForGit: clean
	rm -f $(SRC_DIR)/*~

-include $(DEPS)
