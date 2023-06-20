all: parser

CODE_DIR = test_codes
CODES = $(wildcard ${CODE_DIR}/*.sy)
OUTPUT_DIR = output

parser: lex.l common.h common.c syntax.y
	flex --noyywrap lex.l
	yacc -d -Wcounterexamples syntax.y
	gcc -g -DGRA_OUTPUT y.tab.c lex.yy.c common.c -o parser

test:
	@if [ ! -d ${OUTPUT_DIR} ]; then mkdir ${OUTPUT_DIR}; fi
	@for code in ${CODES}; do \
		echo "Parsing $$code ..."; \
		./parser $$code ${OUTPUT_DIR}/`basename $$code .sy`.dot; \
		dot -Tpng -o ${OUTPUT_DIR}/`basename $$code .sy`.png ${OUTPUT_DIR}/`basename $$code .sy`.dot; \
	done

simple:
	./parser simple.sy tree.dot
	dot -Tpng -o tree.png tree.dot

clean:
	rm -f parser lex.yy.c y.tab.c y.tab.h *.dot *.png
	rm -rf ${OUTPUT_DIR}