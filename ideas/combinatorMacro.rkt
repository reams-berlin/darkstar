#lang darkstar


sandwich {
          Bread {
                 Meat { Cheese },
                 Cheese { Meat }
                 },
          Meat {
                Bread { Cheese },
                Cheese { Bread }
                },
          Cheese {
                  Meat { Bread },
                  Bread { Meat }
                  }
          }

; sandwich [
;           Bread
;           Cheese
;           Meat
;           ]
; --->
; 
;;; sandwich {
;;           1 {
;;              Bread
;;              Meat
;;              Cheese
;;              },
;;           
;;           2 {
;;              Bread
;;              Cheese
;;              Meat
;;              },
;;           
;;           3 {
;;              Cheese
;;              Bread
;;              Meat
;;              },
;; 
;;           4 {
;;              Cheese
;;              Meat
;;              Bread
;;              },
;; 
;;           5 {
;;              Meat
;;              Bread
;;              Cheese 
;;              },
;; 
;;           6 {
;;              Meat
;;              Cheese
;;              Bread
;;              },
;;          }

; sandwich [
;           Bread
;           Cheese
;           Meat
;           ]
; --->
; 
; sandwich {
;           Bread [ Meat Cheese ],
;           Meat [ Bread Cheese ],
;           Cheese [ Meat Bread ]
; }
; -->
; 
; sandwich {
;           Bread {
;                   Meat { Cheese },
;                   Cheese { Meat }
;           },
;           Meat  {
;                   Bread { Cheese },
;                   Cheese { Bread }
;           },
;           Cheese {
;                   Meat { Bread },
;                   Bread { Meat }
;           },
; }
;           
