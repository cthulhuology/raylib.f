\ Port of raylib examples/shapes/shapes_bouncing_ball.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE ball 8 ALLOT
CREATE speed 8 ALLOT
20 CONSTANT ballRadius
VARIABLE useGravity
VARIABLE pause
VARIABLE frames

: example
   FLAG_MSAA_4X_HINT SetConfigFlags
   screenWidth screenHeight z" raylib [shapes] example - bouncing ball" InitWindow
   GetScreenWidth 2/ s>f GetScreenHeight 2/ s>f ball Vector2!
   5e 4e speed Vector2!
   true useGravity !
   false pause !
   0 frames !
   60 SetTargetFPS
   begin
      KEY_G IsKeyPressed if useGravity @ 0= useGravity ! then
      KEY_SPACE IsKeyPressed if pause @ 0= pause ! then
      pause @ 0= if
         ball v2x speed v2x f+  ball v2y speed v2y f+  ball Vector2!
         useGravity @ if speed v2x  speed v2y 0.2e f+  speed Vector2! then
         ball v2x GetScreenWidth ballRadius - s>f f>=
         ball v2x ballRadius s>f f<= or if
            speed v2x fnegate speed v2y speed Vector2! then
         ball v2y GetScreenHeight ballRadius - s>f f>=
         ball v2y ballRadius s>f f<= or if
            speed v2x speed v2y -0.95e f* speed Vector2! then
      else
         1 frames +!
      then
      BeginDrawing
         RAYWHITE ClearBackground
         ball ballRadius s>f MAROON DrawCircleV
         z" PRESS SPACE to PAUSE BALL MOVEMENT" 10 GetScreenHeight 25 - 20 LIGHTGRAY DrawText
         useGravity @ if
            z" GRAVITY: ON (Press G to disable)" 10 GetScreenHeight 50 - 20 DARKGREEN DrawText
         else
            z" GRAVITY: OFF (Press G to enable)" 10 GetScreenHeight 50 - 20 RED DrawText
         then
         pause @ frames @ 30 / 2 mod and if
            z" PAUSED" 350 200 30 GRAY DrawText
         then
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
