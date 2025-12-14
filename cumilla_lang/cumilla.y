%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct symnode {
    char *name;
    int value;
    struct symnode *next;
} symnode;

symnode *symtab = NULL;

int lookup(const char *name);
void insert(const char *name, int value);

int yylex();
void yyerror(const char *s);

#define UNDEF (-2147483647 - 1)
%}

%union {
    int ival;
    char* sval;
}

%token <ival> NUMBER
%token <sval> IDENT
%token RAKH BOL JODI TAILE NAILE SESH

%type <ival> expr

%left '+' '-'
%left '*' '/'
%right UMINUS

%%

program:
    program stmt
    |
    ;

stmt:
    RAKH IDENT expr ';'
        { insert($2, $3); free($2); }
  | BOL expr ';'
        { printf("%d\n", $2); }
  | JODI expr TAILE stmt SESH
        { if ($2) {} }
  | JODI expr TAILE stmt NAILE stmt SESH
        { if ($2) {} else {} }
  ;

expr:
    expr '+' expr { $$ = $1 + $3; }
  | expr '-' expr { $$ = $1 - $3; }
  | expr '*' expr { $$ = $1 * $3; }
  | expr '/' expr {
        if ($3 == 0) {
            yyerror("Division by zero");
            $$ = 0;
        } else $$ = $1 / $3;
    }
  | '-' expr %prec UMINUS { $$ = -$2; }
  | IDENT {
        int v = lookup($1);
        if (v == UNDEF) {
            yyerror("Undefined variable");
            $$ = 0;
        } else $$ = v;
        free($1);
    }
  | NUMBER { $$ = $1; }
  | '(' expr ')' { $$ = $2; }
  ;
%%

int lookup(const char *name) {
    symnode *c = symtab;
    while (c) {
        if (strcmp(c->name, name) == 0)
            return c->value;
        c = c->next;
    }
    return UNDEF;
}

void insert(const char *name, int value) {
    symnode *c = symtab;
    while (c) {
        if (strcmp(c->name, name) == 0) {
            c->value = value;
            return;
        }
        c = c->next;
    }
    symnode *n = malloc(sizeof(symnode));
    n->name = strdup(name);
    n->value = value;
    n->next = symtab;
    symtab = n;
}

void yyerror(const char *s) {
    printf("Error: %s\n", s);
}

int main() {
    printf("Cumilla Mini Language Start\n");
    yyparse();
    return 0;
}
