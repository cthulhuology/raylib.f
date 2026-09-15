\ Port of raylib examples/shapes/shapes_easings_ball.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

VARIABLE ballX
VARIABLE ballR
FVARIABLE ballAlpha
VARIABLE state
VARIABLE frames

: reset-ball
   -100 ballX !  20 ballR !  0e ballAlpha f!  0 state !  0 frames ! ;

: example
   reset-ball
   screenWidth screenHeight z" raylib [shapes] example - easings ball" InitWindow
   60 SetTargetFPS
   begin
      state @ 0 = if
         1 frames +!
         frames @ s>f -100e screenWidth 2/ s>f 100e f+ 120e EaseElasticOut f>s ballX !
         frames @ 120 >= if 0 frames ! 1 state ! then
      else state @ 1 = if
         1 frames +!
         frames @ s>f 20e 500e 200e EaseElasticIn f>s ballR !
         frames @ 200 >= if 0 frames ! 2 state ! then
      else state @ 2 = if
         1 frames +!
         frames @ s>f 0e 1e 200e EaseCubicOut ballAlpha f!
         frames @ 200 >= if 0 frames ! 3 state ! then
      else
         KEY_ENTER IsKeyPressed if reset-ball then
      then then then
      KEY_R IsKeyPressed if 0 frames ! then
      BeginDrawing
         RAYWHITE ClearBackground
         state @ 2 >= if 0 0 screenWidth screenHeight GREEN DrawRectangle then
         ballX @ 200 ballR @ s>f RED 1e ballAlpha f@ f- Fade DrawCircle
         state @ 3 = if
            z" PRESS [ENTER] TO PLAY AGAIN!" 240 200 20 BLACK DrawText
         then
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
