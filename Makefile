all: check build test

check:
	v fmt -w .
	v vet .

build:
	v jsonlint.v

test:
	./test.sh

version:
	npx conventional-changelog-cli -p angular -i CHANGELOG.md -s
