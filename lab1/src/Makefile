all: lex

lex: lex.l
	flex --outfile=lex.yy.c lex.l
	gcc -DLEX_OUTPUT lex.yy.c -o lex

test1:
	./lex < test_codes/1.sy > output/1.out
	diff --strip-trailing-cr output/1.out output/my1.out

test2:
	./lex < test_codes/2.sy > output/2.out
	diff --strip-trailing-cr output/2.out output/my2.out

test3:
	./lex < test_codes/3.sy > output/3.out
	diff --strip-trailing-cr output/3.out output/my3.out

test4:
	./lex < test_codes/4.sy > output/4.out
	diff --strip-trailing-cr output/4.out output/my4.out

test5:
	./lex < test_codes/5.sy > output/5.out
	diff --strip-trailing-cr output/5.out output/my5.out

test6:
	./lex < test_codes/6.sy > output/6.out
	diff --strip-trailing-cr output/6.out output/my6.out

test: test1 test2 test3 test4 test5 test6

clean:
	rm -f lex.yy.c lex