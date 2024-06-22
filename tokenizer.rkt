#lang br/quicklang
(require brag/support)

(define (make-tokenizer port)
  (define (next-token)
    (define darkstar-lexer
      (lexer
       [(:= 1 ">") (token 'RESET)]
       [(:= 1 ",") (token 'START)]
       [(:= 1 "{") (token 'OPEN-BRACKET)]
       [(:= 1 "}") (token 'CLOSE-BRACKET)]
       [(:+ (:: (:+ (union upper-case lower-case numeric (char-set ",'-"))) (:* " "))) (token 'VALUE lexeme)]
       [(:: ":" (:+ (union upper-case lower-case numeric))) (token 'TYPE (trim-ends ":" lexeme " "))]
       [(from/to ";;" "\n") (next-token)]
       [(:+ "\n" )(next-token)]
       [(:+ " ") (next-token)]
       [any-char lexeme]))
    (darkstar-lexer port))  
  next-token)
(provide make-tokenizer)
