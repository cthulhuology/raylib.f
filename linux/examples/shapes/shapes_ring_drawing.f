\ Port of raylib examples/shapes/shapes_ring_drawing.c
\ raygui sliders/checkboxes replaced with mouse controls

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE center 8 ALLOT
FVARIABLE innerRadius
FVARIABLE outerRadius
FVARIABLE startAngle
FVARIABLE endAngle
FVARIABLE segments
VARIABLE showRing
VARIABLE showRingLines
VARIABLE showCLines
CREATE s1 16 ALLOT CREATE s2 16 ALLOT CREATE s3 16 ALLOT
CREATE s4 16 ALLOT CREATE s5 16 ALLOT
CREATE c1 16 ALLOT CREATE c2 16 ALLOT CREATE c3 16 ALLOT

: example
   screenWidth screenHeight z" raylib [shapes] example - ring drawing" InitWindow
   GetScreenWidth 300 - 2/ s>f GetScreenHeight 2/ s>f center Vector2!
   80e innerRadius f!  190e outerRadius f!
   0e startAngle f!  360e endAngle f!  0e segments f!
   true showRing !  false showRingLines !  false showCLines !
   60 SetTargetFPS
   begin
      BeginDrawing
         RAYWHITE ClearBackground
         500 0 500 GetScreenHeight LIGHTGRAY 0.6e Fade DrawLine
         500 0 GetScreenWidth 500 - GetScreenHeight LIGHTGRAY 0.3e Fade DrawRectangle
         showRing @ if
            center innerRadius f@ outerRadius f@ startAngle f@ endAngle f@
            segments f@ f>s MAROON 0.3e Fade DrawRing then
         showRingLines @ if
            center innerRadius f@ outerRadius f@ startAngle f@ endAngle f@
            segments f@ f>s BLACK 0.4e Fade DrawRingLines then
         showCLines @ if
            center outerRadius f@ startAngle f@ endAngle f@
            segments f@ f>s BLACK 0.4e Fade DrawCircleSectorLines then
         600e 40e 120e 20e s1 Rectangle!  s1 startAngle -450e 450e gui-slider
         z" StartAngle" 510 42 10 DARKGRAY DrawText
         600e 70e 120e 20e s2 Rectangle!  s2 endAngle -450e 450e gui-slider
         z" EndAngle" 510 72 10 DARKGRAY DrawText
         600e 140e 120e 20e s3 Rectangle!  s3 innerRadius 0e 100e gui-slider
         z" InnerRadius" 500 142 10 DARKGRAY DrawText
         600e 170e 120e 20e s4 Rectangle!  s4 outerRadius 0e 200e gui-slider
         z" OuterRadius" 500 172 10 DARKGRAY DrawText
         600e 240e 120e 20e s5 Rectangle!  s5 segments 0e 100e gui-slider
         z" Segments" 510 242 10 DARKGRAY DrawText
         600e 320e 20e 20e c1 Rectangle!  c1 showRing z" Draw Ring" gui-check
         600e 350e 20e 20e c2 Rectangle!  c2 showRingLines z" Draw RingLines" gui-check
         600e 380e 20e 20e c3 Rectangle!  c3 showCLines z" Draw CircleLines" gui-check
         endAngle f@ startAngle f@ f- 90e f/ fdup f0< if fdrop 0e then
         segments f@ fover f>= if
            z" MODE: MANUAL" 600 270 10 MAROON DrawText
         else
            z" MODE: AUTO" 600 270 10 DARKGRAY DrawText
         then
         fdrop
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
