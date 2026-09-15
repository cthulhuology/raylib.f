\ Port of raylib examples/shapes/shapes_kaleidoscope.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

VARIABLE symmetry
FVARIABLE kangle
3e fconstant thickness
CREATE prevMouse 8 ALLOT
CREATE offset 8 ALLOT
CREATE camera 24 ALLOT
CREATE scaleV 8 ALLOT
CREATE lineStart 8 ALLOT
CREATE lineEnd 8 ALLOT
CREATE reflS 8 ALLOT
CREATE reflE 8 ALLOT

: example
   screenWidth screenHeight z" raylib [shapes] example - kaleidoscope" InitWindow
   6 symmetry !
   360e symmetry @ s>f f/ kangle f!
   60 SetTargetFPS
   screenWidth 2/ s>f screenHeight 2/ s>f offset Vector2!
   offset camera 8 move
   0e 0e camera 8 + Vector2!
   0e camera 16 + sf!
   1e camera 20 + sf!
   1e -1e scaleV Vector2!
   mouse@ prevMouse 8 move
   BeginDrawing BLACK ClearBackground EndDrawing
   begin
      mouse@ offset lineStart Vector2Subtract drop
      prevMouse offset lineEnd Vector2Subtract drop
      BeginDrawing
         camera BeginMode2D
            MOUSE_BUTTON_LEFT IsMouseButtonDown if
               symmetry @ 0 do
                  lineStart dup kangle f@ deg>rad Vector2Rotate drop
                  lineEnd dup kangle f@ deg>rad Vector2Rotate drop
                  lineStart lineEnd thickness WHITE DrawLineEx
                  lineStart scaleV reflS Vector2Multiply drop
                  lineEnd scaleV reflE Vector2Multiply drop
                  reflS reflE thickness WHITE DrawLineEx
               loop
            then
            mouse@ prevMouse 8 move
         EndMode2D
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
