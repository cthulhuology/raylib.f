\ Port of raylib examples/shapes/shapes_lines_bezier.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE startP 8 ALLOT
CREATE endP 8 ALLOT
VARIABLE moveStart
VARIABLE moveEnd

: example
   FLAG_MSAA_4X_HINT SetConfigFlags
   screenWidth screenHeight z" raylib [shapes] example - lines bezier" InitWindow
   30e 30e startP Vector2!
   screenWidth 30 - s>f screenHeight 30 - s>f endP Vector2!
   false moveStart !  false moveEnd !
   60 SetTargetFPS
   begin
      mouse@ startP 10e CheckCollisionPointCircle
      MOUSE_BUTTON_LEFT IsMouseButtonDown and if true moveStart ! then
      mouse@ endP 10e CheckCollisionPointCircle
      MOUSE_BUTTON_LEFT IsMouseButtonDown and if true moveEnd ! then
      moveStart @ if
         mouse@ startP 8 move
         MOUSE_BUTTON_LEFT IsMouseButtonReleased if false moveStart ! then
      then
      moveEnd @ if
         mouse@ endP 8 move
         MOUSE_BUTTON_LEFT IsMouseButtonReleased if false moveEnd ! then
      then
      BeginDrawing
         RAYWHITE ClearBackground
         z" MOVE START-END POINTS WITH MOUSE" 15 20 20 GRAY DrawText
         startP endP 4e BLUE DrawLineBezier
         startP  mouse@ startP 10e CheckCollisionPointCircle if 14e else 8e then
            moveStart @ if RED else BLUE then DrawCircleV
         endP  mouse@ endP 10e CheckCollisionPointCircle if 14e else 8e then
            moveEnd @ if RED else BLUE then DrawCircleV
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
