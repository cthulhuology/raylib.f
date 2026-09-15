\ Port of raylib examples/shapes/shapes_easings_rectangles.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
50 CONSTANT RECS_WIDTH
50 CONSTANT RECS_HEIGHT
16 CONSTANT MAX_RECS_X
9 CONSTANT MAX_RECS_Y
240 CONSTANT PLAY_TIME

CREATE recs MAX_RECS_X MAX_RECS_Y * 16 * ALLOT
CREATE orig 8 ALLOT
FVARIABLE rotation
VARIABLE frames
VARIABLE state

: rec-n ( i -- a ) 16 * recs + ;

: init-recs
   MAX_RECS_Y 0 do
      MAX_RECS_X 0 do
         RECS_WIDTH 2/ s>f RECS_WIDTH i * s>f f+
         RECS_HEIGHT 2/ s>f RECS_HEIGHT j * s>f f+
         RECS_WIDTH s>f RECS_HEIGHT s>f
         j MAX_RECS_X * i + rec-n Rectangle!
      loop
   loop ;

: example
   screenWidth screenHeight z" raylib [shapes] example - easings rectangles" InitWindow
   init-recs
   0e rotation f!  0 frames !  0 state !
   60 SetTargetFPS
   begin
      state @ 0 = if
         1 frames +!
         MAX_RECS_X MAX_RECS_Y * 0 do
            i rec-n rec.x i rec-n rec.y
            frames @ s>f RECS_WIDTH s>f RECS_WIDTH negate s>f PLAY_TIME s>f EaseCircOut
            frames @ s>f RECS_HEIGHT s>f RECS_HEIGHT negate s>f PLAY_TIME s>f EaseCircOut
            fdup f0< if fdrop 0e then fswap
            fdup f0< if fdrop 0e then fswap
            i rec-n Rectangle!
            i rec-n rec.h f0= i rec-n rec.w f0= and if 1 state ! then
            frames @ s>f 0e 360e PLAY_TIME s>f EaseLinearIn rotation f!
         loop
      else
         state @ 1 = KEY_SPACE IsKeyPressed and if
            0 frames !
            MAX_RECS_X MAX_RECS_Y * 0 do
               i rec-n rec.x i rec-n rec.y RECS_WIDTH s>f RECS_HEIGHT s>f
               i rec-n Rectangle!
            loop
            0 state !
         then
      then
      BeginDrawing
         RAYWHITE ClearBackground
         state @ 0 = if
            MAX_RECS_X MAX_RECS_Y * 0 do
               i rec-n rec.w 2e f/ i rec-n rec.h 2e f/ orig Vector2!
               i rec-n orig rotation f@ RED DrawRectanglePro
            loop
         else
            z" PRESS [SPACE] TO PLAY AGAIN!" 240 200 20 GRAY DrawText
         then
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
