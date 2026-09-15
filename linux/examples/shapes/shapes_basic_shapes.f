\ Port of raylib examples/shapes/shapes_basic_shapes.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

FVARIABLE rotation

: example
   0e rotation f!
   screenWidth screenHeight z" raylib [shapes] example - basic shapes" InitWindow
   60 SetTargetFPS
   begin
      rotation f@ 0.2e f+ rotation f!
      BeginDrawing
         RAYWHITE ClearBackground
         z" some basic shapes available on raylib" 20 20 20 DARKGRAY DrawText
         screenWidth 5 / 120 35e DARKBLUE DrawCircle
         screenWidth 5 / 220 60e GREEN SKYBLUE DrawCircleGradient
         screenWidth 5 / 340 80e DARKBLUE DrawCircleLines
         screenWidth 5 / 120 25e 20e YELLOW DrawEllipse
         screenWidth 5 / 120 30e 25e YELLOW DrawEllipseLines
         screenWidth 4 / 2 * 60 - 100 120 60 RED DrawRectangle
         screenWidth 4 / 2 * 90 - 170 180 130 MAROON GOLD DrawRectangleGradientH
         screenWidth 4 / 2 * 40 - 320 80 60 ORANGE DrawRectangleLines
         screenWidth s>f 4e f/ 3e f* fdup 80e v2a Vector2!
         fdup 60e f- 150e v2b Vector2!
         60e f+ 150e v2c Vector2!
         v2a v2b v2c VIOLET DrawTriangle
         screenWidth s>f 4e f/ 3e f* fdup 160e v2a Vector2!
         fdup 20e f- 230e v2b Vector2!
         20e f+ 230e v2c Vector2!
         v2a v2b v2c DARKBLUE DrawTriangleLines
         screenWidth s>f 4e f/ 3e f* 330e v2a Vector2!
         v2a 6 80e rotation f@ BROWN DrawPoly
         v2a 6 90e rotation f@ BROWN DrawPolyLines
         v2a 6 85e rotation f@ 6e BEIGE DrawPolyLinesEx
         18 42 screenWidth 18 - 42 BLACK DrawLine
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
