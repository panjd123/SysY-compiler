%option noyywrap
%{
    #include <stdio.h>
    #include <string.h>
    #include "common.hpp"
    #include "y.tab.h"

    #define UPDATE current_column += yyleng;

    int current_line = 1;
    int current_column = 1;
    char* filename;
    int token[]={
    INT,
    VOID,
    IF,
    ELSE,
    WHILE,
    RETURN,
    BREAK,
    CONST,
    CONTINUE,
    PLUS,
    MINUS,
    STAR,
    DIV,
    MOD,
    LESST,
    GREATERT,
    LESSE,
    GREATERE,
    EQ,
    NEQ,
    AND,
    OR,
    NOT,
    ASSIGN,
    LEFTP,
    RIGHTP,
    LEFTS,
    RIGHTS,
    LEFTC,
    RIGHTC,
    COMMA,
    SEMI,
    };

    char get_type_name(TokenType);

    int create_token(TokenType token_type, Type type) {
        Node node;
        node.type = type;
        strcpy(node.text, yytext);
        // node.text = yytext;
        #ifdef LEX_OUTPUT
        fprintf(yyout, "%s: %c, (%d, %d)\n", yytext, get_type_name(token_type), current_line, current_column);
        #endif
        UPDATE;
        if(token_type == C){
            yylval.node = newNode(INT_CONST_TYPE);
            strcpy(yylval.node->text, yytext);
            // yylval.node->text = yytext;
            yylval.node->value = atoi(yytext);
            return INTCONST;
        }
        if(token_type == I){ 
            if (type == NORMAL_TYPE) {
                yylval.node = newNode(IDENT_TYPE);
                strcpy(yylval.node->text, yytext);
                // yylval.node->text = yytext;
                return IDENT; 
            }
            else if(type == ERROR_TYPE){
                yylval.node = newNode(IDENT_TYPE);
                strcpy(yylval.node->text, yytext);
                // yylval.node->text = yytext;
                yylval.node->isError = 1;
                return IDENT;
            }
        }
        if(token_type == T){
            yylval.node = newNode(UNKNOWN_TYPE);
            strcpy(yylval.node->text, yytext);
            // yylval.node->text = yytext;
            return UNKNOWN;
        }
        yylval.node = newNode(type);
        // yylval.node->text = yytext;
        strcpy(yylval.node->text, yytext);
        return token[(int)type];
    }

    char get_type_name(TokenType type) {
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
%}

NewLine \r\n|\r|\n
Space [ \t]+
Continue continue
Main main
Const const
Int int
Void void
If if
Else else
While while
Break break
Return return
LeftP \(
RightP \)
LeftS \[
RightS \]
LeftC \{
RightC \}
Comma ,
Semi ;
Plus \+
Minus -
Star \*
Div \/
Mod %
LessT <
GreaterT >
LessE <=
GreaterE >=
Eq ==
NEq !=
And \&\&
Or \|\|
Not !
Assign =
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
WOG .

%x COMMENT

%%


{commentbegin} {BEGIN COMMENT; UPDATE;}
<COMMENT>{commentline} {current_line++; UPDATE;}
<COMMENT>{commentelement} {UPDATE;}
<COMMENT>{commentend} {BEGIN INITIAL; UPDATE;}

{LineComment} {UPDATE;}
{Main} {return create_token(I, NORMAL_TYPE);}
{Const} {return create_token(K, CONST_TYPE);}
{Int} {return create_token(K, INT_TYPE);}
{Void} {return create_token(K, VOID_TYPE);}
{If} {return create_token(K, IF_TYPE);}
{Else} {return create_token(K, ELSE_TYPE);}
{While} {return create_token(K, WHILE_TYPE);}
{Continue} {return create_token(K, CONTINUE_TYPE);}
{Break} {return create_token(K, BREAK_TYPE);}
{Return} {return create_token(K, RETURN_TYPE);}
{LeftP} {return create_token(D, LEFTP_TYPE);}
{RightP} {return create_token(D, RIGHTP_TYPE);}
{LeftS} {return create_token(D, LEFTS_TYPE);}
{RightS} {return create_token(D, RIGHTS_TYPE);}
{LeftC} {return create_token(D, LEFTC_TYPE);}
{RightC} {return create_token(D, RIGHTC_TYPE);}
{Comma} {return create_token(D, COMMA_TYPE);}
{Semi} {return create_token(D, SEMI_TYPE);}
{Plus} {return create_token(O, PLUS_TYPE);}
{Minus} {return create_token(O, MINUS_TYPE);}
{Star} {return create_token(O, STAR_TYPE);}
{Div} {return create_token(O, DIV_TYPE);}
{Mod} {return create_token(O, MOD_TYPE);}
{LessT} {return create_token(O, LESST_TYPE);}
{GreaterT} {return create_token(O, GREATERT_TYPE);}
{LessE} {return create_token(O, LESSE_TYPE);}
{GreaterE} {return create_token(O, GREATERE_TYPE);}
{Eq} {return create_token(O, EQ_TYPE);}
{NEq} {return create_token(O, NEQ_TYPE);}
{And} {return create_token(O, AND_TYPE);}
{Or} {return create_token(O, OR_TYPE);}
{Not} {return create_token(O, NOT_TYPE);}
{Assign} {return create_token(O, ASSIGN_TYPE);}

{IntConst} {return create_token(C, NORMAL_TYPE);}
{Ident} {return create_token(I, NORMAL_TYPE);}

{Space} {UPDATE; }
{NewLine} {current_line++; current_column = 1; }
{WOGIdent} {
    printf("%s:%d:%d: error(lex): Wrong ident: %s\n",
        filename, current_line, current_column,
        yytext);
    return create_token(I, ERROR_TYPE);}
{WOG} {return create_token(T, ERROR_TYPE);}

%%
// int main(int argc, char **argv) {
//     yylex();
//     return 0;
// }