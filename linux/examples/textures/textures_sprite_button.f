\ Port of raylib examples/textures/textures_sprite_button.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
3 CONSTANT NUM_FRAMES

CREATE fxButton 64 ALLOT
CREATE button 32 ALLOT
CREATE sourceRec 16 ALLOT
CREATE btnBounds 16 ALLOT
CREATE pos 16 ALLOT
FVARIABLE frameHeight
VARIABLE btnState
VARIABLE btnAction

: Rec! ( a F: x y w h -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;

: example
   screenWidth screenHeight z" raylib [textures] example - sprite button" InitWindow
   InitAudioDevice
   fxButton z" /home/dave/Code/raylib/examples/textures/resources/buttonfx.wav" LoadSound drop
   button z" /home/dave/Code/raylib/examples/textures/resources/button.png" LoadTexture drop
   button texture_height l@ s>f NUM_FRAMES s>f f/ frameHeight f!
   0e 0e button texture_width l@ s>f frameHeight f@ sourceRec Rec!
   screenWidth s>f 2e f/ button texture_width l@ s>f 2e f/ f-
   screenHeight s>f 2e f/ frameHeight f@ 2e f/ f-
   button texture_width l@ s>f frameHeight f@ btnBounds Rec!
   0 btnState !
   0 btnAction !
   60 SetTargetFPS
   begin
      0 btnAction !
      mouse@ btnBounds CheckCollisionPointRec if
         MOUSE_BUTTON_LEFT IsMouseButtonDown if 2 else 1 then btnState !
         MOUSE_BUTTON_LEFT IsMouseButtonReleased if 1 btnAction ! then
      else
         0 btnState !
      then
      btnAction @ if fxButton PlaySound then
      btnState @ s>f frameHeight f@ f* sourceRec 4 + sf!
      BeginDrawing
         RAYWHITE ClearBackground
         btnBounds sf@ btnBounds 4 + sf@ pos Vector2!
         button sourceRec pos WHITE DrawTextureRec
      EndDrawing
   WindowShouldClose until
   button UnloadTexture
   fxButton UnloadSound
   CloseAudioDevice
   CloseWindow ;

example-end
