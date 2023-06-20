#pragma once
#include <algorithm>
#include <cstdarg>
#include <fstream>
#include <map>
#include <queue>
#include <set>
#include <sstream>
#include <string>
#include <vector>
#include "common.hpp"
using namespace std;

using pii = pair<int, int>;

enum VarType { Int,
               ConstInt,
               Arr,
               ConstArr,
               FuncInt,
               FuncVoid,
               Addr };

struct Var {
    VarType type;
    int value;             // 用于常量
    int offset;            // 用于指示变量在栈中的位置
    bool isGlobal;         // 用于指示变量是否是全局变量，以区分处理方式
    vector<Node*> values;  // 用于函数参数，数组维度等
    vector<int> values2;   // 仅用于保存常量数组的值
    Var() {}
    Var(VarType type)
        : type(type) {}
    Var(VarType type, int value, int offset, bool isGlobal)
        : type(type), value(value), offset(offset), isGlobal(isGlobal) {}
    Var(VarType type, int value, int offset, bool isGlobal, vector<Node*> values)
        : type(type), value(value), offset(offset), isGlobal(isGlobal), values(values) {}
};

int getVarValue(Var var, int offset) {
    if (var.values2.size() < offset) {
        return 0;
    } else {
        return var.values2[offset];
    }
}

void tag();

class SPrintfBuffer {
   public:
    vector<string> buffer;
    int line = 0;
    void append(const char* format, ...) {
        va_list args;
        va_start(args, format);
        int len = vsnprintf(nullptr, 0, format, args);
        va_end(args);
        char* str = new char[len + 1];
        va_start(args, format);
        vsnprintf(str, len + 1, format, args);
        va_end(args);
        buffer.push_back(str);
        line = buffer.size() - 1;
        delete[] str;
    }
    inline string& operator[](int i) { return buffer[i]; }
    void toFile(FILE* file) {
        for (auto& i : buffer) {
            fprintf(file, "%s", i.c_str());
        }
    }
};

class Assemble : public SPrintfBuffer {
   public:
    Assemble() {
        buffer.push_back(".LC0:\n");
        buffer.push_back("\t.string\t\"\%d\"\n");
        buffer.push_back(".LC1:\n");
        buffer.push_back("\t.string\t\"\%d\\n\"\n");
    }
    int labelCount = 1;
    void call() {
        /*
        pushq	%rbp
        pushq	%r8
        pushq	%r9
        movq	%rsp, %rbp
        */
        buffer.push_back("\tpushq\t%rbp\n");
        buffer.push_back("\tpushq\t%r8\n");
        buffer.push_back("\tpushq\t%r9\n");
        buffer.push_back("\tmovq\t%rsp, %rbp\n");
    }

    void ret() {
        /*
        popq	%r9
        popq	%r8
        popq	%rbp
        ret
        */
        buffer.push_back("\tpopq\t%r9\n");
        buffer.push_back("\tpopq\t%r8\n");
        buffer.push_back("\tpopq\t%rbp\n");
        buffer.push_back("\tret\n");
    }

    // addr means put the address of the variable into the register, otherwise put the value
    void var2reg(Node* node, const char* reg, bool addr = false) {
        if (node->isConst) {
            this->append("\tmovl\t$%d, %s\n", node->value, reg);
        } else if (node->isGlobal) {  // 全局
            if (node->isArr) {
                this->append("\tmovl\t%d(%%rbp), %%ebx\n", node->offsetInArray);
                this->append("\tcltq\n");
                this->append("\tleaq\t0(, %%rbx, 4), %%rdx\n");
                this->append("\tleaq\t%s(%%rip), %%rbx\n", node->text);
                if (!addr) {
                    this->append("\tmovl\t(%%rdx, %%rbx), %s\n", reg);
                } else {
                    this->append("\tleaq\t(%%rdx, %%rbx), %s\n", reg);
                }
            } else {
                if (!addr) {
                    this->append("\tmovl\t%s(%%rip), %s\n", node->text, reg);
                } else {
                    this->append("\tleaq\t%s(%%rip), %s\n", node->text, reg);
                }
            }
        } else {
            if (node->isArr) {
                if (node->isAddr) {
                    this->append("\tmovl\t%d(%%rbp), %%ebx\n", node->offsetInArray);
                    this->append("\tcltq\n");
                    this->append("\tmovq\t%d(%%rbp), %%r10\n", node->offset);
                    if (!addr) {
                        this->append("\tmovl\t(%%r10, %%rbx, 4), %s\n", reg);
                    } else {
                        this->append("\tleaq\t(%%r10, %%rbx, 4), %s\n", reg);
                    }
                } else {
                    this->append("\tmovl\t%d(%%rbp), %%ebx\n", node->offsetInArray);
                    this->append("\tcltq\n");
                    if (!addr) {
                        this->append("\tmovl\t%d(%%rbp, %%rbx, 4), %s\n", node->offset, reg);
                    } else {
                        this->append("\tleaq\t%d(%%rbp, %%rbx, 4), %s\n", node->offset, reg);
                    }
                }
            } else {
                if (!addr) {
                    this->append("\tmovl\t%d(%%rbp), %s\n", node->offset, reg);
                } else {
                    this->append("\tleaq\t%d(%%rbp), %s\n", node->offset, reg);
                }
            }
        }
        tag();
    }

    void reg2var(const char* reg, Node* node) {
        if (node->isGlobal) {  // 全局
            if (node->isArr) {
                this->append("\tmovl\t%d(%%rbp), %%ebx\n", node->offsetInArray);
                this->append("\tcltq\n");
                this->append("\tleaq\t0(, %%rbx, 4), %%rdx\n");
                this->append("\tleaq\t%s(%%rip), %%rbx\n", node->text);
                this->append("\tmovl\t%s, (%%rdx, %%rbx)\n", reg);
            } else {
                this->append("\tmovl\t%s, %s(%%rip)\n", reg, node->text);
            }
        } else {
            if (node->isArr) {
                if (node->isAddr) {
                    this->append("\tmovl\t%d(%%rbp), %%ebx\n", node->offsetInArray);
                    this->append("\tcltq\n");
                    this->append("\tmovq\t%d(%%rbp), %%r10\n", node->offset);
                    this->append("\tmovl\t%s, (%%r10, %%rbx, 4)\n", reg);
                } else {
                    this->append("\tmovl\t%d(%%rbp), %%ebx\n", node->offsetInArray);
                    this->append("\tcltq\n");
                    this->append("\tmovl\t%s, %d(%%rbp, %rbx, 4)\n", reg, node->offset);
                }
            } else {
                this->append("\tmovl\t%s, %d(%%rbp)\n", reg, node->offset);
            }
        }
        tag();
    }

    void backpatch(const vector<int>& list, int label) {
        for (auto& i : list) {
            // if (buffer[i].back() == '\n') {
            //     buffer[i] = buffer[i].substr(0, buffer[i].size() - 1);
            // }
            buffer[i] += to_string(label) + "\n";
        }
    }

    int newLabel() {
        this->append(".L%d:\n", this->labelCount);
        return this->labelCount++;
    }

    void comment(const char* str) {
        this->append("\t# %s\n", str);
    }

    void comment(const string& str) {
        this->append("\t# %s\n", str.c_str());
    }
};

Assemble assemble;
int level = 0;  // 0: global
vector<map<string, Var>> varTable, funcTable;
vector<vector<pii>> breakStack, continueStack;
int offset;
vector<int> offsetStack;
char tmp[128];

string funcName;
bool inVoidFunc = false;
bool hasReturn = false;
vector<Node*> paramList;

template <typename T>
vector<T> merge(const vector<T>& a, const vector<T>& b) {
    vector<T> ret;
    for (auto& i : a) {
        ret.push_back(i);
    }
    for (auto& i : b) {
        ret.push_back(i);
    }
    sort(ret.begin(), ret.end());
    ret.erase(unique(ret.begin(), ret.end()), ret.end());
    return ret;
}

void nextLevel() {
    level++;
    varTable.push_back(map<string, Var>());
    funcTable.push_back(map<string, Var>());
}

void exitLevel() {
    level--;
    varTable.pop_back();
    funcTable.pop_back();
}

void alignStack() {
    int padding = (16 - abs(offset) % 16) % 16;
    if (padding == 0)
        return;
    offset -= padding;
    assemble.append("\tsubq\t$%d, %%rsp\n", padding);
    assemble.comment("align stack");
}

void recoverStack() {
    if (offsetStack.empty())
        throw runtime_error("offsetStack is empty");
    int oldOffset = offsetStack.back();
    offsetStack.pop_back();
    assemble.append("\taddq\t$%d, %%rsp\n", oldOffset - offset);
    offset = oldOffset;
}

bool isVarInTable(const string& name) {
    for (int i = level; i >= 0; i--) {
        if (varTable[i].find(name) != varTable[i].end()) {
            return true;
        }
    }
    return false;
}

bool isFuncInTable(const string& name) {
    for (int i = level; i >= 0; i--) {
        if (funcTable[i].find(name) != funcTable[i].end()) {
            return true;
        }
    }
    return false;
}

void insertVar(const string& name, Var var) {
    varTable[level][name] = var;
}

void insertFunc(const string& name, Var var) {
    funcTable[level][name] = var;
}

using piv = pair<int, Var>;

piv getVar(const string& name) {
    for (int i = level; i >= 0; i--) {
        if (varTable[i].find(name) != varTable[i].end()) {
            return make_pair(i, varTable[i][name]);
        }
    }
    return make_pair(-1, Var());
}

piv getFunc(const string& name) {
    for (int i = level; i >= 0; i--) {
        if (funcTable[i].find(name) != funcTable[i].end()) {
            return make_pair(i, funcTable[i][name]);
        }
    }
    return make_pair(-1, Var());
}

extern int current_line;
extern int current_column;
extern char* filename;

void tag() {
    char tmp[128];
    sprintf(tmp, "%d %s:%d:%d",
            level, filename, current_line, current_column);
    assemble.comment(tmp);
}