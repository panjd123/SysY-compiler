#include "common.hpp"
#include <cctype>
#include <cstdio>
#include <cstdlib>
#include <cstring>

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

void copyNode(Node* dest, Node* src) {
    dest->value = src->value;
    strcpy(dest->text, src->text);

    dest->isConst = src->isConst;
    dest->isArr = src->isArr;
    dest->offset = src->offset;
    dest->isGlobal = src->isGlobal;
    dest->isAddr = src->isAddr;
    dest->offsetInArray = src->offsetInArray;

    dest->trueList = src->trueList;
    dest->falseList = src->falseList;
    dest->quad = src->quad;
    dest->values = src->values;
}

Node* newNode(Type type, bool clear) {
    static vector<Node*> nodePool;
    if (clear) {
        for (auto node : nodePool) {
            delete node;
        }
        nodePool.clear();
        return nullptr;
    }
    Node* node = new Node;
    nodePool.push_back(node);
    node->id = 0;
    node->type = type;
    node->childNum = 0;
    node->parent = NULL;
    node->kChild = 0;
    node->isError = 0;
    node->isConst = false;
    node->isArr = false;
    // printf("new node: %d\n", (int)type);
    // printType(type);
    node->typeText[0] = '\0';
    if (static_cast<int>(type) > 0) {
        // node->text = typeStr[type];
        strcpy(node->typeText, typeStr[static_cast<int>(type)]);
    } else {
        // node->text = "";
        strcpy(node->typeText, "");
    }
    return node;
}

// void addChildren(Node* parent, ...) {
//     va_list ap;
//     va_start(ap, parent);
//     Node* child = va_arg(ap, Node*);
//     while (child != NULL) {
//         child->kChild = parent->childNum;
//         parent->children[parent->childNum++] = child;
//         child->parent = parent;
//         child = va_arg(ap, Node*);
//     }
//     va_end(ap);
// }

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

void specialChar(char* dest, const char* source) {
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
            char tmp[128];
            fprintf(output, "%d[label = \"", x->id);
            for (int j = 0; j < x->childNum; j++) {
                char* t;
                if (x->children[j]->typeText[0] == '\0') {
                    t = x->children[j]->text;
                } else {
                    t = x->children[j]->typeText;
                }
                specialChar(tmp, t);
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