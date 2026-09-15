\ Port of raylib examples/core/core_basic_window.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

: example
   screenWidth screenHeight z" raylib [core] example - basic window" InitWindow
   60 SetTargetFPS
   begin
      BeginDrawing
         RAYWHITE ClearBackground
         z" Congrats! You created your first window!" 190 200 20 LIGHTGRAY DrawText
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
