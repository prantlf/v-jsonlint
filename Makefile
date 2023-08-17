all: check build test

check:
	v fmt -w .
	v vet .

build:
	v jsonlint.v

test:
	./test.sh
