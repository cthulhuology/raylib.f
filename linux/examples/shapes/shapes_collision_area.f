\ Port of raylib examples/shapes/shapes_collision_area.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE boxA 16 ALLOT
CREATE boxB 16 ALLOT
CREATE boxC 16 ALLOT
VARIABLE boxASpeed
40 CONSTANT screenUpperLimit
VARIABLE pause
VARIABLE collision

: example
   screenWidth screenHeight z" raylib [shapes] example - collision area" InitWindow
   10e GetScreenHeight 2/ s>f 50e f- 200e 100e boxA Rectangle!
   4 boxASpeed !
   GetScreenWidth 2/ s>f 30e f- GetScreenHeight 2/ s>f 30e f- 60e 60e boxB Rectangle!
   false pause !  false collision !
   60 SetTargetFPS
   begin
      pause @ 0= if
         boxA rec.x boxASpeed @ s>f f+ boxA rec.y boxA rec.w boxA rec.h boxA Rectangle!
      then
      boxA rec.x boxA rec.w f+ GetScreenWidth s>f f>=
      boxA rec.x f0<= or if boxASpeed @ negate boxASpeed ! then
      GetMouseX s>f boxB rec.w 2e f/ f-  GetMouseY s>f boxB rec.h 2e f/ f-
      boxB rec.w boxB rec.h boxB Rectangle!
      boxB rec.x boxB rec.w f+ GetScreenWidth s>f f>= if
         GetScreenWidth s>f boxB rec.w f- boxB rec.y boxB rec.w boxB rec.h boxB Rectangle! then
      boxB rec.x f0<= if
         0e boxB rec.y boxB rec.w boxB rec.h boxB Rectangle! then
      boxB rec.y boxB rec.h f+ GetScreenHeight s>f f>= if
         boxB rec.x GetScreenHeight s>f boxB rec.h f- boxB rec.w boxB rec.h boxB Rectangle! then
      boxB rec.y screenUpperLimit s>f f< if
         boxB rec.x screenUpperLimit s>f boxB rec.w boxB rec.h boxB Rectangle! then
      boxA boxB CheckCollisionRecs collision !
      collision @ if boxC boxA boxB GetCollisionRec drop then
      KEY_SPACE IsKeyPressed if pause @ 0= pause ! then
      BeginDrawing
         RAYWHITE ClearBackground
         0 0 screenWidth screenUpperLimit collision @ if RED else BLACK then DrawRectangle
         boxA GOLD DrawRectangleRec
         boxB BLUE DrawRectangleRec
         collision @ if
            boxC LIME DrawRectangleRec
            z" COLLISION!" dup 20 MeasureText GetScreenWidth swap - 2/
            screenUpperLimit 2/ 10 - 20 BLACK DrawText
            z" Collision Area: " GetScreenWidth 2/ 160 - screenUpperLimit 10 + 20 BLACK DrawText
            boxC rec.w f>s boxC rec.h f>s * zint
            GetScreenWidth 2/ 20 + screenUpperLimit 10 + 20 BLACK DrawText
         then
         z" Press SPACE to PAUSE/RESUME" 20 screenHeight 35 - 20 LIGHTGRAY DrawText
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
