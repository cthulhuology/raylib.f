\ Port of raylib examples/textures/textures_logo_raylib.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE tex 32 ALLOT

: example
   screenWidth screenHeight z" raylib [textures] example - logo raylib" InitWindow
   tex z" /home/dave/Code/raylib/examples/textures/resources/raylib_logo.png" LoadTexture drop
   60 SetTargetFPS
   begin
      BeginDrawing
         RAYWHITE ClearBackground
         tex  screenWidth 2/ tex texture_width l@ 2/ -  screenHeight 2/ tex texture_height l@ 2/ -  WHITE DrawTexture
         z" this IS a texture!" 360 370 10 GRAY DrawText
      EndDrawing
   WindowShouldClose until
   tex UnloadTexture
   CloseWindow ;

example-end
