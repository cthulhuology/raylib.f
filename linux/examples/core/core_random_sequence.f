\ Port of raylib examples/core/core_random_sequence.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

24 CONSTANT /crect
CREATE rectangles  64 /crect * ALLOT
VARIABLE rectCount
0e fvalue rectSize
0e fvalue startX

CREATE nbuf 64 ALLOT
: n>z ( n -- zaddr )
   dup abs s>d <# #s rot sign #> nbuf swap 2dup + 0 swap c! move nbuf ;

: Rectangle! ( a F: x y w h -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;

: crect ( i -- addr ) /crect * rectangles + ;
: cr-col ( i -- n ) crect @ ;
: cr-col! ( n i -- ) crect ! ;
: cr-rec ( i -- addr ) crect CELL+ ;

: GenerateRandomColor ( -- u )
   0 255 GetRandomValue  0 255 GetRandomValue  0 255 GetRandomValue  255 RGBA ;

: GenerateRandomColorRectSequence
   screenWidth s>f rectCount @ s>f f/ to rectSize
   rectCount @  0  rectCount @ 1-  LoadRandomSequence
   rectCount @ s>f rectSize f*  screenWidth s>f fswap f- 2e f/ to startX
   rectCount @ 0 ?do
      dup i CELLS + l@  \ seq[i]
      s>f  0e f-  rectCount @ 1- s>f  fdup f0= if fdrop fdrop 0e else f/ screenHeight s>f 0.75e f* f* then
      f>s  \ rectHeight
      GenerateRandomColor i cr-col!
      startX i s>f rectSize f* f+
      screenHeight over - s>f
      rectSize
      over s>f
      i cr-rec Rectangle!
      drop
   loop
   UnloadRandomSequence ;

: ShuffleColorRectSequence
   rectCount @  0  rectCount @ 1-  LoadRandomSequence
   rectCount @ 0 ?do
      dup i CELLS + l@          \ seq i1
      i cr-col                  \ seq i2 color1
      i cr-rec 4 + sf@          \ seq i2 color1 y1
      i cr-rec 12 + sf@         \ seq i2 color1 y1 h1
      3 pick cr-col i cr-col!   \ copy color2 to i1
      3 pick cr-rec 12 + sf@ i cr-rec 12 + sf!
      3 pick cr-rec 4 + sf@ i cr-rec 4 + sf!
      \ write tmp to i2: color y h still on fp/data
      3 pick cr-rec 12 + sf!    \ h1 to i2.h  F: y1  data: seq i2 color1
      3 pick cr-rec 4 + sf!     \ y1
      swap cr-col!              \ color1 to i2, drop i2
   loop
   UnloadRandomSequence ;

: example
   20 rectCount !
   screenWidth screenHeight z" raylib [core] example - random sequence" InitWindow
   GenerateRandomColorRectSequence
   60 SetTargetFPS
   begin
      KEY_SPACE IsKeyPressed 1 and if ShuffleColorRectSequence then
      KEY_UP IsKeyPressed 1 and if
         rectCount @ 1+ 64 min rectCount !
         GenerateRandomColorRectSequence
      then
      KEY_DOWN IsKeyPressed 1 and if
         rectCount @ 4 >= if
            -1 rectCount +!
            GenerateRandomColorRectSequence
         then
      then
      BeginDrawing
         RAYWHITE ClearBackground
         rectCount @ 0 ?do
            i cr-rec  i cr-col  DrawRectangleRec
         loop
         z" Press SPACE to shuffle the current sequence" 10 screenHeight 96 - 20 BLACK DrawText
         z" Press UP to add a rectangle and generate a new sequence" 10 screenHeight 64 - 20 BLACK DrawText
         z" Press DOWN to remove a rectangle and generate a new sequence" 10 screenHeight 32 - 20 BLACK DrawText
         z" Count: " 10 10 20 MAROON DrawText
         rectCount @ n>z 80 10 20 MAROON DrawText
         z" rectangles" 130 10 20 MAROON DrawText
         screenWidth 80 - 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
