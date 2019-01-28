SRC_DIR:=src
OBJ_DIR:=obj
APP_DIR:=app

SRC_HEADERS=$(wildcard $(SRC_DIR)/*.h)

SRC_ALL:= $(wildcard $(SRC_DIR)/*.cpp)
SRC_MAINS:= $(wildcard $(SRC_DIR)/*Main.cpp)
SRC_NON_MAINS:= $(filter-out $(SRC_MAINS), $(SRC_ALL))

OBJ_ALL:=  $(patsubst $(SRC_DIR)/%.cpp,$(OBJ_DIR)/%.o,$(SRC_ALL))
OBJ_MAINS:=  $(patsubst $(SRC_DIR)/%Main.cpp,$(OBJ_DIR)/%Main.o,$(SRC_MAINS))
OBJ_NON_MAINS:= $(filter-out $(OBJ_MAINS), $(OBJ_ALL))

APP_ALL:= $(SRC_MAINS:$(SRC_DIR)/%-Main.cpp=$(APP_DIR)/%.exe)

all: $(OBJ_ALL) $(APP_ALL)

MK_OBJ_DIR:
	@mkdir -p $(OBJ_DIR)
MK_APP_DIR:
	@mkdir -p $(APP_DIR)

DEPS=$(SOURCES:.cpp=.d)

CFLAGS+=-MMD

CXXFLAGS+= -Wno-unused-parameter -Wall  -g -O2 -MMD -Wno-unused-variable -std=c++14 \
	-DHAVE_CONFIG_H -I. -I../.  -DDEBUG -D_GNU_SOURCE  \
        -DIB_USE_STD_STRING -Wextra \
	-MD -MP

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp | MK_OBJ_DIR
	g++ $(CXXFLAGS) -c -o $@ $<

$(APP_DIR)/%.exe: $(OBJ_ALL) | MK_APP_DIR
	g++ -Wall -Wextra -g -O2 -o $@ $(OBJ_NON_MAINS) $(@:$(APP_DIR)/%.exe=$(OBJ_DIR)/%-Main.o)

#$(APP_DIR)/%.exe:  $(OBJ_ALL) $(SRC_HEADERS) | MK_APP_DIR

#g++ -Wall -Wextra -g -O2 -o $@ $(OBJ_NON_MAINS) $(OBJ_DIR)/$(notdir $@)-Main.o




#$(APP_DIR)/%:  $(OBJ_DIR)/%-Main.o $(OBJS_NON_MAIN) $(SRC_HEADERS) | MK_APP_DIR
#	g++ -Wall -Wextra -g -O2 -o $@ $(OBJS_NON_MAIN) $(OBJ_DIR)/$(notdir $@)-Main.o

.PRECIOUS: $(OBJ_DIR)/%.o

.PHONY: clean
clean:
	rm -f $(DEPS) $(OBJ_DIR)/*.d $(OBJ_DIR)/*.o $(APP_DIR)/*
	rmdir --ignore-fail-on-non-empty $(OBJ_DIR) $(APP_DIR)

.PHONY: cleanForGit
cleanForGit: clean
	rm -f $(SRC_DIR)/*~

printVars:
	$(info APP_ALL $(APP_ALL))
	$(info SRC_MAINS $(SRC_MAINS))
	$(info SRC_DIR $(SRC_DIR))

hack:
	$(info SRC_DIR $(SRC_DIR))
	$(info OBJ_DIR $(OBJ_DIR))
	$(info APP_DIR $(APP_DIR))
	$(info SRC_ALL $(SRC_ALL))
	$(info SRC_MAINS $(SRC_MAINS))
	$(info SRC_NON_MAINS $(SRC_NON_MAINS))
	$(info OBJ_ALL $(OBJ_ALL))
	$(info OBJ_MAINS $(OBJ_MAINS))
	$(info OBJ_NON_MAINS $(OBJ_NON_MAINS))


help:
	$(info make all)
	$(info -   default)
	$(info -   make all apps - currently not working correctly)
	$(info make clean)
	$(info -   remove obj and app dirs)
	$(info -   needs work)
	$(info make cleanForGit)
	$(info -   deletes generated directories)
	$(info make help)
	$(info -   prints this message)
-include $(DEPS)
