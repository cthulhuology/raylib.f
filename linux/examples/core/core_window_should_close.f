\ Port of raylib examples/core/core_window_should_close.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

VARIABLE exitWindowRequested
VARIABLE exitWindow

: example
   screenWidth screenHeight z" raylib [core] example - window should close" InitWindow
   KEY_NULL SetExitKey
   0 exitWindowRequested !
   0 exitWindow !
   60 SetTargetFPS
   begin
      WindowShouldClose 1 and  KEY_ESCAPE IsKeyPressed 1 and or if
         1 exitWindowRequested !
      then
      exitWindowRequested @ if
         KEY_Y IsKeyPressed 1 and if 1 exitWindow ! then
         KEY_N IsKeyPressed 1 and if 0 exitWindowRequested ! then
      then
      BeginDrawing
         RAYWHITE ClearBackground
         exitWindowRequested @ if
            0 100 screenWidth 200 BLACK DrawRectangle
            z" Are you sure you want to exit program? [Y/N]" 40 180 30 WHITE DrawText
         else
            z" Try to close the window to get confirmation message!" 120 200 20 LIGHTGRAY DrawText
         then
      EndDrawing
   exitWindow @ until
   CloseWindow ;

example-end
