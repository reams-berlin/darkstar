#lang darkstar

setlist {
  1 {
    date { 05 08 77 }
    venue {
      name { Barton Hall }
      city { Ithaca }
      state { NY }
    }
    songs {
      Morning Dew 
      Cassidy {
        Guitar Intro
        Jam
      }
      Scarlet Begonias 
      Fire on the Mountain 
      St. Stephen {
       Guitar Intro
      }
      Not Fade Away {
        Drum Intro
      }
    }
  }
}

-- Compiles to -->

#lang racket
(require racklog)
(define %setlist %empty-rel)
(define %date %empty-rel)
(define %venue %empty-rel)
(define %name %empty-rel)
(define %city %empty-rel)
(define %state %empty-rel)
(define %songs %empty-rel)
(define %song %empty-rel)
(define %segment %empty-rel)

(%assert! %date ()
          [("05 08 77")])

(%assert! %name ()
          [("Barton Hall")])

(%assert! %city ()
          [("Ithaca")])

(%assert! %state ()
          [("NY")])

(%assert! %venue ()
          [(%name "Barton Hall")
            (%city "Ithaca")
            (%state "NY")])

(%assert! %song ()
          [("Morning Dew")])

(%assert! %segment ()
          [("Guitar Intro")])

(%assert! %segment ()
          [("Jam")])

(%assert! %song
          [("Cassidy"
            (%segment "Guitar Intro")
            (%segment "Jam"))])

(%assert! %song ()
          [("Scarlet Begonias")])

(%assert! %song ()
          [("Fire on the Mountain")])

(%assert! %segment ()
          [("Guitar Intro")])

(%assert! %song ()
          [("St. Stephen")])


(%assert! %segment ()
          [("Guitar Intro")])

(%assert! %segment ()
          [("Drum Intro")])

(%assert! %song ()
          [("Not Fade Away"
            (%segment "Drum Intro"))])


(%assert! %setlist ()
          [(
            "1"
            (%date 05 08 77)
            (%venue 
             (%name "Barton Hall")
             (%city "Ithaca")
             (%state "NY"))
            (%songs
             (%song "Morning Dew")
             (%song "Cassidy"
                    (%segment "Guitar Intro")
                    (%segment "Jam"))
             (%song "Scarlet Begonias")
             (%song "Fire on the Mountain")
             (%song "St. Stephen"
                    (%segment "Guitar Intro"))
             (%song "Not Fade Away"
                    (%segment "Drum Intro"))))])

