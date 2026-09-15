\ Port of raylib examples/core/core_render_texture.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
300 CONSTANT renderTextureWidth
300 CONSTANT renderTextureHeight

CREATE target 44 ALLOT
CREATE ballPosition 8 ALLOT
CREATE ballSpeed 8 ALLOT
20 CONSTANT ballRadius
0e fvalue rotation
CREATE src 16 ALLOT
CREATE dst 16 ALLOT
CREATE origin 8 ALLOT

: Rectangle! ( a F: x y w h -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;

: example
   screenWidth screenHeight z" raylib [core] example - render texture" InitWindow
   target renderTextureWidth renderTextureHeight LoadRenderTexture drop
   renderTextureWidth 2/ s>f  renderTextureHeight 2/ s>f  ballPosition Vector2!
   5e 4e ballSpeed Vector2!
   0e to rotation
   60 SetTargetFPS
   begin
      ballPosition v2x ballSpeed v2x f+  ballPosition v2y ballSpeed v2y f+  ballPosition Vector2!
      ballPosition v2x renderTextureWidth ballRadius - s>f f>=
      ballPosition v2x ballRadius s>f f<= or if
         ballSpeed v2x fnegate ballSpeed v2y ballSpeed Vector2!
      then
      ballPosition v2y renderTextureHeight ballRadius - s>f f>=
      ballPosition v2y ballRadius s>f f<= or if
         ballSpeed v2x ballSpeed v2y fnegate ballSpeed Vector2!
      then
      rotation 0.5e f+ to rotation
      target BeginTextureMode
         SKYBLUE ClearBackground
         0 0 20 20 RED DrawRectangle
         ballPosition ballRadius s>f MAROON DrawCircleV
      EndTextureMode
      BeginDrawing
         RAYWHITE ClearBackground
         0e 0e
         target 8 + l@ s>f
         target 12 + l@ s>f fnegate
         src Rectangle!
         screenWidth 2/ s>f  screenHeight 2/ s>f
         target 8 + l@ s>f  target 12 + l@ s>f
         dst Rectangle!
         target 8 + l@ s>f 2e f/  target 12 + l@ s>f 2e f/  origin Vector2!
         target 4 + src dst origin rotation WHITE DrawTexturePro
         z" DRAWING BOUNCING BALL INSIDE RENDER TEXTURE!" 10 screenHeight 40 - 20 BLACK DrawText
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
