all: testlongint

mylongintlib.o: mylongintlib.asm
	nasm -f elf64 mylongintlib.asm -g -F dwarf

testlongint.o: testlongint.asm
	nasm -f elf64 testlongint.asm -g -F dwarf

testlongint: testlongint.o mylongintlib.o
	gcc -o testlongint testlongint.o mylongintlib.o
