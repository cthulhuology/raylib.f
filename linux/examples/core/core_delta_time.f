\ Port of raylib examples/core/core_delta_time.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

VARIABLE currentFps
CREATE deltaCircle 8 ALLOT
CREATE frameCircle 8 ALLOT
10e fconstant speed
32e fconstant circleRadius

CREATE nbuf 64 ALLOT
: n>z ( n -- zaddr )
   dup abs s>d <# #s rot sign #> nbuf swap 2dup + 0 swap c! move nbuf ;

: example
   60 currentFps !
   0e screenHeight s>f 3e f/ deltaCircle Vector2!
   0e screenHeight s>f 2e f* 3e f/ frameCircle Vector2!
   screenWidth screenHeight z" raylib [core] example - delta time" InitWindow
   currentFps @ SetTargetFPS
   begin
      GetMouseWheelMove fdup f0= 0= if
         f>s currentFps +!
         currentFps @ 0 < if 0 currentFps ! then
         currentFps @ SetTargetFPS
      else fdrop then
      deltaCircle v2x GetFrameTime 6e f* speed f* f+  deltaCircle v2y  deltaCircle Vector2!
      frameCircle v2x 0.1e speed f* f+  frameCircle v2y  frameCircle Vector2!
      deltaCircle v2x screenWidth s>f f> if 0e deltaCircle v2y deltaCircle Vector2! then
      frameCircle v2x screenWidth s>f f> if 0e frameCircle v2y frameCircle Vector2! then
      KEY_R IsKeyPressed 1 and if
         0e deltaCircle v2y deltaCircle Vector2!
         0e frameCircle v2y frameCircle Vector2!
      then
      BeginDrawing
         RAYWHITE ClearBackground
         deltaCircle circleRadius RED DrawCircleV
         frameCircle circleRadius BLUE DrawCircleV
         currentFps @ 0 <= if
            z" FPS: unlimited (" 10 10 20 DARKGRAY DrawText
            GetFPS n>z 180 10 20 DARKGRAY DrawText
            z" )" 220 10 20 DARKGRAY DrawText
         else
            z" FPS: " 10 10 20 DARKGRAY DrawText
            GetFPS n>z 60 10 20 DARKGRAY DrawText
            z" (target: " 110 10 20 DARKGRAY DrawText
            currentFps @ n>z 200 10 20 DARKGRAY DrawText
            z" )" 250 10 20 DARKGRAY DrawText
         then
         z" Frame time (s): " 10 30 20 DARKGRAY DrawText
         GetFrameTime 1000e f* f>s n>z 160 30 20 DARKGRAY DrawText
         z" Use the scroll wheel to change the fps limit, r to reset" 10 50 20 DARKGRAY DrawText
         z" FUNC: x += GetFrameTime()*speed" 10 90 20 RED DrawText
         z" FUNC: x += speed" 10 240 20 BLUE DrawText
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
