\ Port of raylib examples/textures/textures_sprite_explosion.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
5 CONSTANT NUM_FRAMES_PER_LINE
5 CONSTANT NUM_LINES

CREATE fxBoom 64 ALLOT
CREATE explosion 32 ALLOT
CREATE frameRec 16 ALLOT
CREATE position 16 ALLOT
FVARIABLE frameWidth
FVARIABLE frameHeight
VARIABLE currentFrame
VARIABLE currentLine
VARIABLE active
VARIABLE framesCounter

: Rec! ( a F: x y w h -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;

: example
   screenWidth screenHeight z" raylib [textures] example - sprite explosion" InitWindow
   InitAudioDevice
   fxBoom z" /home/dave/Code/raylib/examples/textures/resources/boom.wav" LoadSound drop
   explosion z" /home/dave/Code/raylib/examples/textures/resources/explosion.png" LoadTexture drop
   explosion texture_width l@ s>f NUM_FRAMES_PER_LINE s>f f/ frameWidth f!
   explosion texture_height l@ s>f NUM_LINES s>f f/ frameHeight f!
   0 currentFrame !
   0 currentLine !
   0e 0e frameWidth f@ frameHeight f@ frameRec Rec!
   0e 0e position Vector2!
   0 active !
   0 framesCounter !
   60 SetTargetFPS
   begin
      MOUSE_BUTTON_LEFT IsMouseButtonPressed active @ 0= and if
         mouse@ position 8 move
         1 active !
         position v2x frameWidth f@ 2e f/ f-  position v2y frameHeight f@ 2e f/ f-  position Vector2!
         fxBoom PlaySound
      then
      active @ if
         1 framesCounter +!
         framesCounter @ 2 > if
            1 currentFrame +!
            currentFrame @ NUM_FRAMES_PER_LINE >= if
               0 currentFrame !
               1 currentLine +!
               currentLine @ NUM_LINES >= if
                  0 currentLine !
                  0 active !
               then
            then
            0 framesCounter !
         then
      then
      frameWidth f@ currentFrame @ s>f f* frameRec sf!
      frameHeight f@ currentLine @ s>f f* frameRec 4 + sf!
      BeginDrawing
         RAYWHITE ClearBackground
         active @ if explosion frameRec position WHITE DrawTextureRec then
      EndDrawing
   WindowShouldClose until
   explosion UnloadTexture
   fxBoom UnloadSound
   CloseAudioDevice
   CloseWindow ;

example-end
