%{
    #include <ctype.h>
    #include <stdio.h>
    #include <stdlib.h>
    #include "common.h"
    int yylex();
    void yyerror(char * s);
    Node * root = NULL;
    extern int current_line;
    extern int current_column;
    extern char* filename;
%}

%union
{
    struct Node* node;
}

%token <node> IDENT INTCONST UNKNOWN
%token <node> INT VOID IF ELSE WHILE RETURN BREAK CONST CONTINUE
%token <node> PLUS MINUS STAR DIV MOD LESST GREATERT LESSE GREATERE
%token <node> EQ NEQ AND OR NOT ASSIGN LEFTP RIGHTP LEFTS RIGHTS LEFTC RIGHTC COMMA SEMI
%token <node> IFX

/* %right ASSIGN */
/* %left OR */
/* %left AND */
/* %left PLUS MINUS */
/* %left STAR DIV */
%nonassoc IFX // https://www.epaperpress.com/lexandyacc/if.html
%nonassoc ELSE

%type <node> CompUnit Decl FuncDef ConstDecl ConstDef ConstExp VarDecl VarDef Exp
%type <node> FuncFParams FuncFParam
%type <node> Stmt LVal Cond UnaryExp UnaryOp FuncRParams PrimaryExp Number
%type <node> EqExp RelExp AddExp MulExp LAndExp LOrExp
%type <node> ConstDefList VarDefList
%type <node> ConstArrayDim ArrayDim
%type <node> Block BlockItems BlockItem
%type <node> InitVal InitValList InitValListItems
%type <node> ConstInitVal ConstInitValList ConstInitValListItems
%type <node> Start Unknown

%%
// For the convenience of outputting the tree, add an additional root node
Start : 
    CompUnit {
        $$ = newNode(START_TYPE);
        root = $$;
        addChildren($$, $1, NULL);
    }
;

CompUnit : 
    CompUnit Decl {
        $$=newNode(COMP_UNIT_TYPE);
        addChildren($$, $1, $2, NULL);
    }
    | CompUnit FuncDef {
        $$=newNode(COMP_UNIT_TYPE);
        addChildren($$, $1, $2, NULL);
    }
    | Decl {
        $$=newNode(COMP_UNIT_TYPE);
        addChildren($$, $1, NULL);
    }
    | FuncDef {
        $$=newNode(COMP_UNIT_TYPE);
        addChildren($$, $1, NULL);
    }
;

Decl : 
    ConstDecl {
        $$=newNode(DECL_TYPE);
        addChildren($$, $1, NULL);
    }
    | VarDecl {
        $$=newNode(DECL_TYPE);
        addChildren($$, $1, NULL);
    }
;

ConstDecl : 
    CONST INT ConstDefList SEMI {
        $$=newNode(CONST_DECL_TYPE);
        addChildren($$, $1, $2, $3, $4, NULL);
    }
;

ConstDefList : 
    ConstDefList COMMA ConstDef {
        $$=newNode(CONST_DEF_LIST_TYPE);
        addChildren($$, $1, $2, $3, NULL);
    }
    | ConstDef {
        $$=newNode(CONST_DEF_LIST_TYPE);
        addChildren($$, $1, NULL);
    }
;

ConstDef : 
    IDENT ConstArrayDim ASSIGN ConstInitValList {
 		$$=newNode(CONST_DEF_TYPE);
        addChildren($$, $1, $2, $3, $4, NULL);
    }
    | IDENT ASSIGN ConstInitVal{
        $$=newNode(CONST_DEF_TYPE);
        addChildren($$, $1, $2, $3, NULL);
    }
    | error {
        $$=newNode(CONST_DEF_TYPE);
        $$->isError = 1;
    }
;

ConstArrayDim : 
    ConstArrayDim LEFTS ConstExp RIGHTS {
        $$=newNode(CONST_ARRAY_DIM_TYPE);
        addChildren($$, $1, $2, $3, $4, NULL);
    }
    | LEFTS ConstExp RIGHTS {
        $$=newNode(CONST_ARRAY_DIM_TYPE);
        addChildren($$, $1, $2, $3, NULL);
    }
;

ArrayDim : 
    ArrayDim LEFTS Exp RIGHTS {
		$$=newNode(ARRAY_DIM_TYPE);
		addChildren($$, $1, $2, $3, $4, NULL);
    }
    | LEFTS Exp RIGHTS {
        $$=newNode(ARRAY_DIM_TYPE);
        addChildren($$, $1, $2, $3, NULL);
    }
;

ConstInitVal : 
    ConstExp {
        $$=newNode(CONST_INIT_VAL_TYPE);
        addChildren($$, $1, NULL);
    }
;

ConstInitValList : 
    LEFTC RIGHTC {
        $$=newNode(CONST_INIT_VAL_LIST_TYPE);
        addChildren($$, $1, $2, NULL);
    }
    | LEFTC ConstInitValListItems RIGHTC{
        $$=newNode(CONST_INIT_VAL_LIST_TYPE);
        addChildren($$, $1, $2, $3, NULL);
    }
;

ConstInitValListItems : 
    ConstInitValListItems COMMA ConstInitVal {
        $$=newNode(CONST_INIT_VAL_LIST_ITEMS_TYPE);
        addChildren($$, $1, $2, $3, NULL);
    }
    | ConstInitVal {
        $$=newNode(CONST_INIT_VAL_LIST_ITEMS_TYPE);
        addChildren($$, $1, NULL);
    }
;

VarDecl : 
    INT VarDefList SEMI {
        $$=newNode(VAR_DECL_TYPE);
        addChildren($$, $1, $2, $3, NULL);
    }
;

VarDefList : 
    VarDefList COMMA VarDef {
        $$=newNode(VAR_DEF_LIST_TYPE);
        addChildren($$, $1, $2, $3, NULL);
    }
    | VarDef {
        $$=newNode(VAR_DEF_LIST_TYPE);
        addChildren($$, $1, NULL);
    }
;

VarDef : 
    IDENT {
        $$=newNode(VAR_DEF_TYPE);
        addChildren($$, $1, NULL);
    }
    | IDENT ASSIGN ConstInitVal {
        $$=newNode(VAR_DEF_TYPE);
        addChildren($$, $2, $3, NULL);
    }
    | IDENT ConstArrayDim {
        $$=newNode(VAR_DEF_TYPE);
        addChildren($$, $1, $2, NULL);
    }
    | IDENT ConstArrayDim ASSIGN InitValList {
        $$=newNode(VAR_DEF_TYPE);
        addChildren($$, $1, $2, $3, $4, NULL);
    }
;

Exp : AddExp {
		$$=newNode(EXP_TYPE);
		addChildren($$, $1, NULL);
	}
    | Unknown {
        $$=newNode(EXP_TYPE);
        addChildren($$, $1, NULL);
    }
;

ConstExp : 
    AddExp {
        $$=newNode(CONST_EXP_TYPE);
        addChildren($$, $1, NULL);
    }
;

InitVal :
    Exp {
        $$=newNode(CONST_INIT_VAL_TYPE);
        addChildren($$, $1, NULL);
    }
;

InitValList : 
    LEFTC RIGHTC {
        $$=newNode(INIT_VAL_LIST_TYPE);
        addChildren($$, $1, $2, NULL);
    }
    | LEFTC InitValListItems RIGHTC {
        $$=newNode(INIT_VAL_LIST_TYPE);
        addChildren($$, $1, $2, $3, NULL);
    }
;

InitValListItems : 
    InitValListItems COMMA InitVal {
        $$=newNode(INIT_VAL_LIST_ITEMS_TYPE);
        addChildren($$, $1, $2, $3, NULL);
    }
    | InitVal {
        $$=newNode(INIT_VAL_LIST_ITEMS_TYPE);
        addChildren($$, $1, NULL);
    }
;

FuncDef : 
    INT IDENT LEFTP FuncFParams RIGHTP Block {
		$$=newNode(FUNC_DEF_TYPE);
		addChildren($$, $1, $2, $4, $5, $6, NULL);
    }
    | INT IDENT LEFTP RIGHTP Block {
        $$=newNode(FUNC_DEF_TYPE);
        addChildren($$, $1, $2, $3, $4, $5, NULL);
    }
    | VOID IDENT LEFTP FuncFParams RIGHTP Block {
        $$=newNode(FUNC_DEF_TYPE);
        addChildren($$, $1, $2, $4, $5, $6, NULL);
    }
    | VOID IDENT LEFTP RIGHTP Block {
        $$=newNode(FUNC_DEF_TYPE);
        addChildren($$, $1, $2, $3, $4, $5, NULL);
    }
;

FuncFParams : 
    FuncFParams COMMA FuncFParam {
        $$=newNode(FUNC_F_PARAMS_TYPE);
        addChildren($$, $1, $2, $3, NULL);
    }
    | FuncFParam {
        $$=newNode(FUNC_F_PARAMS_TYPE);
        addChildren($$, $1, NULL);
    }
;

FuncFParam : 
    INT IDENT {
        $$=newNode(FUNC_F_PARAM_TYPE);
        addChildren($$, $1, $2, NULL);
    }
    | INT IDENT LEFTS RIGHTS {
        $$=newNode(FUNC_F_PARAM_TYPE);
        addChildren($$, $1, $2, $3, $4, NULL);
    }
    | INT IDENT LEFTS RIGHTS ArrayDim {
        $$=newNode(FUNC_F_PARAM_TYPE);
        addChildren($$, $1, $2, $3, $4, $5, NULL);
    }
    | INT IDENT ArrayDim {
        $$=newNode(FUNC_F_PARAM_TYPE);
        $$->isError=1;
        // fprintf(stderr, "%s:%d:%d: error: use IDENT[Exp] in FuncFParam\n",
        //     filename, current_line, current_column);
    }
    | error {
        $$=newNode(FUNC_F_PARAM_TYPE);
        $$->isError=1;
        // fprintf(stderr, "%s:%d:%d: error: use FuncRParam in FuncFParam\n",
        //     filename, current_line, current_column);
    }
;

Block : 
    LEFTC BlockItems RIGHTC {
        $$=newNode(BLOCK_TYPE);
        addChildren($$, $1, $2, $3, NULL);
    }
    | LEFTC RIGHTC {
        $$=newNode(BLOCK_TYPE);
        addChildren($$, $1, $2, NULL);
    }
;

BlockItems : 
    BlockItems BlockItem {
        $$=newNode(BLOCK_ITEMS_TYPE);
        addChildren($$, $1, $2, NULL);
    }
    | BlockItem {
        $$=newNode(BLOCK_ITEMS_TYPE);
        addChildren($$, $1, NULL);
    }
;

BlockItem : 
    Decl {
        $$=newNode(BLOCK_ITEM_TYPE);
        addChildren($$, $1, NULL);
    }
    | Stmt {
        $$=newNode(BLOCK_ITEM_TYPE);
        addChildren($$, $1, NULL);
    }
;

Stmt : 
    LVal ASSIGN Exp SEMI {
		$$=newNode(STMT_TYPE);
		addChildren($$, $1, $2, $3, $4, NULL);
	}
    | Exp SEMI {
        $$=newNode(STMT_TYPE);
        addChildren($$, $1, $2, NULL);
    }
    | SEMI {
        $$=newNode(STMT_TYPE);
        addChildren($$, $1, NULL);
    }
    | Block {
        $$=newNode(STMT_TYPE);
        addChildren($$, $1, NULL);
    }
    | IF LEFTP Cond RIGHTP Stmt %prec IFX {
        $$=newNode(STMT_TYPE);
        addChildren($$, $1, $2, $3, $4, $5, NULL);
    }
    | IF LEFTP Cond RIGHTP Stmt ELSE Stmt {
        $$=newNode(STMT_TYPE);
        addChildren($$, $1, $2, $3, $4, $5, $6, $7, NULL);
    }
    | WHILE LEFTP Cond RIGHTP Stmt {
        $$=newNode(STMT_TYPE);
        addChildren($$, $1, $2, $3, $4, $5, NULL);
    }
    | BREAK SEMI {
        $$=newNode(STMT_TYPE);
        addChildren($$, $1, $2, NULL);
    }
    | CONTINUE SEMI {
        $$=newNode(STMT_TYPE);
        addChildren($$, $1, $2, NULL);
    }
    | RETURN SEMI {
        $$=newNode(STMT_TYPE);
        addChildren($$, $1, $2, NULL);
    }
    | RETURN Exp SEMI {
        $$=newNode(STMT_TYPE);
        addChildren($$, $1, $2, $3, NULL);
    }
    | error{
        $$=newNode(STMT_TYPE);
        $$->isError = 1;
        // fprintf(stderr, "%s:%d:%d: error: Unexpected token in Stmt\n",
        //     filename, current_line, current_column);
    }
;

LVal : 
    IDENT {
		$$=newNode(L_VAL_TYPE);
		addChildren($$, $1, NULL);
	}
    | IDENT ArrayDim {
        $$=newNode(L_VAL_TYPE);
        addChildren($$, $1, $2, NULL);
    }
;

Cond : 
    LOrExp{
		$$=newNode(COND_TYPE);
		addChildren($$, $1, NULL);
    }
;

UnaryExp : 
    PrimaryExp {
		$$=newNode(UNARY_EXP_TYPE);
		addChildren($$, $1, NULL);
    }
    | IDENT LEFTP RIGHTP {
        $$=newNode(UNARY_EXP_TYPE);
        addChildren($$, $1, $2, $3, NULL);
        }
    | IDENT LEFTP FuncRParams RIGHTP {
        $$=newNode(UNARY_EXP_TYPE);
        addChildren($$, $1, $2, $3, $4, NULL);
    }
    | UnaryOp UnaryExp {
        $$=newNode(UNARY_EXP_TYPE);
        addChildren($$, $1, $2, NULL);
    }
;

UnaryOp : 
    PLUS {
        $$=newNode(UNARY_OP_TYPE);
        addChildren($$, $1, NULL);
    }
    | MINUS {
        $$=newNode(UNARY_OP_TYPE);
        addChildren($$, $1, NULL);
    }
    | NOT {
        $$=newNode(UNARY_OP_TYPE);
        addChildren($$, $1, NULL);
    }
;

FuncRParams : 
    FuncRParams COMMA Exp {
        $$=newNode(FUNC_R_PARAMS_TYPE);
        addChildren($$, $1, $2, $3, NULL);
    }
    | Exp {
        $$=newNode(FUNC_R_PARAMS_TYPE);
        addChildren($$, $1, NULL);
    }
;

PrimaryExp : LEFTP Exp RIGHTP
	{
		$$=newNode(PRIMARY_EXP_TYPE);
		addChildren($$, $1, $2, $3, NULL);
	}
    | LVal {
        $$=newNode(PRIMARY_EXP_TYPE);
        addChildren($$, $1, NULL);
    }
    | Number {
        $$=newNode(PRIMARY_EXP_TYPE);
        addChildren($$, $1, NULL);
    }
;

Number : 
    INTCONST {
        $$=newNode(NUMBER_TYPE);
        addChildren($$, $1, NULL);
    }
;

MulExp : 
    UnaryExp {
        $$=newNode(MUL_EXP_TYPE);
        addChildren($$, $1, NULL);
    }
    | MulExp STAR UnaryExp {
        $$=newNode(MUL_EXP_TYPE);
        addChildren($$, $1, $2, $3, NULL);
    }
    | MulExp DIV UnaryExp {
        $$=newNode(MUL_EXP_TYPE);
        addChildren($$, $1, $2, $3, NULL);
    }
    | MulExp MOD UnaryExp {
        $$=newNode(MUL_EXP_TYPE);
        addChildren($$, $1, $2, $3, NULL);
    }
;

AddExp : 
    MulExp {
		$$=newNode(ADD_EXP_TYPE);
		addChildren($$, $1, NULL);
	}
    | AddExp PLUS MulExp {
        $$=newNode(ADD_EXP_TYPE);
        addChildren($$, $1, $2, $3, NULL);
    }
    | AddExp MINUS MulExp {
        $$=newNode(ADD_EXP_TYPE);
        addChildren($$, $1, $2, $3, NULL);
    }
;

RelExp : 
    AddExp {
        $$=newNode(REL_EXP_TYPE);
        addChildren($$, $1, NULL);
    }
    | AddExp LESST AddExp {
        $$=newNode(REL_EXP_TYPE);
        addChildren($$, $1, $2, $3, NULL);
    }
    | AddExp GREATERT AddExp {
        $$=newNode(REL_EXP_TYPE);
        addChildren($$, $1, $2, $3, NULL);
    }
    | AddExp LESSE AddExp {
        $$=newNode(REL_EXP_TYPE);
        addChildren($$, $1, $2, $3, NULL);
    }
    | AddExp GREATERE AddExp {
        $$=newNode(REL_EXP_TYPE);
        addChildren($$, $1, $2, $3, NULL);
    }
    | error{
        $$=newNode(REL_EXP_TYPE);
        $$->isError = 1;
        // fprintf(stderr, "%s:%d:%d: error: Unexpected token in RelExp\n",
        //     filename, current_line, current_column);
    }
;

EqExp : 
    RelExp {
		$$=newNode(EQ_EXP_TYPE);
		addChildren($$, $1, NULL);
	}
    | RelExp EQ RelExp {
        $$=newNode(EQ_EXP_TYPE);
        addChildren($$, $1, $2, $3, NULL);
    }
    | RelExp NEQ RelExp {
        $$=newNode(EQ_EXP_TYPE);
        addChildren($$, $1, $2, $3, NULL);
    }
;

LAndExp : 
    EqExp {
		$$=newNode(L_AND_EXP_TYPE);
		addChildren($$, $1, NULL);
	}
    | LAndExp AND EqExp {
        $$=newNode(L_AND_EXP_TYPE);
        addChildren($$, $1, $2, $3, NULL);
    }
;

LOrExp : 
    LAndExp {
		$$=newNode(L_OR_EXP_TYPE);
		addChildren($$, $1, NULL);
	}
    | LOrExp OR LAndExp {
        $$=newNode(L_OR_EXP_TYPE);
        addChildren($$, $1, $2, $3, NULL);
    }
;

Unknown : 
    UNKNOWN {
        ;
    }
;

%%

void yyerror(char* s){
    fprintf(stderr, "%s:%d:%d: error: %s\n",
        filename, current_line, current_column, s);
}

int main(int argc, char** argv){
    freopen(argv[1], "r", stdin);
    filename = argv[1];
    yyparse();
    #ifdef GRA_OUTPUT
    FILE* fp = fopen(argv[2], "w");
    printTree(root, fp);
    #endif
}