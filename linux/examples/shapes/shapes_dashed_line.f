\ Port of raylib examples/shapes/shapes_dashed_line.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE lineStart 8 ALLOT
CREATE lineEnd 8 ALLOT
FVARIABLE dashLen
FVARIABLE blankLen
CREATE lineColors 8 CELLS ALLOT
VARIABLE colorIndex

: example
   screenWidth screenHeight z" raylib [shapes] example - dashed line" InitWindow
   20e 50e lineStart Vector2!
   780e 400e lineEnd Vector2!
   25e dashLen f!  15e blankLen f!
   RED lineColors 0 cells + !  ORANGE lineColors 1 cells + !
   GOLD lineColors 2 cells + !  GREEN lineColors 3 cells + !
   BLUE lineColors 4 cells + !  VIOLET lineColors 5 cells + !
   PINK lineColors 6 cells + !  BLACK lineColors 7 cells + !
   0 colorIndex !
   60 SetTargetFPS
   begin
      mouse@ lineEnd 8 move
      KEY_UP down if dashLen f@ 1e f+ dashLen f! then
      KEY_DOWN down dashLen f@ 1e f> and if dashLen f@ 1e f- dashLen f! then
      KEY_RIGHT down if blankLen f@ 1e f+ blankLen f! then
      KEY_LEFT down blankLen f@ 1e f> and if blankLen f@ 1e f- blankLen f! then
      KEY_C IsKeyPressed if colorIndex @ 1+ 8 mod colorIndex ! then
      BeginDrawing
         RAYWHITE ClearBackground
         lineStart lineEnd dashLen f@ f>s blankLen f@ f>s
            colorIndex @ cells lineColors + @ DrawLineDashed
         5 5 265 95 SKYBLUE 0.5e Fade DrawRectangle
         5 5 265 95 BLUE DrawRectangleLines
         z" CONTROLS:" 15 15 10 BLACK DrawText
         z" UP/DOWN: Change Dash Length" 15 35 10 BLACK DrawText
         z" LEFT/RIGHT: Change Space Length" 15 55 10 BLACK DrawText
         z" C: Cycle Color" 15 75 10 BLACK DrawText
         z" Dash:" 15 115 10 DARKGRAY DrawText
         dashLen f@ zf0 50 115 10 DARKGRAY DrawText
         z" Space:" 90 115 10 DARKGRAY DrawText
         blankLen f@ zf0 140 115 10 DARKGRAY DrawText
         screenWidth 80 - 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
