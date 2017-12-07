# 128-bit-unsigned-integer

A library which offer basic arithmetic operations like addition, subtraction and multiplication for **128 bit unsigned integer** in assembly language. In additional there are functions to copy a integer in a different register and also to read and write from console.

A overview of functions in `mylongintlib.asm`: 

```
addition
subtraction
multiplication
readlonglong
writelonglong
copylonglong
```

How to use: see `testlongint.asm`. 

**Windows**:
To test the library, compile `testlongint.asm` and `mylongintlib.asm` with the `make` command (you need first to install the nasm compiler from [www.nasm.us](http://www.nasm.us/) and add the path to program folder to `PATH` variable (windows)). Also check whether you already have a program to run makefiles (e.g. visual studio `nmake` or cygwin). 

**Linux**:
Install first nasm with `sudo apt-get install nasm` and call `make` in the folder with the project files.
