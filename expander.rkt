#lang br/quicklang

(require racklog)

(define START-STATE "--START--")
(define RESTART-STATE "--RESTART--")
(define NULL-STATE "--NULL--")
(define CURRENT-STATE NULL-STATE)
(define STATES empty)
(provide STATES)
(define CURRENT-CONTEXT empty)
(provide CURRENT-CONTEXT)
(define WAITING-TYPES empty)

(define %transitions-to %empty-rel)

(define (read-state next-state)
  (define from CURRENT-STATE)
  (define to next-state)
  (define context CURRENT-CONTEXT)
  
  (unless (member from (list NULL-STATE))
    (add-state? next-state)
    (add-rule? from context to))
  (unless (eq? CURRENT-STATE NULL-STATE)
    (set! CURRENT-STATE next-state)
    (set! CURRENT-CONTEXT empty)))

(define (add-state? next-state)
  (unless (member next-state STATES)
    (set! STATES (cons next-state STATES))))

(define (add-rule? from context to)
  (unless (%which ()
                  (%transitions-to  from context to))
    (%assert! %transitions-to ()
              [(from context to)])))

(define (start)
  (set! CURRENT-STATE START-STATE)
  (set! CURRENT-CONTEXT empty))

(define (set-context type val)
  (if (empty? WAITING-TYPES)
      (set! CURRENT-CONTEXT (cons (list type val) CURRENT-CONTEXT))
      (set! NESTED-CONTEXT (cons (cons (list type val) (first NESTED-CONTEXT)) (rest NESTED-CONTEXT)))))

(define (start-context type)
  (set! WAITING-TYPES (cons type WAITING-TYPES))
  (set! NESTED-CONTEXT (cons empty NESTED-CONTEXT)))

(define NESTED-CONTEXT empty)

(define (close-nested-context)
  (if (empty? (rest WAITING-TYPES))
      (void
  (set! CURRENT-CONTEXT (cons (list (first WAITING-TYPES) (first NESTED-CONTEXT)) CURRENT-CONTEXT))
  (set! WAITING-TYPES (rest WAITING-TYPES))
  (set! NESTED-CONTEXT (rest NESTED-CONTEXT)))
  (void (set! NESTED-CONTEXT (cons (cons (list (first WAITING-TYPES) (first NESTED-CONTEXT)) (second NESTED-CONTEXT)) (rest NESTED-CONTEXT)))
   (set! WAITING-TYPES (rest WAITING-TYPES)))))

(provide close-nested-context)
(define (reset)
  ;;CHANGE HERE reset goes to RESTART instead of START
  (read-state RESTART-STATE))

(define (get-result x)
  (cdr (cadr x)))

(define (print-transition transition)
  (define unwrapped (map cdr transition))
  (define from (car unwrapped))
  (define context (if (empty? (cdr unwrapped)) "" (cadr unwrapped)))
  (define to (caddr unwrapped))
  (printf "~a -> ~a\n~a\n" from to (print-context context)))

(define (print-pair pair)
  (cond
    [(string? (cadr pair)) (string-append ":" (car pair) " " (cadr pair) "\n")]
    [(string-append ":" (car pair) " {\n" (print-context (cadr pair)) "}\n")]))

(define (print-context context)
  (cond
    [(empty? context) ""]
    [(string-append (print-pair (first context)) (print-context (rest context)))]))


  

;; TODO: Write syntax for queries.
;; Providing query functions for now.

(define (states-with context)
  (map (lambda (x) (cdr (car x))) (%find-all (from _)
                                             (%transitions-to from context _))))
(provide states-with)

(define (transitions-from-with from context)
  (map (lambda (x) (cdr (car x))) (%find-all (to)
                                             (%transitions-to from context to))))
(provide transitions-from-with)
(provide quote)

(define (show-transitions)
  (for-each print-transition (%find-all (from context to) (%transitions-to from context to))))
(provide show-transitions)

(define (count-transitions)
  (length (%find-all (from context to) (%transitions-to from context to))))
(provide count-transitions)

(define (transitions-to to)
  (map get-result (%find-all (context from)
                             (%transitions-to from context to))))
(provide transitions-to)

(define (count-transitions-to state)
  (length (transitions-to state)))
(provide count-transitions-to)

(define (count-transitions-from state)
  (length (transitions-from state)))
(provide count-transitions-from)

(define (transitions-from from)
  (map get-result (%find-all (context to)
                             (%transitions-to from context to))))
(provide transitions-from)

(define (begin)
  (map get-result (%find-all (context to)
                             (%transitions-to START-STATE context to))))
(provide begin)


;; Macros

(define-macro (darkstar-mb PARSE-TREE)
  #'(#%module-begin
     'PARSE-TREE
     PARSE-TREE))
(provide (rename-out [darkstar-mb #%module-begin]))


(define-macro (type-def EXPR)
  #'void)
(provide type-def)

(define-macro (open-context-expr EXPR BRACKET)
  #'(start-context EXPR))
(provide open-context-expr)

(define-macro (nested-context-expr EXPR ...)
  #'(void EXPR ...))
(provide nested-context-expr)

(define-macro (close-context-expr BRACKET)
  #'(close-nested-context))
(provide close-context-expr)

(define-macro (goto-expr EXPR)
  #'EXPR)
(provide goto-expr)

(define-macro (state-expr STATE)
  #'(read-state STATE))
(provide state-expr)

(define-macro (context-expr TYPE VAL)
  #'(set-context TYPE VAL))
(provide context-expr)

(define-macro (reset-expr N)
  #'(reset))
(provide reset-expr)

(define-macro (start-expr N)
  #'(start))
(provide start-expr)

(define-macro (darkstar-program TYPE EXPR ...)
  #'(void EXPR ...))
(provide darkstar-program)

(define-macro (darkstar-expr EXPR ...)
  #'(void EXPR ...))
(provide darkstar-expr)



