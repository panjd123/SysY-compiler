#ifndef COMMON_H
#define COMMON_H
#include <cstdio>
#include <string>
#include <vector>
#define CHILD_MAX 16

using std::string;
using std::vector;

typedef enum TokenType {
    K,  // keyword
    I,  // identifier
    C,  // constant
    O,  // operator
    D,  // delimiter
    T,  // other
} TokenType;

typedef enum Type {
    NORMAL_TYPE = -2,
    ERROR_TYPE = -1,
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

enum NodeType {
    NORMAL_NODE,
    ERROR_NODE,
    TERMINAL_NODE,
};

typedef struct Node {
    int id;
    Type type;
    char text[128];
    char typeText[128];
    int isError;

    struct Node* parent;
    int kChild;  // this node is the kChild-th child of its parent
    struct Node* children[CHILD_MAX];
    int childNum;

    int value;
    bool isConst;
    bool isArr;
    bool isGlobal;
    bool isAddr;        // 是否是根据地址定位的，如果是，则 offset 指向的是存储地址的指针，而非数组本身
    int offset;         // offset to ebp
    int offsetInArray;  // offset in array
    int quad;
    vector<int> trueList, falseList;
    vector<Node*> values;
} Node;

void copyNode(Node* dest, Node* src);

Node* newNode(Type type, bool clear = false);

template <typename... Args>
void addChildren(Node* parent, Node* child, Args... args) {
    child->kChild = parent->childNum;
    parent->children[parent->childNum++] = child;
    child->parent = parent;
    if constexpr (sizeof...(args) > 0) {
        addChildren(parent, args...);
    }
}

void printType(Type type);
void printTree(Node* node, FILE* output);
#endif