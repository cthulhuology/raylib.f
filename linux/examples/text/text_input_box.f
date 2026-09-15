\ Port of raylib examples/text/text_input_box.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
9 CONSTANT MAX_INPUT_CHARS

CREATE name MAX_INPUT_CHARS 2 + ALLOT
CREATE textBox 16 ALLOT
VARIABLE letterCount
VARIABLE mouseOnText
VARIABLE framesCounter

: Rec! ( a F: x y w h -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;

: n>z ( n -- z ) 0 <# #s #> zres ;

: example
   screenWidth screenHeight z" raylib [text] example - input box" InitWindow
   name MAX_INPUT_CHARS 2 + erase
   0 letterCount !
   screenWidth s>f 2e f/ 100e f- 180e 225e 50e textBox Rec!
   0 mouseOnText !
   0 framesCounter !
   60 SetTargetFPS
   begin
      mouse@ textBox CheckCollisionPointRec if 1 else 0 then mouseOnText !
      mouseOnText @ if
         MOUSE_CURSOR_IBEAM SetMouseCursor
         begin GetCharPressed dup while
            dup 32 >= over 125 <= and letterCount @ MAX_INPUT_CHARS < and if
               name letterCount @ + c!
               0 name letterCount @ 1+ + c!
               1 letterCount +!
            else drop then
         repeat drop
         KEY_BACKSPACE IsKeyPressed if
            -1 letterCount +!
            letterCount @ 0< if 0 letterCount ! then
            0 name letterCount @ + c!
         then
      else
         MOUSE_CURSOR_DEFAULT SetMouseCursor
      then
      mouseOnText @ if 1 framesCounter +! else 0 framesCounter ! then
      BeginDrawing
         RAYWHITE ClearBackground
         z" PLACE MOUSE OVER INPUT BOX!" 240 140 20 GRAY DrawText
         textBox LIGHTGRAY DrawRectangleRec
         textBox sf@ f>s textBox 4 + sf@ f>s textBox 8 + sf@ f>s textBox 12 + sf@ f>s
         mouseOnText @ if RED else DARKGRAY then DrawRectangleLines
         name textBox sf@ f>s 5 + textBox 4 + sf@ f>s 8 + 40 MAROON DrawText
         z" INPUT CHARS: " 315 250 20 DARKGRAY DrawText
         letterCount @ n>z 470 250 20 DARKGRAY DrawText
         z" /" 490 250 20 DARKGRAY DrawText
         MAX_INPUT_CHARS n>z 505 250 20 DARKGRAY DrawText
         mouseOnText @ if
            letterCount @ MAX_INPUT_CHARS < if
               framesCounter @ 20 / 2 mod 0= if
                  z" _"  textBox sf@ f>s 8 + name 40 MeasureText +  textBox 4 + sf@ f>s 12 +  40 MAROON DrawText
               then
            else
               z" Press BACKSPACE to delete chars..." 230 300 20 GRAY DrawText
            then
         then
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
