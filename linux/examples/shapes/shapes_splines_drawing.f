\ Port of raylib examples/shapes/shapes_splines_drawing.c
\ raygui dropdown replaced with keys 1-4; H toggles helpers; wheel thickness

800 CONSTANT screenWidth
450 CONSTANT screenHeight
32 CONSTANT MAX_SP
0 CONSTANT SPLINE_LINEAR
1 CONSTANT SPLINE_BASIS
2 CONSTANT SPLINE_CATMULL
3 CONSTANT SPLINE_BEZIER

CREATE points MAX_SP 8 * ALLOT
CREATE interleaved 3 MAX_SP 1- * 1+ 8 * ALLOT
CREATE control MAX_SP 1- 16 * ALLOT
VARIABLE pointCount
VARIABLE selectedPoint
VARIABLE focusedPoint
VARIABLE selectedCP
VARIABLE focusedCP
FVARIABLE splineThick
VARIABLE splineType
VARIABLE helpers

: pt ( i -- a ) 8 * points + ;
: ctl ( i -- a ) 16 * control + ;
: ctl.start ( a -- a ) ;
: ctl.end ( a -- a ) 8 + ;
: ile ( i -- a ) 8 * interleaved + ;

: example
   FLAG_MSAA_4X_HINT SetConfigFlags
   screenWidth screenHeight z" raylib [shapes] example - splines drawing" InitWindow
   50e 400e 0 pt Vector2!
   160e 220e 1 pt Vector2!
   340e 380e 2 pt Vector2!
   520e 60e 3 pt Vector2!
   710e 260e 4 pt Vector2!
   5 pointCount !
   pointCount @ 1- 0 do
      i pt v2x 50e f+ i pt v2y i ctl ctl.start Vector2!
      i 1+ pt v2x 50e f- i 1+ pt v2y i ctl ctl.end Vector2!
   loop
   -1 selectedPoint !  -1 focusedPoint !
   -1 selectedCP !  -1 focusedCP !
   8e splineThick f!  SPLINE_LINEAR splineType !  true helpers !
   60 SetTargetFPS
   begin
      MOUSE_BUTTON_RIGHT IsMouseButtonPressed
      pointCount @ MAX_SP < and if
         mouse@ pointCount @ pt 8 move
         pointCount @ 1- dup
         pt v2x 50e f+ over pt v2y swap ctl ctl.start Vector2!
         pointCount @ pt v2x 50e f- pointCount @ pt v2y
         pointCount @ 1- ctl ctl.end Vector2!
         1 pointCount +!
      then
      selectedPoint @ 0< splineType @ SPLINE_BEZIER <> selectedCP @ 0< or and if
         -1 focusedPoint !
         pointCount @ 0 do
            mouse@ i pt 8e CheckCollisionPointCircle if i focusedPoint ! leave then
         loop
         MOUSE_BUTTON_LEFT IsMouseButtonPressed if focusedPoint @ selectedPoint ! then
      then
      selectedPoint @ 0 >= if
         mouse@ selectedPoint @ pt 8 move
         MOUSE_BUTTON_LEFT IsMouseButtonReleased if -1 selectedPoint ! then
      then
      splineType @ SPLINE_BEZIER = focusedPoint @ 0< and if
         selectedCP @ 0< if
            -1 focusedCP !
            pointCount @ 1- 0 do
               mouse@ i ctl ctl.start 6e CheckCollisionPointCircle if i 2* focusedCP ! leave then
               mouse@ i ctl ctl.end 6e CheckCollisionPointCircle if i 2* 1+ focusedCP ! leave then
            loop
            MOUSE_BUTTON_LEFT IsMouseButtonPressed if focusedCP @ selectedCP ! then
         then
         selectedCP @ 0 >= if
            selectedCP @ 2 mod if
               mouse@ selectedCP @ 2/ ctl ctl.end 8 move
            else
               mouse@ selectedCP @ 2/ ctl ctl.start 8 move
            then
            MOUSE_BUTTON_LEFT IsMouseButtonReleased if -1 selectedCP ! then
         then
      then
      KEY_ONE IsKeyPressed if SPLINE_LINEAR splineType ! -1 selectedCP ! then
      KEY_TWO IsKeyPressed if SPLINE_BASIS splineType ! -1 selectedCP ! then
      KEY_THREE IsKeyPressed if SPLINE_CATMULL splineType ! -1 selectedCP ! then
      KEY_FOUR IsKeyPressed if SPLINE_BEZIER splineType ! then
      KEY_H IsKeyPressed if helpers @ 0= helpers ! then
      splineThick f@ GetMouseWheelMove f+ 1e 40e ClampF splineThick f!
      BeginDrawing
         RAYWHITE ClearBackground
         splineType @ SPLINE_LINEAR = if
            points pointCount @ splineThick f@ RED DrawSplineLinear
         else splineType @ SPLINE_BASIS = if
            points pointCount @ splineThick f@ RED DrawSplineBasis
         else splineType @ SPLINE_CATMULL = if
            points pointCount @ splineThick f@ RED DrawSplineCatmullRom
         else
            pointCount @ 1- 0 do
               i pt i 3 * ile 8 move
               i ctl ctl.start i 3 * 1+ ile 8 move
               i ctl ctl.end i 3 * 2 + ile 8 move
            loop
            pointCount @ 1- pt  pointCount @ 1- 3 * ile 8 move
            interleaved  pointCount @ 1- 3 * 1+  splineThick f@ RED DrawSplineBezierCubic
            pointCount @ 1- 0 do
               i ctl ctl.start 6e GOLD DrawCircleV
               i ctl ctl.end 6e GOLD DrawCircleV
               focusedCP @ i 2* = if i ctl ctl.start 8e GREEN DrawCircleV then
               focusedCP @ i 2* 1+ = if i ctl ctl.end 8e GREEN DrawCircleV then
               i pt i ctl ctl.start 1e LIGHTGRAY DrawLineEx
               i 1+ pt i ctl ctl.end 1e LIGHTGRAY DrawLineEx
               i pt i ctl ctl.start GRAY DrawLineV
               i ctl ctl.end i 1+ pt GRAY DrawLineV
            loop
         then then then
         helpers @ if
            pointCount @ 0 do
               i pt  focusedPoint @ i = if 12e else 8e then
               focusedPoint @ i = if BLUE else DARKBLUE then DrawCircleLinesV
               splineType @ SPLINE_LINEAR <>
               splineType @ SPLINE_BEZIER <> and
               i pointCount @ 1- < and if
                  i pt i 1+ pt GRAY DrawLineV
               then
            loop
         then
         z" 1 Linear  2 BSpline  3 Catmull  4 Bezier" 12 10 10 DARKGRAY DrawText
         z" Right-click add point  H helpers  wheel thickness" 12 28 10 DARKGRAY DrawText
         z" Thickness:" 12 62 10 DARKGRAY DrawText
         splineThick f@ zf0 90 62 10 DARKGRAY DrawText
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
