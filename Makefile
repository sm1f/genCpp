all:genApp

BINS:=genApp

SOURCES:=$(wildcard *.cpp)
MAIN_SOURCE:=$(wildcard *Main.cpp)

ALL_OBJECTS:=$(SOURCES:.cpp=.o)
MAIN_OBJS:=$(MAIN_SOURCE:.cpp=.o)
NON_MAIN_OBJECTS:=$(filter-out $(MAIN_OBJS), $(ALL_OBJECTS))


HEADERS=$(wildcard *.h)
DEPS=$(SOURCES:.cpp=.d)

CFLAGS+=-MMD
#CXXFLAGS+= -Wno-unused-parameter -Wall  -g -O2 -MMD -Wno-unused-variable \

CXXFLAGS+= -Wno-unused-parameter -Wall  -g -O2 -MMD -Wno-unused-variable -std=c++14 \
	-DHAVE_CONFIG_H -I. -I../.  -DDEBUG -D_GNU_SOURCE  \
        -DIB_USE_STD_STRING -Wextra \
	-MD -MP

genApp: $(NON_MAIN_OBJECTS) $(HEADERS) genApp-Main.o
	 g++ -Wall -Wextra -g -O2 -o genApp $(NON_MAIN_OBJECTS) genApp-Main.o

.PHONY: clean

clean:
	$(RM) $(ALL_OBJECTS) $(DEPS) $(BINS)

-include $(DEPS)
