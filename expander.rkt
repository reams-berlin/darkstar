#lang br/quicklang

(require racklog)

(define START-STATE "START")
(define CURRENT-STATE START-STATE)
(define STATES (list START-STATE))

(define %transitions-to %empty-rel)

(define (read-state next-state)
  (define current-state CURRENT-STATE)
  (add-state? current-state next-state)
  (add-rule? current-state next-state)
  (set! CURRENT-STATE next-state))

;; helper
(define (add-state? current-state next-state)
  (unless (member next-state STATES)
    (set! STATES (cons next-state STATES))))

;; helper
(define (add-rule? current-state next-state)
  (unless (%which ()
            (%transitions-to current-state next-state))
    (%assert! %transitions-to ()
              [(current-state next-state)])))

(define (reset)
  (set! CURRENT-STATE START-STATE))

(define (get-result x)
  (if (list? x) (cdr (car x)) x))

;; TODO: Write syntax for queries.
;; Providing query functions for now.

(define (count-transitions)
  (length (%find-all (from to) (%transitions-to from to))))
(provide count-transitions)

(define (transitions-to x)
  (map get-result (%find-all (from)
          (%transitions-to from x))))
(provide transitions-to)

(define (count-transitions-to state)
  (length (transitions-to state)))
(provide count-transitions-to)

(define (count-transitions-from state)
  (length (transitions-from state)))
(provide count-transitions-from)

(define (transitions-from x)
    (map get-result (%find-all (to)
          (%transitions-to x to))))
(provide transitions-from)

;; Macros

(define-macro (darkstar-mb PARSE-TREE)
  #'(#%module-begin
     PARSE-TREE))
(provide (rename-out [darkstar-mb #%module-begin]))

(define-macro (state-expr STATE)
  #'(read-state STATE))
(provide state-expr)

(define-macro (reset-expr N)
  #'(reset))
(provide reset-expr)

(define-macro (darkstar-program EXPR ...)
  #'(void EXPR ...))
(provide darkstar-program)
  




