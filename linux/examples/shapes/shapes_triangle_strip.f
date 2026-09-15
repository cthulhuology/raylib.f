\ Port of raylib examples/shapes/shapes_triangle_strip.c
\ raygui widgets replaced with mouse slider/checkbox

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE points 122 8 * ALLOT
CREATE center 8 ALLOT
CREATE va 8 ALLOT CREATE vb 8 ALLOT CREATE vc 8 ALLOT CREATE vd 8 ALLOT
FVARIABLE segments
FVARIABLE insideRadius
FVARIABLE outsideRadius
FVARIABLE angleStep
VARIABLE outline
VARIABLE pointCount
CREATE s1 16 ALLOT CREATE ck 16 ALLOT
218 218 218 255 RGBA CONSTANT PANEL_LINE
232 232 232 255 RGBA CONSTANT PANEL_BG

: p-i ( i -- a ) 8 * points + ;

: example
   screenWidth screenHeight z" raylib [shapes] example - triangle strip" InitWindow
   screenWidth 2/ s>f 125e f- screenHeight 2/ s>f center Vector2!
   6e segments f!  100e insideRadius f!  150e outsideRadius f!
   true outline !
   60 SetTargetFPS
   begin
      segments f@ f>s pointCount !
      360e pointCount @ s>f f/ deg>rad angleStep f!
      pointCount @ 0 do
         angleStep f@ i s>f f*
         fdup fcos insideRadius f@ f* center v2x f+
         fover fsin insideRadius f@ f* center v2y f+
         i 2* p-i Vector2!
         angleStep f@ 2e f/ f+
         fdup fcos outsideRadius f@ f* center v2x f+
         fswap fsin outsideRadius f@ f* center v2y f+
         i 2* 1+ p-i Vector2!
      loop
      0 p-i pointCount @ 2* p-i 8 move
      1 p-i pointCount @ 2* 1+ p-i 8 move
      BeginDrawing
         RAYWHITE ClearBackground
         pointCount @ 0 do
            i 2* p-i va 8 move
            i 2* 1+ p-i vb 8 move
            i 2* 2 + p-i vc 8 move
            i 2* 3 + p-i vd 8 move
            vc vb va angleStep f@ i s>f f* rad>deg 1e 1e ColorFromHSV DrawTriangle
            vd vb vc angleStep f@ i s>f f* angleStep f@ 2e f/ f+ rad>deg 1e 1e ColorFromHSV DrawTriangle
            outline @ if
               va vb vc BLACK DrawTriangleLines
               vc vb vd BLACK DrawTriangleLines
            then
         loop
         580 0 580 GetScreenHeight PANEL_LINE DrawLine
         580 0 GetScreenWidth GetScreenHeight PANEL_BG DrawRectangle
         640e 40e 120e 20e s1 Rectangle!  s1 segments 6e 60e gui-slider
         z" Segments" 560 42 10 DARKGRAY DrawText
         640e 70e 20e 20e ck Rectangle!  ck outline z" Outline" gui-check
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
