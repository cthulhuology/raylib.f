\ Port of raylib examples/text/text_writing_anim.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE message 128 ALLOT
VARIABLE framesCounter

: example
   screenWidth screenHeight z" raylib [text] example - writing anim" InitWindow
   z" This sample illustrates a text writing" dup TextLength message swap move
   message TextLength message +
   10 over c! 1+
   z" animation effect! Check it out! ;)" swap over TextLength 1+ move
   0 framesCounter !
   60 SetTargetFPS
   begin
      KEY_SPACE down if 8 else 1 then framesCounter +!
      KEY_ENTER IsKeyPressed if 0 framesCounter ! then
      BeginDrawing
         RAYWHITE ClearBackground
         message 0 framesCounter @ 10 / TextSubtext 210 160 20 MAROON DrawText
         z" PRESS [ENTER] to RESTART!" 240 260 20 LIGHTGRAY DrawText
         z" HOLD [SPACE] to SPEED UP!" 239 300 20 LIGHTGRAY DrawText
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
