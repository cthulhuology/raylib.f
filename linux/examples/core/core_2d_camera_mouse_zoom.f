\ Port of raylib examples/core/core_2d_camera_mouse_zoom.c
\ rlgl matrix grid replaced with a 2D line grid

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE camera 24 ALLOT
VARIABLE zoomMode
CREATE delta 8 ALLOT
CREATE mouseWorld 8 ALLOT
CREATE font 48 ALLOT
CREATE tpos 8 ALLOT
CREATE nbuf 64 ALLOT

: n>z ( n -- zaddr )
   dup abs s>d <# #s rot sign #> nbuf swap 2dup + 0 swap c! move nbuf ;

: cam-off  camera ;
: cam-tgt  camera 8 + ;
: cam-rot  camera 16 + ;
: cam-zoom camera 20 + ;

: draw-xy-grid
   101 0 ?do
      i 50 * 2500 - dup  -2500 swap  2500  LIGHTGRAY DrawLine
      -2500  i 50 * 2500 -  2500  i 50 * 2500 -  LIGHTGRAY DrawLine
   loop ;

: example
   camera 24 erase
   1e cam-zoom sf!
   0 zoomMode !
   screenWidth screenHeight z" raylib [core] example - 2d camera mouse zoom" InitWindow
   font GetFontDefault drop
   60 SetTargetFPS
   begin
      KEY_ONE IsKeyPressed 1 and if 0 zoomMode ! else
      KEY_TWO IsKeyPressed 1 and if 1 zoomMode ! then then
      MOUSE_BUTTON_LEFT IsMouseButtonDown 1 and if
         delta GetMouseDelta drop
         delta delta  cam-zoom sf@ fnegate 1e fswap f/  Vector2Scale drop
         cam-tgt dup delta Vector2Add drop
      then
      zoomMode @ 0= if
         GetMouseWheelMove fdup f0= 0= if
            mouseWorld mouse@ camera GetScreenToWorld2D drop
            mouse@ 8 cam-off swap move
            mouseWorld 8 cam-tgt swap move
            0.2e f*  cam-zoom sf@ fln f+ fexp  0.125e 64e ClampF  cam-zoom sf!
         else fdrop then
      else
         MOUSE_BUTTON_RIGHT IsMouseButtonPressed 1 and if
            mouseWorld mouse@ camera GetScreenToWorld2D drop
            mouse@ 8 cam-off swap move
            mouseWorld 8 cam-tgt swap move
         then
         MOUSE_BUTTON_RIGHT IsMouseButtonDown 1 and if
            delta GetMouseDelta drop
            delta v2x 0.005e f*  cam-zoom sf@ fln f+ fexp  0.125e 64e ClampF  cam-zoom sf!
         then
      then
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode2D
            draw-xy-grid
            GetScreenWidth 2/ GetScreenHeight 2/ 50e MAROON DrawCircle
         EndMode2D
         mouse@ 4e DARKGRAY DrawCircleV
         mouse@ v2x -44e f+  mouse@ v2y -24e f+  tpos Vector2!
         z" ["  tpos  20e 2e BLACK  font swap DrawTextEx
         z" [1][2] Select mouse zoom mode (Wheel or Move)" 20 20 20 DARKGRAY DrawText
         zoomMode @ 0= if
            z" Mouse left button drag to move, mouse wheel to zoom" 20 50 20 DARKGRAY DrawText
         else
            z" Mouse left button drag to move, mouse press and move to zoom" 20 50 20 DARKGRAY DrawText
         then
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
