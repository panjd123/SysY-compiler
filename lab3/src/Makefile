all: parser

CODE_DIR = test_codes
CODES = $(wildcard ${CODE_DIR}/*.sy)
OUTPUT_DIR = output

CC = g++
CFLAGS = -std=c++17 -DASSEMBLE_OUTPUT -DTREE_OUTPUT -Wno-write-strings -Wno-unused-result -O2 -g

lex.yy.c: lex.l
	flex --noyywrap lex.l

y.tab.c y.tab.h: syntax.y
	yacc -d -Wcounterexamples syntax.y

parser: lex.yy.c y.tab.c y.tab.h common.hpp common.cpp compiler.hpp
	${CC} ${CFLAGS} y.tab.c lex.yy.c common.cpp -o parser

test:
	@if [ ! -d ${OUTPUT_DIR} ]; then mkdir ${OUTPUT_DIR}; fi
	@for code in ${CODES}; do \
		echo "Parsing $$code ..."; \
		./parser $$code ${OUTPUT_DIR}/`basename $$code .sy`.s ${OUTPUT_DIR}/`basename $$code .sy`.dot; \
		gcc ${OUTPUT_DIR}/`basename $$code .sy`.s -o ${OUTPUT_DIR}/`basename $$code .sy`; \
	done

plot:
	@for code in ${CODES}; do \
		dot -Tpng -o ${OUTPUT_DIR}/`basename $$code .sy`.png ${OUTPUT_DIR}/`basename $$code .sy`.dot; \
	done

simple:
	./parser simple.sy simple.s simple.dot
	gcc simple.s -g -o sim
	# dot -Tpng -o tree.png simple.dot
	# ./sim

test1:
	./parser test_codes2/1.sy output/1.s
	gcc output/1.s -o output/1
	# ./output/1

test2:
	./parser test_codes2/2.sy output/2.s
	gcc output/2.s -o output/2
	# ./output/2

test3:
	./parser test_codes2/3.sy output/3.s
	gcc output/3.s -o output/3
	# ./output/3

test4:
	./parser test_codes2/4.sy output/4.s
	gcc output/4.s -o output/4
	# ./output/4

clean:
	rm -f parser lex.yy.c y.tab.c y.tab.h *.dot *.png *.s sim
	# rm -rf ${OUTPUT_DIR}