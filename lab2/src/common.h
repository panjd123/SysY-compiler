#ifndef COMMON_H
#define COMMON_H
#include <stdarg.h>
#include <stdio.h>
#define CHILD_MAX 16
typedef enum TokenType {
    K,  // keyword
    I,  // identifier
    C,  // constant
    O,  // operator
    D,  // delimiter
    T,  // other
} TokenType;
typedef enum Type {
    INT_TYPE,
    VOID_TYPE,
    IF_TYPE,
    ELSE_TYPE,
    WHILE_TYPE,
    RETURN_TYPE,
    BREAK_TYPE,
    CONST_TYPE,
    CONTINUE_TYPE,
    PLUS_TYPE,
    MINUS_TYPE,
    STAR_TYPE,
    DIV_TYPE,
    MOD_TYPE,
    LESST_TYPE,
    GREATERT_TYPE,
    LESSE_TYPE,
    GREATERE_TYPE,
    EQ_TYPE,
    NEQ_TYPE,
    AND_TYPE,
    OR_TYPE,
    NOT_TYPE,
    ASSIGN_TYPE,
    LEFTP_TYPE,
    RIGHTP_TYPE,
    LEFTS_TYPE,
    RIGHTS_TYPE,
    LEFTC_TYPE,
    RIGHTC_TYPE,
    COMMA_TYPE,
    SEMI_TYPE,
    INT_CONST_TYPE,
    IDENT_TYPE,
    // type
    COMP_UNIT_TYPE,
    DECL_TYPE,
    FUNC_DEF_TYPE,
    CONST_DECL_TYPE,
    CONST_DEF_TYPE,
    CONST_EXP_TYPE,
    VAR_DECL_TYPE,
    VAR_DEF_TYPE,
    EXP_TYPE,
    FUNC_F_PARAMS_TYPE,
    FUNC_F_PARAM_TYPE,
    STMT_TYPE,
    L_VAL_TYPE,
    COND_TYPE,
    UNARY_EXP_TYPE,
    UNARY_OP_TYPE,
    FUNC_R_PARAMS_TYPE,
    PRIMARY_EXP_TYPE,
    NUMBER_TYPE,
    EQ_EXP_TYPE,
    REL_EXP_TYPE,
    ADD_EXP_TYPE,
    MUL_EXP_TYPE,
    L_AND_EXP_TYPE,
    L_OR_EXP_TYPE,
    CONST_DEF_LIST_TYPE,
    VAR_DEF_LIST_TYPE,
    CONST_ARRAY_DIM_TYPE,
    ARRAY_DIM_TYPE,
    BLOCK_TYPE,
    BLOCK_ITEMS_TYPE,
    BLOCK_ITEM_TYPE,
    INIT_VAL_TYPE,
    INIT_VAL_LIST_TYPE,
    INIT_VAL_LIST_ITEMS_TYPE,
    CONST_INIT_VAL_TYPE,
    CONST_INIT_VAL_LIST_TYPE,
    CONST_INIT_VAL_LIST_ITEMS_TYPE,
    START_TYPE,
    UNKNOWN_TYPE,
    CONST_WITHOUT_DEF_TYPE,
} Type;

typedef struct Node {
    int id;
    Type type;
    int value;
    char* text;
    int isError;

    struct Node* parent;
    int kChild;  // this node is the kChild-th child of its parent
    struct Node* children[CHILD_MAX];
    int childNum;
} Node;

Node* newNode(Type type);
void addChildren(Node* parent, ...);
void printType(Type type);
void printTree(Node* node, FILE* output);
#endif