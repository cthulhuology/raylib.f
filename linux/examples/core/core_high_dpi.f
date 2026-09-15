\ Port of raylib examples/core/core_high_dpi.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE dpiScale 8 ALLOT
CREATE tsize 8 ALLOT
CREATE tpos 8 ALLOT
CREATE font 48 ALLOT
CREATE nbuf 64 ALLOT

VARIABLE logicalGridDescY
VARIABLE logicalGridLabelY
VARIABLE logicalGridTop
VARIABLE logicalGridBottom
VARIABLE pixelGridTop
VARIABLE pixelGridBottom
VARIABLE pixelGridLabelY
VARIABLE pixelGridDescY
50 CONSTANT cellSize
0e fvalue cellSizePx

: n>z ( n -- zaddr )
   dup abs s>d <# #s rot sign #> nbuf swap 2dup + 0 swap c! move nbuf ;

: DrawTextCenter ( z x y size color -- )
   locals| color size y x text |
   tsize font text size s>f 3e MeasureTextEx drop
   tpos  x s>f tsize v2x f2/ f-  y s>f tsize v2y f2/ f-  Vector2!
   font text tpos size s>f 3e color DrawTextEx ;

: example
   FLAG_WINDOW_HIGHDPI FLAG_WINDOW_RESIZABLE or SetConfigFlags
   screenWidth screenHeight z" raylib [core] example - high dpi" InitWindow
   450 450 SetWindowMinSize
   font GetFontDefault drop
   120 logicalGridDescY !
   logicalGridDescY @ 30 + logicalGridLabelY !
   logicalGridLabelY @ 30 + logicalGridTop !
   logicalGridTop @ 80 + logicalGridBottom !
   logicalGridBottom @ 20 - pixelGridTop !
   pixelGridTop @ 80 + pixelGridBottom !
   pixelGridBottom @ 30 + pixelGridLabelY !
   pixelGridLabelY @ 30 + pixelGridDescY !
   cellSize s>f to cellSizePx
   60 SetTargetFPS
   begin
      GetMonitorCount 1 > KEY_N IsKeyPressed 1 and and if
         GetCurrentMonitor 1+ GetMonitorCount mod SetWindowMonitor
      then
      dpiScale GetWindowScaleDPI drop
      cellSize s>f dpiScale v2x f/ to cellSizePx
      BeginDrawing
         RAYWHITE ClearBackground
         z" Dpi Scale" GetScreenWidth 2/ 30 40 DARKGRAY DrawTextCenter
         z" Monitor: " GetScreenWidth 2/ 70 20 LIGHTGRAY DrawTextCenter
         z" Window is logical points wide" GetScreenWidth 2/ logicalGridDescY @ 20 ORANGE DrawTextCenter
         1  \ odd
         GetScreenWidth cellSize ?do
            over if i logicalGridTop @ cellSize logicalGridBottom @ logicalGridTop @ - ORANGE DrawRectangle then
            0=
            i n>z i logicalGridLabelY @ 10 LIGHTGRAY DrawTextCenter
            i  logicalGridLabelY @ 10 +  i  logicalGridBottom @ GRAY DrawLine
         cellSize +loop
         drop
         z" Window is physical pixels wide" GetScreenWidth 2/ pixelGridDescY @ 20 BLUE DrawTextCenter
         z" Can you see this?"
         tsize font 2 pick 20e 3e MeasureTextEx drop
         GetScreenWidth s>f tsize v2x f- 5e f-  GetScreenHeight s>f tsize v2y f- 5e f- tpos Vector2!
         font swap tpos 20e 3e LIGHTGRAY DrawTextEx
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
