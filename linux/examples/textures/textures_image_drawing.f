\ Port of raylib examples/textures/textures_image_drawing.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE cat 32 ALLOT
CREATE parrots 32 ALLOT
CREATE font 64 ALLOT
CREATE tex 32 ALLOT
CREATE src 16 ALLOT
CREATE dst 16 ALLOT
CREATE tpos 16 ALLOT

: Rec! ( a F: x y w h -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;

: example
   screenWidth screenHeight z" raylib [textures] example - image drawing" InitWindow
   cat z" /home/dave/Code/raylib/examples/textures/resources/cat.png" LoadImage drop
   100e 10e 280e 380e src Rec!  cat src ImageCrop
   cat ImageFlipHorizontal
   cat 150 200 ImageResize
   parrots z" /home/dave/Code/raylib/examples/textures/resources/parrots.png" LoadImage drop
   0e 0e cat image_width l@ s>f cat image_height l@ s>f src Rec!
   30e 40e cat image_width l@ s>f 1.5e f* cat image_height l@ s>f 1.5e f* dst Rec!
   parrots cat src dst WHITE ImageDraw
   0e 50e parrots image_width l@ s>f parrots image_height l@ s>f 100e f- src Rec!
   parrots src ImageCrop
   parrots 10 10 RAYWHITE ImageDrawPixel
   parrots 10 10 5 RAYWHITE ImageDrawCircleLines
   parrots 5 20 10 10 RAYWHITE ImageDrawRectangle
   cat UnloadImage
   font z" /home/dave/Code/raylib/examples/textures/resources/custom_jupiter_crash.png" LoadFont drop
   300e 230e tpos Vector2!
   parrots font z" PARROTS & CAT" tpos font font_baseSize l@ s>f -2e WHITE ImageDrawTextEx
   font UnloadFont
   tex parrots LoadTextureFromImage drop
   parrots UnloadImage
   60 SetTargetFPS
   begin
      BeginDrawing
         RAYWHITE ClearBackground
         screenWidth 2/ tex texture_width l@ 2/ -
         screenHeight 2/ tex texture_height l@ 2/ - 40 -
         2dup tex -rot WHITE DrawTexture
         tex texture_width l@ tex texture_height l@ DARKGRAY DrawRectangleLines
         z" We are drawing only one texture from various images composed!" 240 350 10 DARKGRAY DrawText
         z" Source images have been cropped, scaled, flipped and copied one over the other." 190 370 10 DARKGRAY DrawText
      EndDrawing
   WindowShouldClose until
   tex UnloadTexture
   CloseWindow ;

example-end
