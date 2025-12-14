%option noyywrap

%{
#include "cumilla.tab.h"
#include <stdlib.h>
#include <string.h>
%}

%%

rakh        { return RAKH; }
bol         { return BOL; }
jodi        { return JODI; }
taile       { return TAILE; }
naile       { return NAILE; }
sesh        { return SESH; }

[0-9]+      { yylval.ival = atoi(yytext); return NUMBER; }
[A-Za-z_][A-Za-z0-9_]* { yylval.sval = strdup(yytext); return IDENT; }

";"         { return ';'; }
"+"         { return '+'; }
"-"         { return '-'; }
"*"         { return '*'; }
"/"         { return '/'; }
"("         { return '('; }
")"         { return ')'; }

[ \t\n]+    { }

.           { return yytext[0]; }

%%
