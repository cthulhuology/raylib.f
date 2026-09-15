\ Port of raylib examples/textures/textures_blend_modes.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE bgImage 32 ALLOT
CREATE fgImage 32 ALLOT
CREATE bgTexture 32 ALLOT
CREATE fgTexture 32 ALLOT

4 CONSTANT blendCountMax
VARIABLE blendMode

: example
   screenWidth screenHeight z" raylib [textures] example - blend modes" InitWindow
   bgImage z" /home/dave/Code/raylib/examples/textures/resources/cyberpunk_street_background.png" LoadImage drop
   bgTexture bgImage LoadTextureFromImage drop
   fgImage z" /home/dave/Code/raylib/examples/textures/resources/cyberpunk_street_foreground.png" LoadImage drop
   fgTexture fgImage LoadTextureFromImage drop
   bgImage UnloadImage
   fgImage UnloadImage
   0 blendMode !
   60 SetTargetFPS
   begin
      KEY_SPACE IsKeyPressed if
         blendMode @ blendCountMax 1- >= if 0 else blendMode @ 1+ then blendMode !
      then
      BeginDrawing
         RAYWHITE ClearBackground
         bgTexture screenWidth 2/ bgTexture texture_width l@ 2/ - screenHeight 2/ bgTexture texture_height l@ 2/ - WHITE DrawTexture
         blendMode @ BeginBlendMode
            fgTexture screenWidth 2/ fgTexture texture_width l@ 2/ - screenHeight 2/ fgTexture texture_height l@ 2/ - WHITE DrawTexture
         EndBlendMode
         z" Press SPACE to change blend modes." 310 350 10 GRAY DrawText
         blendMode @ BLEND_ALPHA = if
            z" Current: BLEND_ALPHA" screenWidth 2/ 60 - 370 10 GRAY DrawText
         else blendMode @ BLEND_ADDITIVE = if
            z" Current: BLEND_ADDITIVE" screenWidth 2/ 60 - 370 10 GRAY DrawText
         else blendMode @ BLEND_MULTIPLIED = if
            z" Current: BLEND_MULTIPLIED" screenWidth 2/ 60 - 370 10 GRAY DrawText
         else blendMode @ BLEND_ADD_COLORS = if
            z" Current: BLEND_ADD_COLORS" screenWidth 2/ 60 - 370 10 GRAY DrawText
         then then then then
         z" (c) Cyberpunk Street Environment by Luis Zuno (@ansimuz)" screenWidth 330 - screenHeight 20 - 10 GRAY DrawText
      EndDrawing
   WindowShouldClose until
   fgTexture UnloadTexture
   bgTexture UnloadTexture
   CloseWindow ;

example-end
