#lang brag


darkstar-program : darkstar-expr*
darkstar-expr : goto-expr | nested-model-expr | VALUE
goto-expr : (state-expr | start-expr | reset-expr)
state-expr : VALUE
reset-expr : RESET
start-expr : START
nested-model-expr : (VALUE OPEN-BRACKET darkstar-expr* CLOSE-BRACKET)