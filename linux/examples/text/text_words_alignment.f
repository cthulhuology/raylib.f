\ Port of raylib examples/text/text_words_alignment.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
11 CONSTANT wordCount

CREATE textContainerRect 16 ALLOT
CREATE font 64 ALLOT
CREATE textSize 16 ALLOT
CREATE textPos 16 ALLOT
VARIABLE wordIndex
VARIABLE hAlign
VARIABLE vAlign

: Rec! ( a F: x y w h -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;

: word[] ( i -- z )
   dup 0 = if drop z" raylib" else
   dup 1 = if drop z" is" else
   dup 2 = if drop z" a" else
   dup 3 = if drop z" simple" else
   dup 4 = if drop z" and" else
   dup 5 = if drop z" easy-to-use" else
   dup 6 = if drop z" library" else
   dup 7 = if drop z" to" else
   dup 8 = if drop z" enjoy" else
   dup 9 = if drop z" videogames" else
   drop z" programming"
   then then then then then then then then then then ;

: hname ( i -- z )
   dup 0 = if drop z" Left" else dup 1 = if drop z" Centre" else drop z" Right" then then ;
: vname ( i -- z )
   dup 0 = if drop z" Top" else dup 1 = if drop z" Middle" else drop z" Bottom" then then ;

: example
   screenWidth screenHeight z" raylib [text] example - words alignment" InitWindow
   screenWidth 2/ screenWidth 4 / - s>f
   screenHeight 2/ screenHeight 3 / - s>f
   screenWidth 2/ s>f  screenHeight 2* 3 / s>f
   textContainerRect Rec!
   0 wordIndex !
   font GetFontDefault drop
   1 hAlign !  1 vAlign !
   60 SetTargetFPS
   begin
      KEY_LEFT  IsKeyPressed if hAlign @ 1- dup 0< if drop 0 then hAlign ! then
      KEY_RIGHT IsKeyPressed if hAlign @ 1+ dup 2 > if drop 2 then hAlign ! then
      KEY_UP    IsKeyPressed if vAlign @ 1- dup 0< if drop 0 then vAlign ! then
      KEY_DOWN  IsKeyPressed if vAlign @ 1+ dup 2 > if drop 2 then vAlign ! then
      GetTime f>s wordCount mod wordIndex !
      BeginDrawing
         DARKBLUE ClearBackground
         z" Use Arrow Keys to change the text alignment" 20 20 20 LIGHTGRAY DrawText
         z" Alignment: Horizontal = " 20 40 20 LIGHTGRAY DrawText
         hAlign @ hname 280 40 20 LIGHTGRAY DrawText
         z"  Vertical = " 360 40 20 LIGHTGRAY DrawText
         vAlign @ vname 490 40 20 LIGHTGRAY DrawText
         textContainerRect BLUE DrawRectangleRec
         textSize font wordIndex @ word[] 40e 4e MeasureTextEx drop
         textContainerRect sf@  0e textContainerRect 8 + sf@ textSize sf@ f- hAlign @ s>f 0.5e f* Lerp f+
         textContainerRect 4 + sf@  0e textContainerRect 12 + sf@ textSize 4 + sf@ f- vAlign @ s>f 0.5e f* Lerp f+
         textPos Vector2!
         font wordIndex @ word[] textPos 40e 4e RAYWHITE DrawTextEx
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
