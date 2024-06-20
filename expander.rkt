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
(define %transitions-to %empty-rel)



(define (read-state next-state)
  (define from CURRENT-STATE)
  (define to next-state)
  (define context CURRENT-CONTEXT)
  ;;CHANGE HERE: Don't add transition from RESTART
  (unless (member from (list NULL-STATE RESTART-STATE))
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
  (set! CURRENT-STATE START-STATE))

(define (set-current-context type val)
  (set! CURRENT-CONTEXT (cons (list type val) CURRENT-CONTEXT)))

  

(define (reset)
  ;;CHANGE HERE: reset goes to RESTART instead of START
  (set! CURRENT-STATE RESTART-STATE))

(define (get-result x)
  (cdr (cadr x)))
(provide cadr cdr)
;; TODO: Write syntax for queries.
;; Providing query functions for now.

(define (states-with context)
    (map (lambda (x) x) (%find-all (from _)
          (%transitions-to from context _))))

(define (transitions-from-with from context)
    (map (lambda (x) (cdr (car x))) (%find-all (to)
          (%transitions-to from context to))))
(provide transitions-from-with)
(provide quote)

(define (show-transitions)
    (%find-all (from context to) (%transitions-to from context to)))
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
     PARSE-TREE))
(provide (rename-out [darkstar-mb #%module-begin]))


(define-macro (type-expr EXPR)
  #'void)
(provide type-expr)

(define-macro (goto-expr EXPR)
  #'EXPR)
(provide goto-expr)

(define-macro (state-expr STATE)
  #'(read-state STATE))
(provide state-expr)

(define-macro (context-expr TYPE VAL)
  #'(set-current-context TYPE VAL))
(provide context-expr)

(define-macro (reset-expr N)
  #'(reset))
(provide reset-expr)

(define-macro (start-expr N)
  #'(start))
(provide start-expr)

(define-macro (darkstar-program EXPR ...)
  #'(void EXPR ...))
(provide darkstar-program)
  




