\ Port of raylib examples/core/core_custom_frame_control.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

0e fvalue previousTime
0e fvalue currentTime
0e fvalue updateDrawTime
0e fvalue waitTime
0e fvalue deltaTime
0e fvalue timeCounter
0e fvalue position
VARIABLE pause
VARIABLE targetFPS

CREATE nbuf 64 ALLOT
: n>z ( n -- zaddr )
   dup abs s>d <# #s rot sign #> nbuf swap 2dup + 0 swap c! move nbuf ;

: example
   screenWidth screenHeight z" raylib [core] example - custom frame control" InitWindow
   GetTime to previousTime
   0e to currentTime  0e to updateDrawTime  0e to waitTime
   0e to deltaTime  0e to timeCounter  0e to position
   0 pause !
   60 targetFPS !
   begin
      PollInputEvents
      KEY_SPACE IsKeyPressed 1 and if pause @ 0= pause ! then
      KEY_UP   IsKeyPressed 1 and if  20 targetFPS +! then
      KEY_DOWN IsKeyPressed 1 and if -20 targetFPS +! then
      targetFPS @ 0 < if 0 targetFPS ! then
      pause @ 0= if
         position 200e deltaTime f* f+ to position
         position GetScreenWidth s>f f>= if 0e to position then
         timeCounter deltaTime f+ to timeCounter
      then
      BeginDrawing
         RAYWHITE ClearBackground
         GetScreenWidth 200 / 0 ?do
            200 i *  0  1  GetScreenHeight  SKYBLUE DrawRectangle
         loop
         position f>s  GetScreenHeight 2/ 25 -  50e RED DrawCircle
         timeCounter 1000e f* f>s n>z  position f>s 40 -  GetScreenHeight 2/ 100 -  20 MAROON DrawText
         z" PosX: " position f>s 50 -  GetScreenHeight 2/ 40 +  20 BLACK DrawText
         position f>s n>z  position f>s  10 +  GetScreenHeight 2/ 40 +  20 BLACK DrawText
         z" Circle is moving at a constant 200 pixels/sec," 10 10 20 DARKGRAY DrawText
         z" independently of the frame rate." 10 30 20 DARKGRAY DrawText
         z" PRESS SPACE to PAUSE MOVEMENT" 10 GetScreenHeight 60 - 20 GRAY DrawText
         z" PRESS UP | DOWN to CHANGE TARGET FPS" 10 GetScreenHeight 30 - 20 GRAY DrawText
         z" TARGET FPS: " GetScreenWidth 220 - 10 20 LIME DrawText
         targetFPS @ n>z GetScreenWidth 90 - 10 20 LIME DrawText
         deltaTime f0= 0= if
            z" CURRENT FPS: " GetScreenWidth 220 - 40 20 GREEN DrawText
            1e deltaTime f/ f>s n>z GetScreenWidth 90 - 40 20 GREEN DrawText
         then
      EndDrawing
      SwapScreenBuffer
      GetTime to currentTime
      currentTime previousTime f- to updateDrawTime
      targetFPS @ 0 > if
         1e targetFPS @ s>f f/ updateDrawTime f- to waitTime
         waitTime 0e f> if
            waitTime WaitTime
            GetTime to currentTime
            currentTime previousTime f- to deltaTime
         else
            updateDrawTime to deltaTime
         then
      else
         updateDrawTime to deltaTime
      then
      currentTime to previousTime
   WindowShouldClose until
   CloseWindow ;

example-end
