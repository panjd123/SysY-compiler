%option noyywrap
%{
    #include <stdio.h>
    #include <string.h>
    typedef enum token_type {
        K, // keyword
        I, // identifier
        C, // constant
        O, // operator
        D, // delimiter
        T, // other
    } token_type;
    typedef enum keyword_value {
        INT,
        VOID,
        IF,
        ELSE,
        WHILE,
        RETURN,
        BREAK,
        CONST,
        MAIN,
    } keyword_value;
    typedef enum operator_value {
        PLUS,
        MINUS,
        STAR,
        DIV,
        MOD,
        LT,
        GT,
        LE,
        GE,
        EQ,
        NE,
        AND,
        OR,
        NOT,
        ASSIGN,
    } operator_value;
    typedef enum delimiter_value {
        LP,
        RP,
        LS,
        RS,
        LC,
        RC,
        COMMA,
        SEMI,
    } delimiter_value;
    typedef struct token{
        token_type type;
        char *text;
        int value;
    } token;
    token* create_token_ptr(token_type type, int value) {
        char* text = yytext;
        token *tmp = malloc(sizeof(token));
        tmp->type = type;
        tmp->text = malloc(strlen(text) + 1);
        strcpy(tmp->text, text);
        tmp->value = value;
        return tmp;
    }
    token create_token(token_type type, int value) {
        char* text = yytext;
        token tmp;
        tmp.type = type;
        tmp.text = malloc(strlen(text) + 1);
        strcpy(tmp.text, text);
        tmp.value = value;
        return tmp;
    }
    char get_type_name(token_type type) {
        switch (type) {
            case K: return 'K';
            case I: return 'I';
            case C: return 'C';
            case O: return 'O';
            case D: return 'D';
            case T: return 'T';
            default: return '?';
        }
    }
    int current_line = 1;
    int current_column = 1;
    #define UPDATE current_column += yyleng;
    #define OUTPUT fprintf(yyout, "%s: %c, (%d, %d)\n", yytext, get_type_name(tmp.type), current_line, current_column);
%}

NEWLINE \r\n|\r|\n
SPACE [ \t]+
Main main
Const const
Int int
Void void
If if
Else else
While while
Break break
Return return
LP \(
RP \)
LS \[
RS \]
LC \{
RC \}
COMMA ,
SEMI ;
PLUS \+
MINUS -
STAR \*
DIV \/
MOD %
LT <
GT >
LE <=
GE >=
EQ ==
NE !=
AND &&
OR \|\|
NOT !
ASSIGN =
Ident [a-zA-Z_][a-zA-Z_0-9]*
WOGIdent [0-9][a-zA-Z_0-9]*
OctConst 0[0-7]*
DecConst [1-9][0-9]*
HexConst 0[xX][0-9a-fA-F]+
IntConst {DecConst}|{OctConst}|{HexConst}
LineComment \/\/[^\n]*
commentbegin "/*"
commentelement .
commentline \n
commentend "*/"
WOG .|{WOGIdent}

%x COMMENT

%%


{commentbegin} {BEGIN COMMENT; UPDATE;}
<COMMENT>{commentline} {current_line++; UPDATE;}
<COMMENT>{commentelement} {UPDATE;}
<COMMENT>{commentend} {BEGIN INITIAL; UPDATE;}

{LineComment} {UPDATE;}
{Main} {token tmp = create_token(K, MAIN); OUTPUT; UPDATE;}
{Const} {token tmp = create_token(K, CONST); OUTPUT; UPDATE;}
{Int} {token tmp = create_token(K, INT); OUTPUT; UPDATE;}
{Void} {token tmp = create_token(K, VOID); OUTPUT; UPDATE;}
{If} {token tmp = create_token(K, IF); OUTPUT; UPDATE;}
{Else} {token tmp = create_token(K, ELSE); OUTPUT; UPDATE;}
{While} {token tmp = create_token(K, WHILE); OUTPUT; UPDATE;}
{Break} {token tmp = create_token(K, BREAK); OUTPUT; UPDATE;}
{Return} {token tmp = create_token(K, RETURN); OUTPUT; UPDATE;}
{LP} {token tmp = create_token(D, LP); OUTPUT; UPDATE;}
{RP} {token tmp = create_token(D, RP); OUTPUT; UPDATE;}
{LS} {token tmp = create_token(D, LS); OUTPUT; UPDATE;}
{RS} {token tmp = create_token(D, RS); OUTPUT; UPDATE;}
{LC} {token tmp = create_token(D, LC); OUTPUT; UPDATE;}
{RC} {token tmp = create_token(D, RC); OUTPUT; UPDATE;}
{COMMA} {token tmp = create_token(D, COMMA); OUTPUT; UPDATE;}
{SEMI} {token tmp = create_token(D, SEMI); OUTPUT; UPDATE;}
{PLUS} {token tmp = create_token(O, PLUS); OUTPUT; UPDATE;}
{MINUS} {token tmp = create_token(O, MINUS); OUTPUT; UPDATE;}
{STAR} {token tmp = create_token(O, STAR); OUTPUT; UPDATE;}
{DIV} {token tmp = create_token(O, DIV); OUTPUT; UPDATE;}
{MOD} {token tmp = create_token(O, MOD); OUTPUT; UPDATE;}
{LT} {token tmp = create_token(O, LT); OUTPUT; UPDATE;}
{GT} {token tmp = create_token(O, GT); OUTPUT; UPDATE;}
{LE} {token tmp = create_token(O, LE); OUTPUT; UPDATE;}
{GE} {token tmp = create_token(O, GE); OUTPUT; UPDATE;}
{EQ} {token tmp = create_token(O, EQ); OUTPUT; UPDATE;}
{NE} {token tmp = create_token(O, NE); OUTPUT; UPDATE;}
{AND} {token tmp = create_token(O, AND); OUTPUT; UPDATE;}
{OR} {token tmp = create_token(O, OR); OUTPUT; UPDATE;}
{NOT} {token tmp = create_token(O, NOT); OUTPUT; UPDATE;}
{ASSIGN} {token tmp = create_token(O, ASSIGN); OUTPUT; UPDATE;}

{IntConst} {token tmp = create_token(C, 0); OUTPUT; UPDATE;}
{Ident} {token tmp = create_token(I, 0); OUTPUT; UPDATE;}

{SPACE} {UPDATE; }
{NEWLINE} {current_line++; current_column = 1; }
{WOG} {token tmp=create_token(T, 0); OUTPUT; UPDATE;}

%%
int main(int argc, char **argv) {
    yylex();
    return 0;
}