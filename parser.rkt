#lang brag
darkstar-program : type-expr (goto-expr | context-expr)*
goto-expr : (state-expr | start-expr | reset-expr)
state-expr : STATE-EXPR
reset-expr : RESET-EXPR
start-expr : START-EXPR
context-expr : TYPE-EXPR VALUE-EXPR 
type-expr : TYPE-EXPR