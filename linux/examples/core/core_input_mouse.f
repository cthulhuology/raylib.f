\ Port of raylib examples/core/core_input_mouse.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE ball  8 ALLOT
VARIABLE ballColor

: example
   -100e -100e ball Vector2!
   DARKBLUE ballColor !
   screenWidth screenHeight z" raylib [core] example - input mouse" InitWindow
   60 SetTargetFPS
   begin
      KEY_H IsKeyPressed 1 and if
         IsCursorHidden 1 and if ShowCursor else HideCursor then
      then
      ball GetMousePosition drop
      MOUSE_BUTTON_LEFT    IsMouseButtonPressed 1 and if MAROON    ballColor ! else
      MOUSE_BUTTON_MIDDLE  IsMouseButtonPressed 1 and if LIME      ballColor ! else
      MOUSE_BUTTON_RIGHT   IsMouseButtonPressed 1 and if DARKBLUE  ballColor ! else
      MOUSE_BUTTON_SIDE    IsMouseButtonPressed 1 and if PURPLE    ballColor ! else
      MOUSE_BUTTON_EXTRA   IsMouseButtonPressed 1 and if YELLOW    ballColor ! else
      MOUSE_BUTTON_FORWARD IsMouseButtonPressed 1 and if ORANGE    ballColor ! else
      MOUSE_BUTTON_BACK    IsMouseButtonPressed 1 and if BEIGE     ballColor ! then
      then then then then then then
      BeginDrawing
         RAYWHITE ClearBackground
         ball 40e ballColor @ DrawCircleV
         z" move ball with mouse and click mouse button to change color" 10 10 20 DARKGRAY DrawText
         z" Press 'H' to toggle cursor visibility" 10 30 20 DARKGRAY DrawText
         IsCursorHidden 1 and if
            z" CURSOR HIDDEN" 20 60 20 RED DrawText
         else
            z" CURSOR VISIBLE" 20 60 20 LIME DrawText
         then
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
