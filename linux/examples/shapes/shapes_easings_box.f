\ Port of raylib examples/shapes/shapes_easings_box.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE rec 16 ALLOT
CREATE orig 8 ALLOT
FVARIABLE rotation
FVARIABLE alpha
VARIABLE state
VARIABLE frames

: reset-box
   GetScreenWidth 2/ s>f -100e 100e 100e rec Rectangle!
   0e rotation f!  1e alpha f!  0 state !  0 frames ! ;

: example
   screenWidth screenHeight z" raylib [shapes] example - easings box" InitWindow
   reset-box
   60 SetTargetFPS
   begin
      state @ 0 = if
         1 frames +!
         rec rec.x
         frames @ s>f -100e GetScreenHeight 2/ s>f 100e f+ 120e EaseElasticOut
         rec rec.w rec rec.h rec Rectangle!
         frames @ 120 >= if 0 frames ! 1 state ! then
      else state @ 1 = if
         1 frames +!
         rec rec.x rec rec.y
         frames @ s>f 100e GetScreenWidth s>f 120e EaseBounceOut
         frames @ s>f 100e -90e 120e EaseBounceOut
         rec Rectangle!
         frames @ 120 >= if 0 frames ! 2 state ! then
      else state @ 2 = if
         1 frames +!
         frames @ s>f 0e 270e 240e EaseQuadOut rotation f!
         frames @ 240 >= if 0 frames ! 3 state ! then
      else state @ 3 = if
         1 frames +!
         rec rec.x rec rec.y rec rec.w
         frames @ s>f 10e GetScreenWidth s>f 120e EaseCircOut
         rec Rectangle!
         frames @ 120 >= if 0 frames ! 4 state ! then
      else state @ 4 = if
         1 frames +!
         frames @ s>f 1e -1e 160e EaseSineOut alpha f!
         frames @ 160 >= if 0 frames ! 5 state ! then
      then then then then then
      KEY_SPACE IsKeyPressed if reset-box then
      rec rec.w 2e f/ rec rec.h 2e f/ orig Vector2!
      BeginDrawing
         RAYWHITE ClearBackground
         rec orig rotation f@ BLACK alpha f@ Fade DrawRectanglePro
         z" PRESS [SPACE] TO RESET BOX ANIMATION!" 10 GetScreenHeight 25 - 20 LIGHTGRAY DrawText
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
