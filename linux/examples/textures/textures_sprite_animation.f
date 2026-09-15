\ Port of raylib examples/textures/textures_sprite_animation.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
15 CONSTANT MAX_FRAME_SPEED
1 CONSTANT MIN_FRAME_SPEED

CREATE scarfy 32 ALLOT
CREATE position 16 ALLOT
CREATE frameRec 16 ALLOT
VARIABLE currentFrame
VARIABLE framesCounter
VARIABLE framesSpeed

: Rec! ( a F: x y w h -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;

: n>z02 ( n -- z ) 0 <# # # #> zres ;

: example
   screenWidth screenHeight z" raylib [textures] example - sprite animation" InitWindow
   scarfy z" /home/dave/Code/raylib/examples/textures/resources/scarfy.png" LoadTexture drop
   350e 280e position Vector2!
   0e 0e scarfy texture_width l@ s>f 6e f/ scarfy texture_height l@ s>f frameRec Rec!
   0 currentFrame !
   0 framesCounter !
   8 framesSpeed !
   60 SetTargetFPS
   begin
      1 framesCounter +!
      framesCounter @ 60 framesSpeed @ / >= if
         0 framesCounter !
         1 currentFrame +!
         currentFrame @ 5 > if 0 currentFrame ! then
         currentFrame @ s>f scarfy texture_width l@ s>f 6e f/ f* frameRec sf!
      then
      KEY_RIGHT IsKeyPressed if 1 framesSpeed +! then
      KEY_LEFT  IsKeyPressed if -1 framesSpeed +! then
      framesSpeed @ MAX_FRAME_SPEED > if MAX_FRAME_SPEED framesSpeed ! then
      framesSpeed @ MIN_FRAME_SPEED < if MIN_FRAME_SPEED framesSpeed ! then
      BeginDrawing
         RAYWHITE ClearBackground
         scarfy 15 40 WHITE DrawTexture
         15 40 scarfy texture_width l@ scarfy texture_height l@ LIME DrawRectangleLines
         15 frameRec sf@ f>s +  40 frameRec 4 + sf@ f>s +
            frameRec 8 + sf@ f>s  frameRec 12 + sf@ f>s  RED DrawRectangleLines
         z" FRAME SPEED: " 165 210 10 DARKGRAY DrawText
         framesSpeed @ n>z02 575 210 10 DARKGRAY DrawText
         z" PRESS RIGHT/LEFT KEYS to CHANGE SPEED!" 290 240 10 DARKGRAY DrawText
         MAX_FRAME_SPEED 0 do
            i framesSpeed @ < if 250 21 i * + 205 20 20 RED DrawRectangle then
            250 21 i * + 205 20 20 MAROON DrawRectangleLines
         loop
         scarfy frameRec position WHITE DrawTextureRec
         z" (c) Scarfy sprite by Eiden Marsal" screenWidth 200 - screenHeight 20 - 10 GRAY DrawText
      EndDrawing
   WindowShouldClose until
   scarfy UnloadTexture
   CloseWindow ;

example-end
