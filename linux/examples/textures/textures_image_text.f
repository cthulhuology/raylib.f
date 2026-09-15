\ Port of raylib examples/textures/textures_image_text.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE parrots 32 ALLOT
CREATE font 64 ALLOT
CREATE tex 32 ALLOT
CREATE position 16 ALLOT
CREATE tpos 16 ALLOT
VARIABLE showFont

: example
   screenWidth screenHeight z" raylib [textures] example - image text" InitWindow
   parrots z" /home/dave/Code/raylib/examples/textures/resources/parrots.png" LoadImage drop
   font z" /home/dave/Code/raylib/examples/textures/resources/KAISG.ttf" 64 0 0 LoadFontEx drop
   20e 20e tpos Vector2!
   parrots font z" [Parrots font drawing]" tpos font font_baseSize l@ s>f 0e RED ImageDrawTextEx
   tex parrots LoadTextureFromImage drop
   parrots UnloadImage
   screenWidth 2/ tex texture_width l@ 2/ - s>f
   screenHeight 2/ tex texture_height l@ 2/ - 20 - s>f
   position Vector2!
   0 showFont !
   60 SetTargetFPS
   begin
      KEY_SPACE down if 1 else 0 then showFont !
      BeginDrawing
         RAYWHITE ClearBackground
         showFont @ 0= if
            tex position WHITE DrawTextureV
            position v2x 20e f+  position v2y 20e f+ 280e f+ tpos Vector2!
            font z" [Parrots font drawing]" tpos font font_baseSize l@ s>f 0e WHITE DrawTextEx
         else
            font font_texture  screenWidth 2/ font font_texture texture_width l@ 2/ -  50  BLACK DrawTexture
         then
         z" PRESS SPACE to SHOW FONT ATLAS USED" 290 420 10 DARKGRAY DrawText
      EndDrawing
   WindowShouldClose until
   tex UnloadTexture
   font UnloadFont
   CloseWindow ;

example-end
