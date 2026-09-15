\ Port of raylib examples/core/core_input_mouse_wheel.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

VARIABLE boxPositionY
4 CONSTANT scrollSpeed

CREATE nbuf 64 ALLOT
: n>z ( n -- zaddr )
   dup abs s>d <# #s rot sign #> nbuf swap 2dup + 0 swap c! move nbuf ;

: example
   screenHeight 2/ 40 - boxPositionY !
   screenWidth screenHeight z" raylib [core] example - input mouse wheel" InitWindow
   60 SetTargetFPS
   begin
      GetMouseWheelMove scrollSpeed s>f f* f>s negate boxPositionY +!
      BeginDrawing
         RAYWHITE ClearBackground
         screenWidth 2/ 40 - boxPositionY @ 80 80 MAROON DrawRectangle
         z" Use mouse wheel to move the cube up and down!" 10 10 20 GRAY DrawText
         z" Box position Y: " 10 40 20 LIGHTGRAY DrawText
         boxPositionY @ n>z 170 40 20 LIGHTGRAY DrawText
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
