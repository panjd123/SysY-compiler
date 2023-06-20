%{
    #include <ctype.h>
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <iostream>
    using namespace std;
    #include "common.hpp"
    #include "compiler.hpp"
    extern int yylex();
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
%nonassoc ELSEX

%type <node> CompUnit Decl FuncDef ConstDecl ConstDef ConstExp VarDecl VarDef Exp
%type <node> FuncFParams FuncFParam
%type <node> Stmt LVal Cond UnaryExp FuncRParams PrimaryExp Number // UnaryOp
%type <node> EqExp RelExp AddExp MulExp LAndExp LOrExp
%type <node> ConstDefList VarDefList
%type <node> ConstArrayDim ArrayDim
%type <node> Block BlockItems BlockItem
%type <node> InitVal InitValList InitValListItems
%type <node> ConstInitVal ConstInitValList ConstInitValListItems
%type <node> Start Unknown FuncName NewLabel AfterElse EnterWhile ExitWhile BlockWithoutNewLevel

%%
// For the convenience of outputting the tree, add an additional root node
Start : 
    CompUnit {
        $$ = newNode(START_TYPE);
        root = $$;
        addChildren($$, $1);
    }
;

CompUnit : 
    CompUnit Decl {
        $$=newNode(COMP_UNIT_TYPE);
        addChildren($$, $1, $2);
    }
    | CompUnit FuncDef {
        $$=newNode(COMP_UNIT_TYPE);
        addChildren($$, $1, $2);
    }
    | Decl {
        $$=newNode(COMP_UNIT_TYPE);
        addChildren($$, $1);
    }
    | FuncDef {
        $$=newNode(COMP_UNIT_TYPE);
        addChildren($$, $1);
    }
;

Decl : 
    ConstDecl {
        $$=newNode(DECL_TYPE);
        addChildren($$, $1);
    }
    | VarDecl {
        $$=newNode(DECL_TYPE);
        addChildren($$, $1);
    }
;

ConstDecl : 
    CONST INT ConstDefList SEMI {
        $$=newNode(CONST_DECL_TYPE);
        addChildren($$, $1, $2, $3, $4);
    }
;

ConstDefList : 
    ConstDefList COMMA ConstDef {
        $$=newNode(CONST_DEF_LIST_TYPE);
        addChildren($$, $1, $2, $3);
    }
    | ConstDef {
        $$=newNode(CONST_DEF_LIST_TYPE);
        addChildren($$, $1);
    }
;

ConstDef : 
    IDENT ConstArrayDim ASSIGN ConstInitValList {
 		$$=newNode(CONST_DEF_TYPE);
        addChildren($$, $1, $2, $3, $4);
        if(isVarInTable($1->text)){
            yyerror("Variable redefined");
            $$->isError = 1;
        }else{
            if(level == 0){ // 全局变量
                assemble.append("\t.section\t.rodata\n");
                assemble.append("\t.align\t4\n");
                assemble.append("\t.type\t%s, @object\n", $1->text);
                assemble.append("\t.size\t%s, %d\n", $1->text, $2->value*4);
                assemble.append("%s:\n", $1->text);
                for(auto x: $4->values){
                    assemble.append("\t.long\t%d\n", x->value);
                }
                for(int i = 0; i < $2->value - $4->values.size(); i++){
                    assemble.append("\t.long\t0\n");
                }
                assemble.append("\t.text\n");
                auto var = Var(ConstArr, $2->value, 0, true, $2->values);
                for(auto v: $4->values){
                    var.values2.push_back(v->value);
                }
                insertVar($1->text, var);
            }else{
                offset -= 4*$2->value;
                assemble.append("\tsubq\t$%d, %%rsp\n", 4*$2->value);
                for(int i = 0; i < $4->value; i++){
                    assemble.append("\tmovl\t$%d, %d(%%rbp)\n",$4->values[i]->value, offset + i*4);
                }
                auto var = Var(ConstArr, $2->value, offset, false, $2->values);
                for(auto v: $4->values){
                    var.values2.push_back(v->value);
                }
                insertVar($1->text, var);
            }
        }
    }
    | IDENT ASSIGN ConstInitVal{
        $$=newNode(CONST_DEF_TYPE);
        addChildren($$, $1, $2, $3);
        if(isVarInTable($1->text)){
            yyerror("Variable redefined");
            $$->isError = 1;
        }else{
            if(level == 0){ // 全局变量
                assemble.append("\t.section\t.rodata\n");
                assemble.append("\t.align\t4\n");
                assemble.append("\t.type\t%s, @object\n", $1->text);
                assemble.append("\t.size\t%s, 4\n", $1->text);
                assemble.append("%s:\n", $1->text);
                assemble.append("\t.long\t%d\n",$3->value);
                assemble.append("\t.text\n");
                insertVar($1->text, Var(ConstInt, $3->value, 0, true));
            }else{
                offset -= 4;
                assemble.append("\tsubq\t$4, %%rsp\n");
                assemble.append("\tmovl\t%d, %%edi\n", $3->value);
                assemble.append("\tmovl\t%%edi, %d(%rbp)\n", offset);
                insertVar($1->text, Var(ConstInt, $3->value, offset, false));
            }
        }
    }
    | error {
        $$=newNode(CONST_DEF_TYPE);
        $$->isError = 1;
    }
;

ConstArrayDim : // done
    ConstArrayDim LEFTS ConstExp RIGHTS{
        $$=newNode(CONST_ARRAY_DIM_TYPE);
        addChildren($$, $1, $2, $3, $4);
        $$->value = $1->value * $3->value;
        $$->values.push_back($3);
        $$->values.insert($$->values.end(), $1->values.begin(), $1->values.end());
    }
    | LEFTS ConstExp RIGHTS {
        $$=newNode(CONST_ARRAY_DIM_TYPE);
        addChildren($$, $1, $2, $3);
        $$->value = $2->value;
        $$->values.push_back($2);
    }
;

ArrayDim : // done
    ArrayDim LEFTS Exp RIGHTS{ // values 记录从右往左的维度信息
		$$=newNode(ARRAY_DIM_TYPE);
		addChildren($$, $1, $2, $3, $4);
        $$->value = $1->value * $3->value;
        $$->values = $4->values;
        $$->isConst = $2->isConst && $4->isConst;
        $$->values.push_back($3);
        $$->values.insert($$->values.end(), $1->values.begin(), $1->values.end());
    }
    | LEFTS Exp RIGHTS {
        $$=newNode(ARRAY_DIM_TYPE);
        addChildren($$, $1, $2, $3);
        $$->value = $2->value;
        $$->isConst = $2->isConst;
        $$->values.push_back($2);
    }
;

ConstInitVal : 
    ConstExp {
        $$=newNode(CONST_INIT_VAL_TYPE);
        addChildren($$, $1);
        copyNode($$, $1);
    }
;

ConstInitValList : 
    LEFTC RIGHTC {
        $$=newNode(CONST_INIT_VAL_LIST_TYPE);
        addChildren($$, $1, $2);
        $$->values = vector<Node*>();
        $$->value = 0;
    }
    | LEFTC ConstInitValListItems RIGHTC{
        $$=newNode(CONST_INIT_VAL_LIST_TYPE);
        addChildren($$, $1, $2, $3);
        $$->values = $2->values;
        $$->value = $2->values.size();
    }
;

ConstInitValListItems : 
    ConstInitValListItems COMMA ConstInitVal {
        $$=newNode(CONST_INIT_VAL_LIST_ITEMS_TYPE);
        addChildren($$, $1, $2, $3);
        $$->values = $1->values;
        $$->values.push_back($3);
    }
    | ConstInitVal {
        $$=newNode(CONST_INIT_VAL_LIST_ITEMS_TYPE);
        addChildren($$, $1);
        $$->values = vector<Node*>();
        $$->values.push_back($1);
    }
;

VarDecl : 
    INT VarDefList SEMI {
        $$=newNode(VAR_DECL_TYPE);
        addChildren($$, $1, $2, $3);
        // no need to do anything
    }
;

VarDefList : 
    VarDefList COMMA VarDef {
        $$=newNode(VAR_DEF_LIST_TYPE);
        addChildren($$, $1, $2, $3);
        // no need to do anything
    }
    | VarDef {
        $$=newNode(VAR_DEF_LIST_TYPE);
        addChildren($$, $1);
        // no need to do anything
    }
;

VarDef : 
    IDENT {
        $$=newNode(VAR_DEF_TYPE);
        addChildren($$, $1);
        if(level == 0){
            assemble.append("\t.globl\t%s\n", $1->text);
            assemble.append("\t.data\n");
            assemble.append("\t.align\t4\n");
            assemble.append("\t.type\t%s, @object\n", $1->text);
            assemble.append("\t.size\t%s, 4\n", $1->text);
            assemble.append("\t.long\t0\n");
            assemble.append("\t.text\n");
            insertVar($1->text, Var(Int, 0, 0, true));
        }else{
            offset -= 4;
            assemble.append("\tsubq\t$4, %%rsp\n");
            insertVar($1->text, Var(Int, 0, offset, false));
        }
    }
    | IDENT ASSIGN ConstInitVal {
        $$=newNode(VAR_DEF_TYPE);
        addChildren($$, $1, $2, $3);
        if(level == 0){
            assemble.append("\t.globl\t%s\n", $1->text);
            assemble.append("\t.data\n");
            assemble.append("\t.align\t4\n");
            assemble.append("\t.type\t%s, @object\n", $1->text);
            assemble.append("\t.size\t%s, 4\n", $1->text);
            assemble.append("%s:\n", $1->text);
            assemble.append("\t.long\t%d\n", $3->value);
            assemble.append("\t.text\n");
            insertVar($1->text, Var(Int, $3->value, 0, true));
        }else{
            assemble.var2reg($3, "%edi");
            offset -= 4;
            assemble.append("\tsubq\t$4, %%rsp\n");
            assemble.append("\tmovl\t%%edi, %d(%%rbp)\n", offset);
            insertVar($1->text, Var(Int, $3->value, offset, false));
        }
    }
    | IDENT ConstArrayDim {
        $$=newNode(VAR_DEF_TYPE);
        addChildren($$, $1, $2);
        if(level==0){
            assemble.append("\t.globl\t%s\n", $1->text);
            assemble.append("\t.data\n");
            assemble.append("\t.align\t4\n");
            assemble.append("\t.type\t%s, @object\n", $1->text);
            assemble.append("\t.size\t%s, %d\n", $1->text, $2->value*4);
            assemble.append("%s:\n", $1->text);
            for(int i=0; i<$2->value; i++){
                assemble.append("\t.long\t0\n");
            }
            assemble.append("\t.text\n");
            insertVar($1->text, Var(Arr, 0, 0, true, $2->values));
        }else{
            offset -= $2->value*4;
            assemble.append("\tsubq\t$%d, %%rsp\n", $2->value*4);
            insertVar($1->text, Var(Arr, 0, offset, false, $2->values));
        }
    }
    | IDENT ConstArrayDim ASSIGN InitValList {
        $$=newNode(VAR_DEF_TYPE);
        addChildren($$, $1, $2, $3, $4);
        if($4->value > $2->value){
            yyerror("Initialize array with too many values");
        }else{
            if(level == 0){
                assemble.append("\t.globl\t%s\n", $1->text);
                assemble.append("\t.data\n");
                assemble.append("\t.align\t4\n");
                assemble.append("\t.type\t%s, @object\n", $1->text);
                assemble.append("\t.size\t%s, %d\n", $1->text, $2->value*4);
                assemble.append("%s:\n", $1->text);
                for(int i = 0; i < $4->value; i++){
                    assemble.append("\t.long\t%d\n", $4->values[i]->value);
                }
                for(int i = $4->value; i < $2->value; i++){
                    assemble.append("\t.long\t0\n");
                }
                assemble.append("\t.text\n");
                insertVar($1->text, Var(Arr, 0, 0, true, $2->values));
            } else{
                offset -= $2->value*4;
                assemble.append("\tsubq\t$%d, %%rsp\n", $2->value*4);
                for(int i = 0; i < $4->value; i++){
                    assemble.var2reg($4->values[i], "%edi");
                    assemble.append("\tmovl\t%%edi, %d(%%rbp)\n", offset+i*4);
                }
                for(int i = $4->value; i < $2->value; i++){
                    assemble.append("\tmovl\t$0, %d(%%rbp)\n", offset+i*4);
                }
                insertVar($1->text, Var(Arr, 0, offset, false, $2->values));
            }
        }
    }
;

Exp : AddExp {
		$$=newNode(EXP_TYPE);
		addChildren($$, $1);
        copyNode($$, $1);
	}
    | Unknown {
        $$=newNode(EXP_TYPE);
        addChildren($$, $1);
        copyNode($$, $1);
    }
;

ConstExp : 
    AddExp {
        $$=newNode(CONST_EXP_TYPE);
        addChildren($$, $1);
        copyNode($$, $1);
    }
;

InitVal :
    Exp {
        $$=newNode(CONST_INIT_VAL_TYPE);
        addChildren($$, $1);
        copyNode($$, $1);
    }
;

InitValList :
    LEFTC RIGHTC {
        $$=newNode(INIT_VAL_LIST_TYPE);
        addChildren($$, $1, $2);
        $$->values = vector<Node*>();
        $$->value = 0;
    }
    | LEFTC InitValListItems RIGHTC {
        $$=newNode(INIT_VAL_LIST_TYPE);
        addChildren($$, $1, $2, $3);
        $$->values = $2->values;
        $$->value = $2->values.size();
    }
;

InitValListItems :
    InitValListItems COMMA InitVal {
        $$=newNode(INIT_VAL_LIST_ITEMS_TYPE);
        addChildren($$, $1, $2, $3);
        $$->values = $1->values;
        $$->values.push_back($3);
    }
    | InitVal {
        $$=newNode(INIT_VAL_LIST_ITEMS_TYPE);
        addChildren($$, $1);
        $$->values = vector<Node*>();
        $$->values.push_back($1);
    }
;

FuncDef : 
    INT FuncName LEFTP FuncFParams RIGHTP EnterIntFuncBlock BlockWithoutNewLevel FuncEnd{
		$$=newNode(FUNC_DEF_TYPE);
		addChildren($$, $1, $2, $4, $5, $7);
        // no need to do anything
    }
    | INT FuncName LEFTP RIGHTP EnterIntFuncBlock BlockWithoutNewLevel FuncEnd{
        $$=newNode(FUNC_DEF_TYPE);
        addChildren($$, $1, $2, $3, $4, $6);
        // no need to do anything
    }
    | VOID FuncName LEFTP FuncFParams RIGHTP EnterVoidFuncBlock BlockWithoutNewLevel FuncEnd{
        $$=newNode(FUNC_DEF_TYPE);
        addChildren($$, $1, $2, $4, $5, $7);
        // no need to do anything
    }
    | VOID FuncName LEFTP RIGHTP EnterVoidFuncBlock BlockWithoutNewLevel FuncEnd{
        $$=newNode(FUNC_DEF_TYPE);
        addChildren($$, $1, $2, $3, $4, $6);
        // no need to do anything
    }
;

BlockWithoutNewLevel:
    LEFTC BlockItems RIGHTC{
        $$=newNode(BLOCK_TYPE);
        addChildren($$, $1, $2, $3);
        // no need to do anything
    }
    | LEFTC RIGHTC{
        $$=newNode(BLOCK_TYPE);
        addChildren($$, $1, $2);
        // no need to do anything
    }
;


FuncName:
    IDENT{
        $$ = $1;
        funcName = $1->text;
    }
;

EnterIntFuncBlock:
    InsertIntFuncName EnterFuncBlock {
        ;
    }
;

InsertIntFuncName:
    {
        if(isFuncInTable(funcName)){
            yyerror("duplicated function name");
        }else{
            insertFunc(funcName, Var(FuncInt, 0, 0, false, paramList));
        }
    }
;

EnterVoidFuncBlock:
    InsertVoidFuncName EnterFuncBlock {
        ;
    }
;

InsertVoidFuncName:
    {
        if(isFuncInTable(funcName)){
            yyerror("duplicated function name");
        }else{
            insertFunc(funcName, Var(FuncVoid, 0, 0, false, paramList));
            inVoidFunc = true;
        }
    }
;

EnterFuncBlock:
    /* empty */ {
        nextLevel();
        hasReturn = false;
        assemble.append("\t.globl\t%s\n", funcName.c_str());
        assemble.append("\t.type\tmain, @function\n");
        assemble.append("%s:\n", funcName.c_str());
        assemble.call();
        int curSize = 0;
        for(int i=0;i<paramList.size();i++){
            if(paramList[i]->isArr){
                insertVar(paramList[i]->text, Var(Addr, 0, 32+curSize, false, paramList[i]->values));
                curSize += 8;
            }else{
                insertVar(paramList[i]->text, Var(Int, 0, 32+curSize, false));
                curSize += 4;
            }
        }
        paramList.clear();
    }
;

FuncEnd:
    {
        exitLevel();
        if(!hasReturn){
            assemble.append("\taddq\t$%d, %%rsp\n", -offset);
            assemble.ret();
        }
        offset = 0;
    }
;

FuncFParams : 
    FuncFParams COMMA FuncFParam {
        $$=newNode(FUNC_F_PARAMS_TYPE);
        addChildren($$, $1, $2, $3);
        // no need to do anything
    }
    | FuncFParam {
        $$=newNode(FUNC_F_PARAMS_TYPE);
        addChildren($$, $1);
        // no need to do anything
    }
;

FuncFParam : 
    INT IDENT {
        $$=newNode(FUNC_F_PARAM_TYPE);
        addChildren($$, $1, $2);
        strcpy($$->text, $2->text);
        paramList.push_back($$);
    }
    | INT IDENT LEFTS RIGHTS {
        $$=newNode(FUNC_F_PARAM_TYPE);
        addChildren($$, $1, $2, $3, $4);
        strcpy($$->text, $2->text);
        $$->values.push_back(nullptr);
        $$->isArr = true;
        paramList.push_back($$);
    }
    | INT IDENT LEFTS RIGHTS ArrayDim {
        $$=newNode(FUNC_F_PARAM_TYPE);
        addChildren($$, $1, $2, $3, $4, $5);
        strcpy($$->text, $2->text);
        for(auto dim: $5->values){
            $$->values.push_back(dim);
        }
        $$->values.push_back(nullptr);
        $$->isArr = true;
        paramList.push_back($$);
    }
    | INT IDENT ArrayDim {
        $$=newNode(FUNC_F_PARAM_TYPE);
        $$->isError=1;
        yyerror("use IDENT[Exp] in FuncFParam");
    }
    | error {
        $$=newNode(FUNC_F_PARAM_TYPE);
        $$->isError=1;
        yyerror("unknown error in FuncFParam");
    }
;

Block :
    EnterBlock LEFTC BlockItems RIGHTC ExitBlock{
        $$=newNode(BLOCK_TYPE);
        addChildren($$, $2, $3, $4);
        // no need to do anything
    }
    | EnterBlock LEFTC RIGHTC ExitBlock{
        $$=newNode(BLOCK_TYPE);
        addChildren($$, $2, $3);
        // no need to do anything
    }
;

EnterBlock :
    /* empty */ {
        nextLevel();
        offsetStack.push_back(offset);
    }

ExitBlock :
    /* empty */ {
        exitLevel();
        recoverStack();
    }

BlockItems :
    BlockItems BlockItem {
        $$=newNode(BLOCK_ITEMS_TYPE);
        addChildren($$, $1, $2);
        // no need to do anything
    }
    | BlockItem {
        $$=newNode(BLOCK_ITEMS_TYPE);
        addChildren($$, $1);
        // no need to do anything
    }
;

BlockItem :
    Decl {
        $$=newNode(BLOCK_ITEM_TYPE);
        addChildren($$, $1);
        // no need to do anything
    }
    | Stmt {
        $$=newNode(BLOCK_ITEM_TYPE);
        addChildren($$, $1);
        // no need to do anything
    }
;

Stmt :
    LVal ASSIGN Exp SEMI {
		$$=newNode(STMT_TYPE);
		addChildren($$, $1, $2, $3, $4);
        if($1->isConst){
            yyerror("assign to const");
        }else{
            assemble.var2reg($3, "%r9d");
            assemble.reg2var("%r9d", $1);
        }
	}
    | Exp SEMI {
        $$=newNode(STMT_TYPE);
        addChildren($$, $1, $2);
        // no need to do anything
    }
    | SEMI {
        $$=newNode(STMT_TYPE);
        addChildren($$, $1);
        // no need to do anything
    }
    | Block {
        $$=newNode(STMT_TYPE);
        addChildren($$, $1);
        // no need to do anything
    }
    | IF LEFTP Cond RIGHTP NewLabel EnterStmt Stmt ExitStmt %prec IFX {
        $$=newNode(STMT_TYPE);
        addChildren($$, $1, $2, $3, $4, $7);
        assemble.backpatch($3->trueList, $5->quad);
        int end = assemble.newLabel();
        assemble.comment("if end");
        assemble.backpatch($3->falseList, end);
    }
    | IF LEFTP Cond RIGHTP NewLabel EnterStmt Stmt ExitStmt ELSE AfterElse NewLabel EnterStmt Stmt ExitStmt NewLabel %prec ELSEX {
        $$=newNode(STMT_TYPE);
        addChildren($$, $1, $2, $3, $4, $7, $9, $13);
        assemble.backpatch($3->trueList, $5->quad);
        assemble.backpatch($3->falseList, $11->quad);
        assemble.backpatch($10->trueList, $15->quad);
    }
    | WHILE EnterWhile EnterStmt LEFTP Cond RIGHTP ExitWhile NewLabel Stmt ExitStmt {
        $$=newNode(STMT_TYPE);
        addChildren($$, $1, $4, $5, $6, $9);
        assemble.backpatch($5->trueList, $8->quad);
        assemble.append("\tjmp\t.L%d\n", $2->quad);
        int whileEnd = assemble.newLabel();
        assemble.comment("while end");
        assemble.backpatch($5->falseList, $7->quad);
        assemble.backpatch($7->trueList, whileEnd);
        for(auto [line, of]: breakStack.back()){
            sprintf(tmp, "\taddq\t$%d, %%rsp\n", offset - of);
            assemble[line - 1] = tmp; 
            assemble[line] += to_string(whileEnd) + "\n";
        }
        breakStack.pop_back();
        for(auto [line, of]: continueStack.back()){
            sprintf(tmp, "\taddq\t$%d, %%rsp\n", offset - of);
            assemble[line - 1] = tmp; 
            assemble[line] += to_string($2->quad) + "\n";
        }
        continueStack.pop_back();
    }
    | BREAK SEMI {
        $$=newNode(STMT_TYPE);
        addChildren($$, $1, $2);
        assemble.append("");
        assemble.append("\tjmp\t.L");
        breakStack.back().push_back({assemble.line, offset});
    }
    | CONTINUE SEMI {
        $$=newNode(STMT_TYPE);
        addChildren($$, $1, $2);
        assemble.append("");
        assemble.append("\tjmp\t.L");
        continueStack.back().push_back({assemble.line, offset});
    }
    | RETURN SEMI {
        $$=newNode(STMT_TYPE);
        addChildren($$, $1, $2);
        if(!inVoidFunc){
            yyerror("return nothing in non-void function");
        }
        hasReturn = true;
        assemble.append("\taddq\t$%d, %%rsp\n", -offset);
        assemble.ret();
    }
    | RETURN Exp SEMI {
        $$=newNode(STMT_TYPE);
        addChildren($$, $1, $2, $3);
        if(inVoidFunc){
            yyerror("return in void function");
        }
        hasReturn = true;
        assemble.var2reg($2, "%eax");
        assemble.append("\taddq\t$%d, %%rsp\n", -offset);
        assemble.ret();
    }
    | error{
        $$=newNode(STMT_TYPE);
        $$->isError = 1;
        yyerror("error in Stmt");
    }
;

EnterWhile:
    /* empty */ {
        $$=newNode(NORMAL_TYPE);
        $$->quad = assemble.newLabel();
        assemble.comment("enter while");
        breakStack.push_back(vector<pii>());
        continueStack.push_back(vector<pii>());
    }

ExitWhile:
    /* empty */ {
        $$=newNode(NORMAL_TYPE);
        $$->quad = assemble.newLabel();
        assemble.comment("exit while");
        int oldOffset = offsetStack.back();
        assemble.append("\taddq\t$%d, %%rsp\n", oldOffset - offset);
        assemble.append("\tjmp\t.L");
        $$->trueList.push_back(assemble.line);
    }

AfterElse:
    /* empty */ {
        $$=newNode(NORMAL_TYPE);
        assemble.append("\tjmp\t.L");
        $$->trueList.push_back(assemble.line);
    }

NewLabel:
    /* empty */ {
        $$=newNode(NORMAL_TYPE);
        $$->quad = assemble.newLabel();
    }
;

EnterStmt:
    /* empty */ {
        assemble.comment("enter stmt");
        offsetStack.push_back(offset);
    }
;

ExitStmt:
    /* empty */ {
        recoverStack();
    }

LVal : 
    IDENT {
		$$=newNode(L_VAL_TYPE);
		addChildren($$, $1);
        // $$->text = $1->text;
        strcpy($$->text, $1->text);
        if(!isVarInTable($1->text)){
            yyerror("Reference Undefined Variable");
        }else{
            auto [depth, var] = getVar($1->text);
            $$->isGlobal = var.isGlobal;
            if(var.type == ConstInt){
                $$->isConst = true;
                $$->value = var.value;
            }else{
                $$->offset = var.offset;
            }
        }
	}
    | IDENT ArrayDim {
        $$=newNode(L_VAL_TYPE);
        addChildren($$, $1, $2);
        // $$->text = $1->text;
        strcpy($$->text, $1->text);
        if(!isVarInTable($1->text)){
            yyerror("Reference Undefined Variable");
        }else{
            auto [depth, var] = getVar($1->text);
            if(var.type != Arr && var.type != ConstArr && var.type != Addr){
                yyerror("Reference Non-Array Variable");
            }
            $$->isGlobal = var.isGlobal;
            if(var.type == ConstArr && $2->isConst){
                $$->isConst = true;
                int curSize = 1;
                int of = 0;
                int delta = var.values.size() - $2->values.size();
                for(int i = 0; i < var.values.size(); i++){
                    if(i >= delta){
                        of += curSize * $2->values[i - delta]->value;
                    }
                    curSize *= var.values[i]->value;
                }
                $$->value = getVarValue(var, of);
            } else {
                offset -= 4;
                assemble.append("\tsubq\t$4, %%rsp\n");
                assemble.append("\tmovl\t$0, %d(%%rbp)\n", offset);
                int curSize = 1;
                int delta = var.values.size() - $2->values.size();
                for(int i = 0; i < var.values.size(); i++){
                    if(i >= delta){
                        assemble.var2reg($2->values[i - delta], "%r8d");
                        assemble.append("\timull\t$%d, %%r8d\n", curSize);
                        assemble.append("\taddl\t%d(%%rbp), %%r8d\n", offset);
                        assemble.append("\tmovl\t%%r8d, %d(%%rbp)\n", offset);
                    }
                    if(var.values[i]){
                        curSize *= var.values[i]->value;
                    }
                }
                $$->isArr = true;
                $$->offset = var.offset;
                $$->isAddr = var.type == Addr;
                $$->offsetInArray = offset;
            }
        }
    }
;

Cond : 
    LOrExp{
		$$=newNode(COND_TYPE);
		addChildren($$, $1);
        copyNode($$, $1);
    }
;

UnaryExp : 
    PrimaryExp {
		$$=newNode(UNARY_EXP_TYPE);
		addChildren($$, $1);
        copyNode($$, $1);
    }
    | IDENT LEFTP RIGHTP {
        $$=newNode(UNARY_EXP_TYPE);
        addChildren($$, $1, $2, $3);
        if(!isFuncInTable($1->text)){
            yyerror("Call Undefined Function");
        }{
            alignStack();
            assemble.append("\tcall\t%s\n", $1->text);
            auto [depth, func] = getFunc($1->text);
            if(func.type == FuncInt){
                offset -= 4;
                assemble.append("\taddq\t$4, %%rsp\n");
                assemble.append("\tmovl\t%%eax, %d(%%rbp)\n", offset);
                $$->offset = offset;
            }
        }
    }
    | IDENT LEFTP FuncRParams RIGHTP {
        $$=newNode(UNARY_EXP_TYPE);
        addChildren($$, $1, $2, $3, $4);
        if(strcmp($1->text,"scanf")==0){
            alignStack();
            if($3->values.size() != 1){
                yyerror("scanf only accept one parameter");
            }
            assemble.var2reg($3->values[0], "%rsi", true);
            assemble.append("\tleaq\t.LC0(%%rip), %%rdi\n");
            assemble.append("\tmovl\t$0, %%eax\n");
            assemble.append("\tcall\t__isoc99_scanf@PLT\n");
        }else if(strcmp($1->text,"printf")==0){
            alignStack();
            if($3->values.size() != 1){
                yyerror("printf only accept one parameter");
            }
            assemble.var2reg($3->values[0], "%esi");
            assemble.append("\tleaq\t.LC1(%%rip), %%rdi\n");
            assemble.append("\tmovl\t$0, %%eax\n");
            assemble.append("\tcall\tprintf@PLT\n");
        }else{
            if(!isFuncInTable($1->text)){
                yyerror("Call Undefined Function");
            }{
                alignStack();
                auto [depth, func] = getFunc($1->text);
                for(int i = $3->value - 1; i >= 0 ; i--){
                    if(!func.values[i]->isArr){
                        assemble.var2reg($3->values[i], "%r8d");
                        assemble.append("\tsubq\t$4, %%rsp\n");
                        offset -= 4;
                        assemble.append("\tmovl\t%%r8d, %d(%%rbp)\n", offset);
                    }else{
                        assemble.var2reg($3->values[i], "%r8", true);
                        assemble.append("\tsubq\t$8, %%rsp\n");
                        offset -= 8;
                        assemble.append("\tmovq\t%%r8, %d(%%rbp)\n", offset);
                    }
                }
                assemble.append("\tcall\t%s\n", $1->text);
                if(func.type == FuncInt){
                    offset -= 4;
                    assemble.append("\tsubq\t$4, %%rsp\n");
                    assemble.append("\tmovl\t%%eax, %d(%%rbp)\n", offset);
                    $$->offset = offset;
                }
            }
        }
    }
    | PLUS UnaryExp {
        $$=newNode(UNARY_EXP_TYPE);
        addChildren($$, $1, $2);
        copyNode($$, $2);
    }
    | MINUS UnaryExp {
        $$=newNode(UNARY_EXP_TYPE);
        addChildren($$, $1, $2);
        if($2->isConst){
            // copyNode($$, $2);
            $$->isConst = true;
            $$->value = -$2->value;
        }else{
            assemble.var2reg($2, "%r8d");
            assemble.append("\tneg %%r8d\n");
            offset -= 4;
            assemble.append("\tsubq $4, %%rsp\n");
            assemble.append("\tmovl %%r8d, %d(%%rbp)\n", offset);
            $$->offset = offset;
        }
    }
    | NOT UnaryExp {
        $$=newNode(UNARY_EXP_TYPE);
        addChildren($$, $1, $2);
        if($2->isConst){
            // copyNode($$, $2);
            $$->isConst = true;
            $$->value = !$2->value;
        }else{
            assemble.var2reg($2, "%eax");
            assemble.append("\ttestl %%eax, %%eax\n");
            assemble.append("\tsete %%al\n");
            assemble.append("\tmovzbl %%al, %%eax\n");
            offset -= 4;
            assemble.append("\tsubq $4, %%rsp\n");
            assemble.append("\tmovl %%eax, %d(%%rbp)\n", offset);
            $$->offset = offset;
        }
    }
;

/*
UnaryOp : 
    PLUS {
        $$=newNode(UNARY_OP_TYPE);
        addChildren($$, $1);
    }
    | MINUS {
        $$=newNode(UNARY_OP_TYPE);
        addChildren($$, $1);
    }
    | NOT {
        $$=newNode(UNARY_OP_TYPE);
        addChildren($$, $1);
    }
;
*/

FuncRParams : 
    FuncRParams COMMA Exp {
        $$=newNode(FUNC_R_PARAMS_TYPE);
        addChildren($$, $1, $2, $3);
        $$->values = $1->values;
        $$->values.push_back($3);
        $$->value = $$->values.size();
    }
    | Exp {
        $$=newNode(FUNC_R_PARAMS_TYPE);
        addChildren($$, $1);
        $$->values = vector<Node*>();
        $$->values.push_back($1);
        $$->value = 1;
    }
;

PrimaryExp : LEFTP Exp RIGHTP
	{
		$$=newNode(PRIMARY_EXP_TYPE);
		addChildren($$, $1, $2, $3);
        copyNode($$, $2);
	}
    | LVal {
        $$=newNode(PRIMARY_EXP_TYPE);
        addChildren($$, $1);
        copyNode($$, $1);
    }
    | Number {
        $$=newNode(PRIMARY_EXP_TYPE);
        addChildren($$, $1);
        copyNode($$, $1);
    }
;

Number : 
    INTCONST {
        $$=newNode(NUMBER_TYPE);
        addChildren($$, $1);
        $$->isConst = true;
        $$->value = $1->value;
    }
;

MulExp : 
    UnaryExp {
        $$=newNode(MUL_EXP_TYPE);
        addChildren($$, $1);
        copyNode($$, $1);
    }
    | MulExp STAR UnaryExp {
        $$=newNode(MUL_EXP_TYPE);
        addChildren($$, $1, $2, $3);
        if($1->isConst && $3->isConst){
            $$->isConst = true;
            $$->value = $1->value * $3->value;
        }else{
            assemble.var2reg($1, "%r8d");
            assemble.var2reg($3, "%r9d");
            assemble.append("\timull\t%%r8d, %%r9d\n");
            offset -= 4;
            assemble.append("\tsubq\t$4, %%rsp\n");
            assemble.append("\tmovl\t%%r9d, %d(%%rbp)\n", offset);
            $$->offset = offset;
        }
    }
    | MulExp DIV UnaryExp {
        $$=newNode(MUL_EXP_TYPE);
        addChildren($$, $1, $2, $3);
        if($1->isConst && $3->isConst){
            $$->isConst = true;
            $$->value = $1->value / $3->value;
        }else{
            assemble.var2reg($1, "%eax");
            assemble.var2reg($3, "%r9d");
            assemble.append("\tcltd\n");
            assemble.append("\tidivl\t%%r9d\n");
            offset -= 4;
            assemble.append("\tsubq\t$4, %%rsp\n");
            assemble.append("\tmovl\t%%eax, %d(%%rbp)\n", offset);
            $$->offset = offset;
        }
    }
    | MulExp MOD UnaryExp {
        $$=newNode(MUL_EXP_TYPE);
        addChildren($$, $1, $2, $3);
        if($1->isConst && $3->isConst){
            $$->isConst = true;
            $$->value = $1->value % $3->value;
        }else{
            assemble.var2reg($1, "%eax");
            assemble.var2reg($3, "%r9d");
            assemble.append("\tcltd\n");
            assemble.append("\tidivl %%r9d\n");
            offset -= 4;
            assemble.append("\tsubq\t$4, %%rsp\n");
            assemble.append("\tmovl\t%%edx, %d(%%rbp)\n", offset);
            $$->offset = offset;
        }
    }
;

AddExp : 
    MulExp {
		$$=newNode(ADD_EXP_TYPE);
		addChildren($$, $1);
        copyNode($$, $1);
	}
    | AddExp PLUS MulExp {
        $$=newNode(ADD_EXP_TYPE);
        addChildren($$, $1, $2, $3);
        if($1->isConst && $3->isConst){
            $$->isConst = true;
            $$->value = $1->value + $3->value;
        }else{
            assemble.var2reg($1, "%r8d");
            assemble.var2reg($3, "%r9d");
            assemble.append("\taddl\t%%r9d, %%r8d\n");
            offset -= 4;
            assemble.append("\tsubq\t$4, %%rsp\n");
            assemble.append("\tmovl\t%%r8d, %d(%%rbp)\n", offset);
            $$->offset = offset;
        }
    }
    | AddExp MINUS MulExp {
        $$=newNode(ADD_EXP_TYPE);
        addChildren($$, $1, $2, $3);
        if($1->isConst && $3->isConst){
            $$->isConst = true;
            $$->value = $1->value - $3->value;
        }else{
            assemble.var2reg($1, "%r8d");
            assemble.var2reg($3, "%r9d");
            assemble.append("\tsubl\t%%r9d, %%r8d\n");
            offset -= 4;
            assemble.append("\tsubq\t$4, %%rsp\n");
            assemble.append("\tmovl\t%%r8d, %d(%%rbp)\n", offset);
            $$->offset = offset;
        }
    }
;

RelExp : 
    AddExp {
        $$=newNode(REL_EXP_TYPE);
        addChildren($$, $1);
        copyNode($$, $1);
    }
    | AddExp LESST AddExp {
        $$=newNode(REL_EXP_TYPE);
        addChildren($$, $1, $2, $3);
        $$->quad = assemble.newLabel();
        assemble.comment("if <");
        assemble.var2reg($1, "%r8d");
        assemble.var2reg($3, "%r9d");
        assemble.append("\tcmpl\t%%r9d, %%r8d\n");
        assemble.append("\tjl\t.L");
        $$->trueList.push_back(assemble.line);
        assemble.append("\tjmp\t.L");
        $$->falseList.push_back(assemble.line);
    }
    | AddExp GREATERT AddExp {
        $$=newNode(REL_EXP_TYPE);
        addChildren($$, $1, $2, $3);
        $$->quad = assemble.newLabel();
        assemble.comment("if >");
        assemble.var2reg($1, "%r8d");
        assemble.var2reg($3, "%r9d");
        assemble.append("\tcmpl\t%%r9d, %%r8d\n");
        assemble.append("\tjg\t.L");
        $$->trueList.push_back(assemble.line);
        assemble.append("\tjmp\t.L");
        $$->falseList.push_back(assemble.line);
    }
    | AddExp LESSE AddExp {
        $$=newNode(REL_EXP_TYPE);
        addChildren($$, $1, $2, $3);
        $$->quad = assemble.newLabel();
        assemble.comment("if <=");
        assemble.var2reg($1, "%r8d");
        assemble.var2reg($3, "%r9d");
        assemble.append("\tcmpl\t%%r9d, %%r8d\n");
        assemble.append("\tjle\t.L");
        $$->trueList.push_back(assemble.line);
        assemble.append("\tjmp\t.L");
        $$->falseList.push_back(assemble.line);
    }
    | AddExp GREATERE AddExp {
        $$=newNode(REL_EXP_TYPE);
        addChildren($$, $1, $2, $3);
        $$->quad = assemble.newLabel();
        assemble.comment("if >=");
        assemble.var2reg($1, "%r8d");
        assemble.var2reg($3, "%r9d");
        assemble.append("\tcmpl\t%%r9d, %%r8d\n");
        assemble.append("\tjge\t.L");
        $$->trueList.push_back(assemble.line);
        assemble.append("\tjmp\t.L");
        $$->falseList.push_back(assemble.line);
    }
    | error{
        $$=newNode(REL_EXP_TYPE);
        $$->isError = 1;
        yyerror("Unexpected token in RelExp\n");
    }
;

EqExp : 
    RelExp {
		$$=newNode(EQ_EXP_TYPE);
		addChildren($$, $1);
        copyNode($$, $1);
	}
    | RelExp EQ RelExp {
        $$=newNode(EQ_EXP_TYPE);
        addChildren($$, $1, $2, $3);
        $$->quad = assemble.newLabel();
        assemble.comment("if ==");
        assemble.var2reg($1, "%r8d");
        assemble.var2reg($3, "%r9d");
        assemble.append("\tcmpl\t%%r9d, %%r8d\n");
        assemble.append("\tje\t.L");
        $$->trueList.push_back(assemble.line);
        assemble.append("\tjmp\t.L");
        $$->falseList.push_back(assemble.line);
    }
    | RelExp NEQ RelExp {
        $$=newNode(EQ_EXP_TYPE);
        addChildren($$, $1, $2, $3);
        $$->quad = assemble.newLabel();
        assemble.comment("if !=");
        assemble.var2reg($1, "%r8d");
        assemble.var2reg($3, "%r9d");
        assemble.append("\tcmpl\t%%r9d, %%r8d\n");
        assemble.append("\tjne\t.L");
        $$->trueList.push_back(assemble.line);
        assemble.append("\tjmp\t.L");
        $$->falseList.push_back(assemble.line);
    }
;

LAndExp : 
    EqExp {
		$$=newNode(L_AND_EXP_TYPE);
		addChildren($$, $1);
        copyNode($$, $1);
        if(!$$->quad){
            $$->quad = assemble.newLabel();
            assemble.var2reg($1, "%r8d");
            assemble.append("\tcmpl\t$0, %%r8d\n");
            assemble.append("\tjne\t.L");
            $$->trueList.push_back(assemble.line);
            assemble.append("\tjmp\t.L");
            $$->falseList.push_back(assemble.line);
        }
	}
    | LAndExp AND EqExp {
        $$=newNode(L_AND_EXP_TYPE);
        addChildren($$, $1, $2, $3);
        assemble.backpatch($1->trueList, $3->quad);
        $$->trueList = $3->trueList;
        $$->falseList = merge($1->falseList, $3->falseList);
        $$->quad = $1->quad;
    }
;

LOrExp : 
    LAndExp {
		$$=newNode(L_OR_EXP_TYPE);
		addChildren($$, $1);
        copyNode($$, $1);
	}
    | LOrExp OR LAndExp {
        $$=newNode(L_OR_EXP_TYPE);
        addChildren($$, $1, $2, $3);
        assemble.backpatch($1->falseList, $3->quad);
        $$->trueList = merge($1->trueList, $3->trueList);
        $$->falseList = $3->falseList;
        $$->quad = $1->quad;
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
    level = -1;
    nextLevel();
    offsetStack.push_back(0);
    yyparse();

    #ifdef ASSEMBLE_OUTPUT
    FILE* asm_file = fopen(argv[2], "w"); 
    assemble.toFile(asm_file); 
    fflush(asm_file);
    #endif

    #ifdef TREE_OUTPUT
    FILE* tree_file = fopen(argv[3], "w");
    printTree(root, tree_file);
    fflush(tree_file);
    #endif
}