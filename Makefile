all:  MK_OBJ MK_APP genApp

SRCS:=$(wildcard src/%.cpp)
MAIN_SOURCE:=$(wildcard src/*Main.cpp)

ALL_OBJS:=  $(patsubst src/%,obj/%,$(SRCS:.cpp=.o))
MAIN_OBJS:= $(patsubst src/%-Main,obj/%-Main,$(SRCS:.cpp=.o))
NON_MAIN_OBJS:=$(filter-out $(MAIN_OBJS), $(ALL_OBJS))

ALL_OBJECTS:=$(SOURCES:.cpp=.o)
MAIN_OBJECTSS:=$(MAIN_SOURCE:.cpp=.o)
NON_MAIN_OBJECTS:=$(filter-out $(MAIN_OBJECTS), $(ALL_OBJECTS))

BINS:=genApp

MK_OBJ:
	@mkdir obj

MK_APP:
	@mkdir app

HEADERS=$(wildcard src/*.h)
DEPS=$(SOURCES:.cpp=.d)

CFLAGS+=-MMD

CXXFLAGS+= -Wno-unused-parameter -Wall  -g -O2 -MMD -Wno-unused-variable -std=c++14 \
	-DHAVE_CONFIG_H -I. -I../.  -DDEBUG -D_GNU_SOURCE  \
        -DIB_USE_STD_STRING -Wextra \
	-MD -MP

obj/%.o: src/%.cpp
	g++ $(CXXFLAGS) -c -o $@ $<


genApp: $(NON_MAIN_OBJS) $(HEADERS) obj/genApp-Main.o
	 g++ -Wall -Wextra -g -O2 -o app/genApp $(NON_MAIN_OBJS) obj/genApp-Main.o

.PHONY: clean

clean:
	$(RM) $(ALL_OBJECTS) $(DEPS) $(BINS)

-include $(DEPS)
