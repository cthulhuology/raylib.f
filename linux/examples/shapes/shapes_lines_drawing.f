\ Port of raylib examples/shapes/shapes_lines_drawing.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

VARIABLE startText
CREATE mousePrev 8 ALLOT
CREATE canvas 48 ALLOT
CREATE src 16 ALLOT
FVARIABLE lineThick
FVARIABLE lineHue
VARIABLE leftDown
VARIABLE rightDown
VARIABLE drawColor

: example
   screenWidth screenHeight z" raylib [shapes] example - lines drawing" InitWindow
   true startText !
   mouse@ mousePrev 8 move
   canvas screenWidth screenHeight LoadRenderTexture drop
   8e lineThick f!  0e lineHue f!
   canvas BeginTextureMode
      RAYWHITE ClearBackground
   EndTextureMode
   begin
      MOUSE_BUTTON_LEFT IsMouseButtonPressed startText @ and if
         false startText ! then
      MOUSE_BUTTON_MIDDLE IsMouseButtonPressed if
         canvas BeginTextureMode
            RAYWHITE ClearBackground
         EndTextureMode
      then
      MOUSE_BUTTON_LEFT IsMouseButtonDown leftDown !
      MOUSE_BUTTON_RIGHT IsMouseButtonDown rightDown !
      leftDown @ rightDown @ or if
         leftDown @ if
            lineHue f@ mousePrev mouse@ Vector2Distance 3e f/ f+
            begin fdup 360e f>= while 360e f- repeat lineHue f!
            lineHue f@ 1e 1e ColorFromHSV drawColor !
         else
            RAYWHITE drawColor !
         then
         canvas BeginTextureMode
            mousePrev lineThick f@ 2e f/ drawColor @ DrawCircleV
            mouse@ lineThick f@ 2e f/ drawColor @ DrawCircleV
            mousePrev mouse@ lineThick f@ drawColor @ DrawLineEx
         EndTextureMode
      then
      lineThick f@ GetMouseWheelMove f+ 1e 500e ClampF lineThick f!
      mouse@ mousePrev 8 move
      BeginDrawing
         canvas rtex  canvas src flip-rt  origin2 WHITE DrawTextureRec
         leftDown @ 0= if
            mouse@ lineThick f@ 2e f/ 127 127 127 127 RGBA DrawCircleLinesV
         then
         startText @ if
            z" try clicking and dragging!" 275 215 20 LIGHTGRAY DrawText
         then
      EndDrawing
   WindowShouldClose until
   canvas UnloadRenderTexture
   CloseWindow ;

example-end
