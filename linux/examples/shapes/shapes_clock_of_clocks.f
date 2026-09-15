\ Port of raylib examples/shapes/shapes_clock_of_clocks.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

VARIABLE bgColor
VARIABLE handsColor
24e fconstant faceSize
8e fconstant faceSpace
16e fconstant sectSpace

CREATE digitAng 10 24 * 8 * ALLOT
CREATE curAng 6 24 * 8 * ALLOT
CREATE srcAng 6 24 * 8 * ALLOT
CREATE dstAng 6 24 * 8 * ALLOT
VARIABLE prevSec
0.5e fconstant moveDur
FVARIABLE moveTimer
VARIABLE hourMode
CREATE centre 8 ALLOT
CREATE rec 16 ALLOT
CREATE orig 8 ALLOT
CREATE TL 8 ALLOT  CREATE TR 8 ALLOT  CREATE BR 8 ALLOT  CREATE BL 8 ALLOT
CREATE HH 8 ALLOT  CREATE VV 8 ALLOT  CREATE ZZ 8 ALLOT
VARIABLE hh  VARIABLE mm  VARIABLE ss
VARIABLE kdig  VARIABLE row  VARIABLE col
FVARIABLE xoff
FVARIABLE tlerp

: dang ( d cell -- a ) swap 24 * + 8 * digitAng + ;
: cang ( d cell -- a ) swap 24 * + 8 * curAng + ;
: sang ( d cell -- a ) swap 24 * + 8 * srcAng + ;
: tang ( d cell -- a ) swap 24 * + 8 * dstAng + ;

: cell! ( d cell src -- )
   >r swap 24 * + 8 * digitAng + r> swap 8 move ;

: drow ( d row c0 c1 c2 c3 -- )
   locals| c3 c2 c1 c0 row d |
   d row 4 *     c0 cell!
   d row 4 * 1+  c1 cell!
   d row 4 * 2 + c2 cell!
   d row 4 * 3 + c3 cell! ;

: init-digits
   0e 90e TL Vector2!  90e 180e TR Vector2!  180e 270e BR Vector2!
   0e 270e BL Vector2!  0e 180e HH Vector2!  90e 270e VV Vector2!
   135e 135e ZZ Vector2!
   0 0 TL HH HH TR drow  0 1 VV TL TR VV drow  0 2 VV VV VV VV drow
   0 3 VV VV VV VV drow  0 4 VV BL BR VV drow  0 5 BL HH HH BR drow
   1 0 TL HH TR ZZ drow  1 1 BL TR VV ZZ drow  1 2 ZZ VV VV ZZ drow
   1 3 ZZ VV VV ZZ drow  1 4 TL BR BL TR drow  1 5 BL HH HH BR drow
   2 0 TL HH HH TR drow  2 1 BL HH TR VV drow  2 2 TL HH BR VV drow
   2 3 VV TL HH BR drow  2 4 VV BL HH TR drow  2 5 BL HH HH BR drow
   3 0 TL HH HH TR drow  3 1 BL HH TR VV drow  3 2 TL HH BR VV drow
   3 3 BL HH TR VV drow  3 4 TL HH BR VV drow  3 5 BL HH HH BR drow
   4 0 TL TR TL TR drow  4 1 VV VV VV VV drow  4 2 VV BL BR VV drow
   4 3 BL HH TR VV drow  4 4 ZZ ZZ VV VV drow  4 5 ZZ ZZ BL BR drow
   5 0 TL HH HH TR drow  5 1 VV TL HH BR drow  5 2 VV BL HH TR drow
   5 3 BL HH TR VV drow  5 4 TL HH BR VV drow  5 5 BL HH HH BR drow
   6 0 TL HH HH TR drow  6 1 VV TL HH BR drow  6 2 VV BL HH TR drow
   6 3 VV TL TR VV drow  6 4 VV BL BR VV drow  6 5 BL HH HH BR drow
   7 0 TL HH HH TR drow  7 1 BL HH TR VV drow  7 2 ZZ ZZ VV VV drow
   7 3 ZZ ZZ VV VV drow  7 4 ZZ ZZ VV VV drow  7 5 ZZ ZZ BL BR drow
   8 0 TL HH HH TR drow  8 1 VV TL TR VV drow  8 2 VV BL BR VV drow
   8 3 VV TL TR VV drow  8 4 VV BL BR VV drow  8 5 BL HH HH BR drow
   9 0 TL HH HH TR drow  9 1 VV TL TR VV drow  9 2 VV BL BR VV drow
   9 3 BL HH TR VV drow  9 4 TL HH BR VV drow  9 5 BL HH HH BR drow ;

: digit-of ( i -- n )
   dup 0 = if drop hh @ hourMode @ mod 10 / else
   dup 1 = if drop hh @ hourMode @ mod 10 mod else
   dup 2 = if drop mm @ 10 / else
   dup 3 = if drop mm @ 10 mod else
   dup 4 = if drop ss @ 10 / else
              drop ss @ 10 mod then then then then then ;

: example
   FLAG_MSAA_4X_HINT SetConfigFlags
   screenWidth screenHeight z" raylib [shapes] example - clock of clocks" InitWindow
   DARKBLUE BLACK 0.75e ColorLerp bgColor !
   YELLOW RAYWHITE 0.25e ColorLerp handsColor !
   init-digits
   curAng 6 24 * 8 * erase
   -1 prevSec !
   0e moveTimer f!
   24 hourMode !
   60 SetTargetFPS
   begin
      time&date drop drop drop hh ! mm ! ss !
      ss @ prevSec @ <> if
         ss @ prevSec !
         6 0 do i kdig !
            24 0 do
               kdig @ i cang  kdig @ i sang 8 move
               kdig @ digit-of i dang  kdig @ i tang 8 move
               hourMode @ 12 =  kdig @ 0 = and
               hh @ hourMode @ mod 10 / 0= and if
                  ZZ kdig @ i tang 8 move
               then
               kdig @ i sang v2x  kdig @ i tang v2x f> if
                  kdig @ i sang v2x 360e f- kdig @ i sang sf!
               then
               kdig @ i sang v2y  kdig @ i tang v2y f> if
                  kdig @ i sang v2y 360e f- kdig @ i sang 4 + sf!
               then
            loop
         loop
         GetFrameTime fnegate moveTimer f!
      then
      moveTimer f@ moveDur f< if
         moveTimer f@ GetFrameTime f+ 0e moveDur ClampF moveTimer f!
         moveTimer f@ moveDur f/ fdup fdup f* 3e 2e 2 pick f* f- f* tlerp f!
         6 0 do i kdig !
            24 0 do
               kdig @ i sang v2x kdig @ i tang v2x tlerp f@ Lerp
               kdig @ i sang v2y kdig @ i tang v2y tlerp f@ Lerp
               kdig @ i cang Vector2!
            loop
         loop
      then
      KEY_SPACE IsKeyPressed if 36 hourMode @ - hourMode ! then
      BeginDrawing
         bgColor @ ClearBackground
         hourMode @ zint 10 30 20 RAYWHITE DrawText
         z" -h mode, space to change" 50 30 20 RAYWHITE DrawText
         4e xoff f!
         6 0 do i kdig !
            6 0 do i row !
               4 0 do i col !
                  xoff f@ col @ s>f faceSize faceSpace f+ f* f+ faceSize 0.5e f* f+
                  100e row @ s>f faceSize faceSpace f+ f* f+ faceSize 0.5e f* f+
                  centre Vector2!
                  centre faceSize 0.5e f* 2e f- faceSize 0.5e f* 0e 360e 24 DARKGRAY DrawRing
                  centre v2x centre v2y faceSize 0.5e f* 4e f+ 4e rec Rectangle!
                  2e 2e orig Vector2!
                  rec orig  kdig @ row @ 4 * col @ + cang v2x  handsColor @ DrawRectanglePro
                  centre v2x centre v2y faceSize 0.5e f* 2e f+ 4e rec Rectangle!
                  rec orig  kdig @ row @ 4 * col @ + cang v2y  handsColor @ DrawRectanglePro
               loop
            loop
            xoff f@ faceSize faceSpace f+ 4e f* f+ xoff f!
            kdig @ 2 mod if
               xoff f@ 4e f+ 160e centre Vector2!
               centre 6e 8e 0e 360e 24 handsColor @ DrawRing
               xoff f@ 4e f+ 225e centre Vector2!
               centre 6e 8e 0e 360e 24 handsColor @ DrawRing
               xoff f@ sectSpace f+ xoff f!
            then
         loop
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
