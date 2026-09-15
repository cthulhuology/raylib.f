\ Port of raylib examples/shapes/shapes_mouse_trail.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
30 CONSTANT MAX_TRAIL

CREATE trail MAX_TRAIL 8 * ALLOT
FVARIABLE ratio

: trail-i ( i -- a ) 8 * trail + ;

: example
   screenWidth screenHeight z" raylib [shapes] example - mouse trail" InitWindow
   trail MAX_TRAIL 8 * erase
   60 SetTargetFPS
   begin
      MAX_TRAIL 1- 0 do
         MAX_TRAIL 2 - i - trail-i  MAX_TRAIL 1- i - trail-i  8 move
      loop
      mouse@ 0 trail-i 8 move
      BeginDrawing
         BLACK ClearBackground
         MAX_TRAIL 0 do
            i trail-i v2x f0= i trail-i v2y f0= and 0= if
               MAX_TRAIL i - s>f MAX_TRAIL s>f f/ ratio f!
               i trail-i  15e ratio f@ f*
               SKYBLUE ratio f@ 0.5e f* 0.5e f+ Fade DrawCircleV
            then
         loop
         mouse@ 15e WHITE DrawCircleV
         z" Move the mouse to see the trail effect!" 10 screenHeight 30 - 20 LIGHTGRAY DrawText
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
