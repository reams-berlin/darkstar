#lang br/quicklang
(require brag/support)

(define (make-tokenizer port)
  (define (next-token)
    (define darkstar-lexer
      (lexer
       [(:+ "\n") (next-token)]
       [(from/to ":" "\n") (token 'TYPE-EXPR (trim-ends ":" lexeme "\n"))]
       [(from/to "=" "\n") (token 'VALUE-EXPR (trim-ends "=" lexeme "\n"))]
       [(from/to ">>" "\n") (token 'START-EXPR (trim-ends ">>" lexeme "\n"))]
       [(from/to ">" "\n") (token 'RESET-EXPR (trim-ends ">" lexeme "\n"))]
       [(from/to ":" "\n") (token 'TYPE-EXPR (trim-ends ":" lexeme "\n"))]
       [(from/to ";;" "\n") (next-token)]
       [(from/to any-char "\n")
        (token 'STATE-EXPR (trim-ends "" lexeme "\n"))]))
    (darkstar-lexer port))  
  next-token)
(provide make-tokenizer)
