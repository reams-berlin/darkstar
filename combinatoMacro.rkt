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
; sandwich {
;           Bread
;           Meat
;           Cheese,
;           
;           Bread
;           Cheese
;           Meat,
;           
;           Cheese
;           Bread
;           Meat,
; 
;           Cheese
;           Meat
;           Bread,
; 
;           Meat
;           Bread
;           Cheese,
; 
;           Meat
;           Cheese
;           Bread
;           }


; sandwich [
;           Bread
;           Cheese
;           Meat
;           ]
; --->
; 
; sandwich {
;           Bread [ Meat Cheese ],
;                 Meat [ Bread Cheese ],
;                 Cheese [ Meat Bread ]
; 
;                 }
; -->
; 
; sandwich {
;           Bread {
;                  Meat { Cheese },
;                  Cheese { Meat }
;                  },
;           Meat {
;                 Bread { Cheese },
;                 Cheese { Bread }
;                 },
;           Cheese {
;                   Meat { Bread },
;                   Bread { Meat }
;                   },
;           }
;           
