#lang brag


darkstar-program : type-def darkstar-expr*
type-def : TYPE
darkstar-expr : (goto-expr | context-expr | nested-context-expr)
goto-expr : (state-expr | start-expr | reset-expr)
state-expr : VALUE
reset-expr : RESET
start-expr : START
context-expr :  TYPE VALUE
open-context-expr : TYPE "{"
nested-context-expr : (open-context-expr (context-expr | nested-context-expr)* close-context-expr)
close-context-expr : "}"