\ Port of raylib examples/core/core_highdpi_testbed.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE p0 8 ALLOT
CREATE p1 8 ALLOT

: example
   screenWidth screenHeight z" raylib [core] example - highdpi testbed" InitWindow
   60 SetTargetFPS
   begin
      BeginDrawing
         RAYWHITE ClearBackground
         0e 0e p0 Vector2!
         screenWidth s>f screenHeight s>f p1 Vector2!
         p0 p1 2e RED DrawLineEx
         0e screenHeight s>f p0 Vector2!
         screenWidth s>f 0e p1 Vector2!
         p0 p1 2e RED DrawLineEx
         z" example base code template" 260 400 20 LIGHTGRAY DrawText
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
