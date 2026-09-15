\ Port of raylib examples/textures/textures_to_image.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE img 32 ALLOT
CREATE tex 32 ALLOT

: example
   screenWidth screenHeight z" raylib [textures] example - to image" InitWindow
   img z" /home/dave/Code/raylib/examples/textures/resources/raylib_logo.png" LoadImage drop
   tex img LoadTextureFromImage drop
   img UnloadImage
   img tex LoadImageFromTexture drop
   tex UnloadTexture
   tex img LoadTextureFromImage drop
   img UnloadImage
   60 SetTargetFPS
   begin
      BeginDrawing
         RAYWHITE ClearBackground
         tex  screenWidth 2/ tex texture_width l@ 2/ -  screenHeight 2/ tex texture_height l@ 2/ -  WHITE DrawTexture
         z" this IS a texture loaded from an image!" 300 370 10 GRAY DrawText
      EndDrawing
   WindowShouldClose until
   tex UnloadTexture
   CloseWindow ;

example-end
