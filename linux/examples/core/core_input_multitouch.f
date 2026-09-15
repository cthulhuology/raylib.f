\ Port of raylib examples/core/core_input_multitouch.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
10 CONSTANT MAX_TOUCH_POINTS

CREATE touchPositions  MAX_TOUCH_POINTS 8 * ALLOT
VARIABLE tCount

CREATE nbuf 64 ALLOT
: n>z ( n -- zaddr )
   dup abs s>d <# #s rot sign #> nbuf swap 2dup + 0 swap c! move nbuf ;

: touch-at ( i -- addr ) 8 * touchPositions + ;

: example
   screenWidth screenHeight z" raylib [core] example - input multitouch" InitWindow
   60 SetTargetFPS
   begin
      GetTouchPointCount tCount !
      tCount @ MAX_TOUCH_POINTS > if MAX_TOUCH_POINTS tCount ! then
      tCount @ 0 ?do
         i touch-at i GetTouchPosition drop
      loop
      BeginDrawing
         RAYWHITE ClearBackground
         tCount @ 0 ?do
            i touch-at v2x 0e f>  i touch-at v2y 0e f> and if
               i touch-at 34e ORANGE DrawCircleV
               i n>z
               i touch-at v2x f>s 10 -
               i touch-at v2y f>s 70 -
               40 BLACK DrawText
            then
         loop
         z" touch the screen at multiple locations to get multiple balls" 10 10 20 DARKGRAY DrawText
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
