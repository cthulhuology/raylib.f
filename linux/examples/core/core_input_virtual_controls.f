\ Port of raylib examples/core/core_input_virtual_controls.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

-1 CONSTANT BUTTON_NONE
 0 CONSTANT BUTTON_UP
 1 CONSTANT BUTTON_LEFT
 2 CONSTANT BUTTON_RIGHT
 3 CONSTANT BUTTON_DOWN
 4 CONSTANT BUTTON_MAX

CREATE padPosition 8 ALLOT
30e fconstant buttonRadius
CREATE buttonPositions  BUTTON_MAX 8 * ALLOT
CREATE buttonLabels  BUTTON_MAX CELLS ALLOT
CREATE buttonLabelColors  BUTTON_MAX CELLS ALLOT
VARIABLE pressedButton
CREATE inputPosition 8 ALLOT
CREATE playerPosition 8 ALLOT
75e fconstant playerSpeed

: btn-pos ( i -- addr ) 8 * buttonPositions + ;

: example
   100e 350e padPosition Vector2!
   padPosition v2x  padPosition v2y buttonRadius 1.5e f* f-  0 btn-pos Vector2!
   padPosition v2x buttonRadius 1.5e f* f-  padPosition v2y  1 btn-pos Vector2!
   padPosition v2x buttonRadius 1.5e f* f+  padPosition v2y  2 btn-pos Vector2!
   padPosition v2x  padPosition v2y buttonRadius 1.5e f* f+  3 btn-pos Vector2!
   z" Y" buttonLabels !
   z" X" buttonLabels 1 CELLS + !
   z" B" buttonLabels 2 CELLS + !
   z" A" buttonLabels 3 CELLS + !
   YELLOW buttonLabelColors !
   BLUE   buttonLabelColors 1 CELLS + !
   RED    buttonLabelColors 2 CELLS + !
   GREEN  buttonLabelColors 3 CELLS + !
   BUTTON_NONE pressedButton !
   screenWidth s>f 2e f/  screenHeight s>f 2e f/  playerPosition Vector2!
   screenWidth screenHeight z" raylib [core] example - input virtual controls" InitWindow
   60 SetTargetFPS
   begin
      GetTouchPointCount 0 > if
         inputPosition 0 GetTouchPosition drop
      else
         inputPosition GetMousePosition drop
      then
      BUTTON_NONE pressedButton !
      GetTouchPointCount 0 >  GetTouchPointCount 0= MOUSE_BUTTON_LEFT IsMouseButtonDown 1 and and  or if
         BUTTON_MAX 0 ?do
            i btn-pos v2x inputPosition v2x f- fabs
            i btn-pos v2y inputPosition v2y f- fabs
            f+ buttonRadius f< if
               i pressedButton !  leave
            then
         loop
      then
      pressedButton @ case
         BUTTON_UP    of playerPosition v2x  playerPosition v2y playerSpeed GetFrameTime f* f-  playerPosition Vector2! endof
         BUTTON_LEFT  of playerPosition v2x playerSpeed GetFrameTime f* f-  playerPosition v2y  playerPosition Vector2! endof
         BUTTON_RIGHT of playerPosition v2x playerSpeed GetFrameTime f* f+  playerPosition v2y  playerPosition Vector2! endof
         BUTTON_DOWN  of playerPosition v2x  playerPosition v2y playerSpeed GetFrameTime f* f+  playerPosition Vector2! endof
      endcase
      BeginDrawing
         RAYWHITE ClearBackground
         playerPosition 50e MAROON DrawCircleV
         BUTTON_MAX 0 ?do
            i btn-pos buttonRadius  i pressedButton @ = if DARKGRAY else BLACK then DrawCircleV
            i CELLS buttonLabels + @
            i btn-pos v2x f>s 7 -
            i btn-pos v2y f>s 8 -
            20
            i CELLS buttonLabelColors + @
            DrawText
         loop
         z" move the player with D-Pad buttons" 10 10 20 DARKGRAY DrawText
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
