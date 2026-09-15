\ Port of raylib examples/shapes/shapes_rounded_rectangle_drawing.c
\ raygui widgets replaced with mouse sliders/checkboxes

800 CONSTANT screenWidth
450 CONSTANT screenHeight

FVARIABLE roundness
FVARIABLE rwidth
FVARIABLE rheight
FVARIABLE segments
FVARIABLE lineThick
VARIABLE drawRect
VARIABLE drawRoundedRect
VARIABLE drawRoundedLines
CREATE rec 16 ALLOT
CREATE s1 16 ALLOT CREATE s2 16 ALLOT CREATE s3 16 ALLOT
CREATE s4 16 ALLOT CREATE s5 16 ALLOT
CREATE c1 16 ALLOT CREATE c2 16 ALLOT CREATE c3 16 ALLOT

: example
   screenWidth screenHeight z" raylib [shapes] example - rounded rectangle drawing" InitWindow
   0.2e roundness f!  200e rwidth f!  100e rheight f!
   0e segments f!  1e lineThick f!
   false drawRect !  true drawRoundedRect !  false drawRoundedLines !
   60 SetTargetFPS
   begin
      GetScreenWidth s>f rwidth f@ f- 250e f- 2e f/
      GetScreenHeight s>f rheight f@ f- 2e f/
      rwidth f@ rheight f@ rec Rectangle!
      BeginDrawing
         RAYWHITE ClearBackground
         560 0 560 GetScreenHeight LIGHTGRAY 0.6e Fade DrawLine
         560 0 GetScreenWidth 500 - GetScreenHeight LIGHTGRAY 0.3e Fade DrawRectangle
         drawRect @ if rec GOLD 0.6e Fade DrawRectangleRec then
         drawRoundedRect @ if rec roundness f@ segments f@ f>s MAROON 0.2e Fade DrawRectangleRounded then
         drawRoundedLines @ if rec roundness f@ segments f@ f>s lineThick f@ MAROON 0.4e Fade DrawRectangleRoundedLinesEx then
         640e 40e 105e 20e s1 Rectangle!  s1 rwidth 0e GetScreenWidth 300 - s>f gui-slider
         z" Width" 580 42 10 DARKGRAY DrawText
         640e 70e 105e 20e s2 Rectangle!  s2 rheight 0e GetScreenHeight 50 - s>f gui-slider
         z" Height" 580 72 10 DARKGRAY DrawText
         640e 140e 105e 20e s3 Rectangle!  s3 roundness 0e 1e gui-slider
         z" Roundness" 560 142 10 DARKGRAY DrawText
         640e 170e 105e 20e s4 Rectangle!  s4 lineThick 0e 20e gui-slider
         z" Thickness" 560 172 10 DARKGRAY DrawText
         640e 240e 105e 20e s5 Rectangle!  s5 segments 0e 60e gui-slider
         z" Segments" 560 242 10 DARKGRAY DrawText
         640e 320e 20e 20e c1 Rectangle!  c1 drawRoundedRect z" DrawRoundedRect" gui-check
         640e 350e 20e 20e c2 Rectangle!  c2 drawRoundedLines z" DrawRoundedLines" gui-check
         640e 380e 20e 20e c3 Rectangle!  c3 drawRect z" DrawRect" gui-check
         segments f@ 4e f>= if
            z" MODE: MANUAL" 640 280 10 MAROON DrawText
         else
            z" MODE: AUTO" 640 280 10 DARKGRAY DrawText
         then
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
