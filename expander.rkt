#lang br/quicklang

(require racklog)

(define RESTART-STATE "--RESET--")
(define CURRENT-STATE "--START--")
(define STATE-HIERARCHY (list CURRENT-STATE))

(define %transitions-to %empty-rel)

(define (read-state next-state)
  (define from CURRENT-STATE)
  (define to next-state)
  (define context STATE-HIERARCHY)
  (add-rule? from context to)
  (set! CURRENT-STATE next-state))
 
(define (add-rule? from context to)
  (unless (%which ()
                  (%transitions-to from context to))
    (%assert! %transitions-to ()
              [(from context to)])))

(define (start)
  (read-state (first STATE-HIERARCHY))
  (set! CURRENT-STATE (first STATE-HIERARCHY)))

(define (reset)
  (read-state RESTART-STATE))

(define (start-model state)
  (read-state state)
  (set! STATE-HIERARCHY (cons state STATE-HIERARCHY)))

(define (close-model val)
  (read-state val)
  (set! STATE-HIERARCHY (rest STATE-HIERARCHY)))

(define (print-transition transition)
  (define unwrapped (map cdr transition))
  (define from (car unwrapped))
  (define context (cadr unwrapped))
  (define to (caddr unwrapped))
  (printf "~a -> ~a\n~a\n\n" from to context))

(define (get-result x)
  (cdr (cadr x)))

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

(define (begin start)
  (map get-result (%find-all (context to)
                             (%transitions-to start context to))))
(provide begin)




;; Macros

(define-macro (darkstar-mb PARSE-TREE)
  (displayln "module begin")
  #'(#%module-begin
     'PARSE-TREE
     PARSE-TREE))

(provide (rename-out [darkstar-mb #%module-begin]))


(define-macro (nested-model-expr VALUE OPEN-BRACKET EXPR ... CLOSE-BRACKET)
  #'(void (start-model VALUE)
          EXPR ...
          (close-model VALUE)))
(provide nested-model-expr)

(define-macro (goto-expr EXPR)
  #'EXPR)
(provide goto-expr)

(define-macro (state-expr STATE)
  #'(read-state STATE))
(provide state-expr)

(define-macro (reset-expr N)
  #'(reset))
(provide reset-expr)

(define-macro (start-expr N)
  #'(start))
(provide start-expr)

(define-macro (darkstar-program TYPE EXPR ...)
  (displayln "hello")
  #'(void TYPE EXPR ...))
(provide darkstar-program)

(define-macro (darkstar-expr EXPR)
  #'EXPR)
(provide darkstar-expr)



