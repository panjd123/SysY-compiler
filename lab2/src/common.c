#include "common.h"
#include <ctype.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static const char* typeStr[] = {
    "INT",
    "VOID",
    "IF",
    "ELSE",
    "WHILE",
    "RETURN",
    "BREAK",
    "CONST",
    "CONTINUE",
    "PLUS",
    "MINUS",
    "STAR",
    "DIV",
    "MOD",
    "LESST",
    "GREATERT",
    "LESSE",
    "GREATERE",
    "EQ",
    "NEQ",
    "AND",
    "OR",
    "NOT",
    "ASSIGN",
    "LEFTP",
    "RIGHTP",
    "LEFTS",
    "RIGHTS",
    "LEFTC",
    "RIGHTC",
    "COMMA",
    "SEMI",
    "INT_CONST",
    "INDENT",
    // type
    "COMP_UNIT",
    "DECL",
    "FUNC_DEF",
    "CONST_DECL",
    "CONST_DEF",
    "CONST_EXP",
    "VAR_DECL",
    "VAR_DEF",
    "EXP",
    "FUNC_F_PARAMS",
    "FUNC_F_PARAM",
    "STMT",
    "L_VAL",
    "COND",
    "UNARY_EXP",
    "UNARY_OP",
    "FUNC_R_PARAMS",
    "PRIMARY_EXP",
    "NUMBER",
    "EQ_EXP",
    "REL_EXP",
    "ADD_EXP",
    "MUL_EXP",
    "L_AND_EXP",
    "L_OR_EXP",
    "CONST_DEF_LIST",
    "VAR_DEF_LIST",
    "CONST_ARRAY_DIM",
    "ARRAY_DIM",
    "BLOCK",
    "BLOCK_ITEMS",
    "BLOCK_ITEM",
    "INIT_VAL",
    "INIT_VAL_LIST",
    "INIT_VAL_LIST_ITEMS",
    "CONST_INIT_VAL",
    "CONST_INIT_VAL_LIST",
    "CONST_INIT_VAL_LIST_ITEMS",
    "START",
    "UNKNOWN",
    "CONST_WITHOUT_DEF",
};

Node* newNode(Type type) {
    Node* node = (Node*)malloc(sizeof(Node));
    node->id = 0;
    node->type = type;
    node->childNum = 0;
    node->parent = NULL;
    node->kChild = 0;
    node->isError = 0;
    // printf("new node: %d\n", (int)type);
    // printType(type);
    node->text = (char*)typeStr[type];
    return node;
}

void addChildren(Node* parent, ...) {
    va_list ap;
    va_start(ap, parent);
    Node* child = va_arg(ap, Node*);
    while (child != NULL) {
        child->kChild = parent->childNum;
        parent->children[parent->childNum++] = child;
        child->parent = parent;
        child = va_arg(ap, Node*);
    }
    va_end(ap);
}

void printType(Type type) {
    int id = (int)type;
    printf("%s\n", typeStr[id]);
}

static int nodeId = 0;
static Node* treeNodes[10000];

void preprocessTree(Node* node) {
    if (node) {
        node->id = nodeId++;
        treeNodes[node->id] = node;
        for (int i = 0; i < node->childNum; i++) {
            preprocessTree(node->children[i]);
        }
    }
}

void specialChar(char* dest, char* source) {
    int k = 0;
    for (int j = 0; source[j] != '\0'; j++) {
        if (!isalpha(source[j]) && !isdigit(source[j])) {
            dest[k++] = '\\';
        }
        dest[k++] = source[j];
    }
    dest[k] = '\0';
}

void printTree(Node* node, FILE* output) {
    preprocessTree(node);
    fprintf(output, "digraph \" \"{\n");
    fprintf(output, "node [shape = record, height=.1]\n");
    for (int i = 0; i < nodeId; i++) {  // skip root
        Node* x = treeNodes[i];
        if (x->childNum > 0) {
            char tmp[100];
            fprintf(output, "%d[label = \"", x->id);
            for (int j = 0; j < x->childNum; j++) {
                specialChar(tmp, x->children[j]->text);
                fprintf(output, "<f%d> %s", j, tmp);
                if (x->children[j]->isError) {
                    fprintf(output, "(error)");
                }
                if (j != x->childNum - 1) {
                    fprintf(output, "|");
                }
            }
            fprintf(output, "\"];\n");
        }
    }
    for (int i = 1; i < nodeId; i++) {
        Node* x = treeNodes[i];
        if (x->childNum > 0) {
            fprintf(output, "%d:f%d->%d;\n", x->parent->id, x->kChild, x->id);
        }
    }
    fprintf(output, "}\n");
}