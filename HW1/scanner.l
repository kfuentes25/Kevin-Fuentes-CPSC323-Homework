/* =========================
 * Flex source (.l) file for the HW1 Part II example.
 * File structure: 1. Definitions Section / 2. Rules Section / 3. User Code Section
 *
 * 1. DEFINITIONS SECTION (Main focus)
 * TODO: Update the token patterns to match the provide input source code (sourcecode.txt) and HW1 specified requirements.
 * (Optional) Extend your definitions to handle additional cases commonly found in real programming languages.
 *
 * 2. RULES SECTION (Main focus)
 * TODO: Update and/or add rules to correctly recognize tokens and perform HW1 specified requirements.
 *
 * 3. USER CODE SECTION
 * TODO: Update the input source-code filename and complete any needed C code.
 *
 * Begin your implementation from this provided starter code (if you choose to use Flex)
 *
 * You are responsible for checking and debugging Flex syntax issues during development.
 * ========================= */

%option noyywrap
%option yylineno

%{
#include <stdio.h>
#include <stdlib.h>

FILE *fout = NULL;   /* output file handle */

void handle_lexical_error(const char *lexeme);
%}

%x COMMENT
%option yylineno

/* === 1.DEFINITIONS SECTION === */

DIGIT       [0-9]
LETTER      [A-Za-z_]
UNDERSCORE  [_]

/* identifier */
ID  ({LETTER}|{UNDERSCORE})({LETTER}|{DIGIT})*

/* keyword */
KEYWORD  (while|if|else|for|return|int|char|double|float|void)

/* integer */
INTEGER  0|[1-9]{DIGIT}*

/* string */
STRING \"([^\"\\\n]|\\.)*\"

/* whitespace */
WS  [ \t\r\n]+

/* double-line comments */
DOUBLELINECOMMENT \/\*([^*]|\*+[^*/])*\*+\/

/* single-line comments */
LINECOMMENT  \/\/[^\n]*

/* operators: double-char*/
OP2 "=="|"<="|">="|"+="|"-="|"<<"|">>"|"&&"|"||"

/* operators: single-char */
OP1  [><=/+*%-]

/* parentheses */
PARENS  [\[\]\(\)\{\}]

/* punctuation */
PUNC  [;,.:]

%%

%{
/* === 2.RULES SECTION === */
%}
\" { printf("I FOUND A QUOTE!\n"); }


{WS}                 { /* ignore */ }

{LINECOMMENT}        { /* ignore */ }

{DOUBLELINECOMMENT}  { /* ignore */ }

{KEYWORD}            { fprintf(stdout, "%-30s %-20s\n", yytext, "KEYWORD");
                          if (fout) fprintf(fout, "%-30s %-20s\n", yytext, "KEYWORD");}

{INTEGER}            { fprintf(stdout, "%-30s %-20s\n", yytext, "INTEGER");
                          if (fout) fprintf(fout, "%-30s %-20s\n", yytext, "INTEGER");}

{STRING}            { fprintf(stdout, "%-30s %-20s\n", yytext, "STRING");
                          if (fout) fprintf(fout, "%-30s %-20s\n", yytext, "STRING");}

{ID}                 { fprintf(stdout, "%-30s %-20s\n", yytext, "IDENTIFIER");
                          if (fout) fprintf(fout, "%-30s %-20s\n", yytext, "IDENTIFIER");}

{OP2}                { fprintf(stdout, "%-30s %-20s\n", yytext, "OPERATOR 2");
                          if (fout) fprintf(fout, "%-30s %-20s\n", yytext, "OPERATOR 2");}

{OP1}                { fprintf(stdout, "%-30s %-20s\n", yytext, "OPERATOR 1");
                          if (fout) fprintf(fout, "%-30s %-20s\n", yytext, "OPERATOR 1");}

{PARENS}             { fprintf(stdout, "%-30s %-20s\n", yytext, "PARENTHESES");
                          if (fout) fprintf(fout, "%-30s %-20s\n", yytext, "PARENTHESES"); }

{PUNC}               { fprintf(stdout, "%-30s %-20s\n", yytext, "PUNCTUATION");
                          if (fout) fprintf(fout, "%-30s %-20s\n", yytext, "PUNCTUATION"); }

.                    { handle_lexical_error(yytext);} 

%%

/* === 3. USER CODE SECTION === */

void handle_lexical_error (const char *lexeme)
{
    fprintf(stdout, "%-30s %-20s\n", lexeme, "LEXICAL ERROR"); 
    if (fout) fprintf(fout, "%-30s %-20s\n", lexeme, "LEXICAL ERROR"); 
    fprintf(stderr, "Lexical error '%s' is at line %d:\n", lexeme, yylineno);
}

int main(void)
{

    /* open "inputsourcecode.txt" as yyin */
    yyin = fopen("inputsourcecode.txt", "r");
    if (!yyin) {
        perror("Failed to open inputsourcecode.txt");
        return 1;
    }

    /* open "output" file for writing */
    fout = fopen("output", "w");
    if (!fout) {
        perror("Failed to open output");
        fclose(yyin);
        return 1;
    }

    /* table header */
    fprintf(stdout, "%-30s %-20s\n", "Lexeme", "Token");
    fprintf(stdout, "%-30s %-20s\n", "------", "-----");
    fprintf(fout,   "%-30s %-20s\n", "Lexeme", "Token");
    fprintf(fout,   "%-30s %-20s\n", "------", "-----");

    /* run scanner */
    yylex();

    fclose(fout);
    fclose(yyin);
    return 0;
}