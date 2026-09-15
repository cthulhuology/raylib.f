\ Port of raylib examples/shapes/shapes_circle_sector_drawing.c
\ raygui sliders replaced with mouse sliders

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE center 8 ALLOT
FVARIABLE outerRadius
FVARIABLE startAngle
FVARIABLE endAngle
FVARIABLE segments
CREATE s1 16 ALLOT  CREATE s2 16 ALLOT
CREATE s3 16 ALLOT  CREATE s4 16 ALLOT

: example
   screenWidth screenHeight z" raylib [shapes] example - circle sector drawing" InitWindow
   GetScreenWidth 300 - 2/ s>f GetScreenHeight 2/ s>f center Vector2!
   180e outerRadius f!  0e startAngle f!  180e endAngle f!  10e segments f!
   60 SetTargetFPS
   begin
      BeginDrawing
         RAYWHITE ClearBackground
         500 0 500 GetScreenHeight LIGHTGRAY 0.6e Fade DrawLine
         500 0 GetScreenWidth 500 - GetScreenHeight LIGHTGRAY 0.3e Fade DrawRectangle
         center outerRadius f@ startAngle f@ endAngle f@ segments f@ f>s MAROON 0.3e Fade DrawCircleSector
         center outerRadius f@ startAngle f@ endAngle f@ segments f@ f>s MAROON 0.6e Fade DrawCircleSectorLines
         600e 40e 120e 20e s1 Rectangle!
         z" StartAngle" 510 42 10 DARKGRAY DrawText
         s1 startAngle 0e 720e gui-slider
         startAngle f@ zf0 730 42 10 DARKGRAY DrawText
         600e 70e 120e 20e s2 Rectangle!
         z" EndAngle" 510 72 10 DARKGRAY DrawText
         s2 endAngle 0e 720e gui-slider
         endAngle f@ zf0 730 72 10 DARKGRAY DrawText
         600e 140e 120e 20e s3 Rectangle!
         z" Radius" 510 142 10 DARKGRAY DrawText
         s3 outerRadius 0e 200e gui-slider
         outerRadius f@ zf0 730 142 10 DARKGRAY DrawText
         600e 170e 120e 20e s4 Rectangle!
         z" Segments" 510 172 10 DARKGRAY DrawText
         s4 segments 0e 100e gui-slider
         segments f@ zf0 730 172 10 DARKGRAY DrawText
         endAngle f@ startAngle f@ f- 90e f/ fdup f0< if fdrop 0e then
         segments f@ fover f>= if
            z" MODE: MANUAL" 600 200 10 MAROON DrawText
         else
            z" MODE: AUTO" 600 200 10 DARKGRAY DrawText
         then
         fdrop
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
