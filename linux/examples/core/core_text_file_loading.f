\ Port of raylib examples/core/core_text_file_loading.c
\ LoadTextLines is not in the Forth FFI; lines are split here.

800 CONSTANT screenWidth
450 CONSTANT screenHeight
512 CONSTANT MAX_LINES

CREATE cam 24 ALLOT
VARIABLE text
VARIABLE lineCount
CREATE lines  MAX_LINES CELLS ALLOT
20 CONSTANT fontSize
VARIABLE textTop
VARIABLE wrapWidth
VARIABLE textHeight
CREATE scrollBar 16 ALLOT
CREATE tsize 8 ALLOT
CREATE font 48 ALLOT

: Rectangle! ( a F: x y w h -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;

: line-at ( i -- zaddr ) CELLS lines + @ ;

: split-lines ( ztext -- )
   0 lineCount !
   begin
      dup c@
   while
      lineCount @ MAX_LINES < if
         dup lineCount @ CELLS lines + !
         1 lineCount +!
      then
      begin dup c@ dup if dup 10 <> swap 13 <> and else drop 0 then while 1+ repeat
      dup c@ if 0 over c! 1+ then
      begin dup c@ dup 10 = swap 13 = or while 1+ repeat
   repeat drop ;

VARIABLE lastSpace
VARIABLE lastWrap
: wrap-line ( z -- )
   locals| line |
   0 lastSpace !  0 lastWrap !
   0
   begin
      dup line + c@
   while
      dup line + c@ bl = if
         0 over line + c!
         line lastWrap @ + fontSize MeasureText wrapWidth @ > if
            10 lastSpace @ line + c!
            lastSpace @ 1+ lastWrap !
         then
         bl over line + c!
         dup lastSpace !
      then
      1+
   repeat
   drop ;

: wrap-all
   lineCount @ 0 ?do  i line-at wrap-line  loop ;

: measure-height
   0 textHeight !
   lineCount @ 0 ?do
      tsize font i line-at fontSize s>f 2e MeasureTextEx drop
      textHeight @ tsize v2y f>s 10 + + textHeight !
   loop ;

: example
   cam 24 erase  1e cam 20 + sf!
   25 fontSize + textTop !
   screenWidth 20 - wrapWidth !
   screenWidth screenHeight z" raylib [core] example - text file loading" InitWindow
   font GetFontDefault drop
   z" /home/dave/Code/raylib/examples/core/resources/text_file.txt" LoadFileText text !
   text @ if text @ split-lines wrap-all then
   measure-height
   screenWidth 5 - s>f  0e  5e
   screenHeight s>f 100e f*  textHeight @ screenHeight - s>f f/  fdup f0= if fdrop 10e then
   scrollBar Rectangle!
   60 SetTargetFPS
   begin
      GetMouseWheelMove fontSize s>f 1.5e f* f* fnegate
      cam 8 + 4 + sf@ f+ cam 8 + 4 + sf!   \ cam.target.y
      cam 8 + 4 + sf@ 0e f< if 0e cam 8 + 4 + sf! then
      cam 8 + 4 + sf@  textHeight @ screenHeight - textTop @ + s>f f> if
         textHeight @ screenHeight - textTop @ + s>f cam 8 + 4 + sf!
      then
      textTop @ s>f  screenHeight s>f scrollBar 12 + sf@ f-
      cam 8 + 4 + sf@ textTop @ s>f f-  textHeight @ screenHeight - s>f fdup f0= if fdrop fdrop fdrop textTop @ s>f else f/ Lerp then
      scrollBar 4 + sf!
      BeginDrawing
         RAYWHITE ClearBackground
         cam BeginMode2D
            textTop @
            lineCount @ 0 ?do
               tsize font i line-at fontSize s>f 2e MeasureTextEx drop
               i line-at 10  2 pick  fontSize RED DrawText
               tsize v2y f>s 10 + +
            loop
            drop
         EndMode2D
         0 0 screenWidth textTop @ 10 - BEIGE DrawRectangle
         z" File: /home/dave/Code/raylib/examples/core/resources/text_file.txt" 10 10 fontSize MAROON DrawText
         scrollBar MAROON DrawRectangleRec
      EndDrawing
   WindowShouldClose until
   text @ if text @ UnloadFileText then
   CloseWindow ;

example-end
