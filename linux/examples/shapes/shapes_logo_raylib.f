\ Port of raylib examples/shapes/shapes_logo_raylib.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

: example
   screenWidth screenHeight z" raylib [shapes] example - logo raylib" InitWindow
   60 SetTargetFPS
   begin
      BeginDrawing
         RAYWHITE ClearBackground
         screenWidth 2/ 128 - screenHeight 2/ 128 - 256 256 BLACK DrawRectangle
         screenWidth 2/ 112 - screenHeight 2/ 112 - 224 224 RAYWHITE DrawRectangle
         z" raylib" screenWidth 2/ 44 - screenHeight 2/ 48 + 50 BLACK DrawText
         z" this is NOT a texture!" 350 370 10 GRAY DrawText
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
