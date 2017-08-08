msvc:
	cl /nologo /DTEST /O2 /Os test.c aes.c
gnu:	
	gcc -DTEST -O2 -Os test.c aes.c -otest
clang:
	clang -DTEST -O2 -Os test.c aes.c -otest	