ifeq (1,${RELEASE})
	VFLAGS=-prod
endif
ifeq (1,${ARM})
	VFLAGS:=-cflags "-target arm64-apple-darwin" $(VFLAGS)
endif
ifeq (1,${WINDOWS})
	VFLAGS:=-os windows $(VFLAGS)
endif

all: check build test

check:
	v fmt -w .
	v vet .

build:
	v $(VFLAGS) jsonlint.v

test:
	./test.sh
