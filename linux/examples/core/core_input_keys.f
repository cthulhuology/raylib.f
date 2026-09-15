\ Port of raylib examples/core/core_input_keys.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE ball  8 ALLOT

: example
   screenWidth 2/ s>f  screenHeight 2/ s>f  ball Vector2!
   screenWidth screenHeight z" raylib [core] example - input keys" InitWindow
   60 SetTargetFPS
   begin
      KEY_RIGHT down if  ball v2x 2e f+  ball v2y  ball Vector2! then
      KEY_LEFT  down if  ball v2x 2e f-  ball v2y  ball Vector2! then
      KEY_UP    down if  ball v2x  ball v2y 2e f-  ball Vector2! then
      KEY_DOWN  down if  ball v2x  ball v2y 2e f+  ball Vector2! then
      BeginDrawing
         RAYWHITE ClearBackground
         z" move the ball with arrow keys" 10 10 20 DARKGRAY DrawText
         ball 50e MAROON DrawCircleV
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
