\ Port of raylib examples/shaders/shaders_mandelbrot_set.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE shd 32 ALLOT
CREATE target 64 ALLOT
CREATE offset 8 ALLOT
CREATE zoom 4 ALLOT
VARIABLE zoomLoc
VARIABLE offsetLoc

: example
   screenWidth screenHeight z" raylib [shaders] example - mandelbrot set" InitWindow
   shd 0 z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/mandelbrot_set.fs" LoadShader drop
   target screenWidth screenHeight LoadRenderTexture drop
   0e 0e offset Vector2!
   0.5e zoom sf!
   shd z" zoom" GetShaderLocation zoomLoc !
   shd z" offset" GetShaderLocation offsetLoc !
   60 SetTargetFPS
   begin
      KEY_RIGHT IsKeyPressed if zoom sf@ 1.01e f* zoom sf! then
      KEY_LEFT IsKeyPressed if zoom sf@ 1.01e f/ zoom sf! then
      shd zoomLoc @ zoom SHADER_UNIFORM_FLOAT SetShaderValue
      shd offsetLoc @ offset SHADER_UNIFORM_VEC2 SetShaderValue
      target BeginTextureMode BLACK ClearBackground EndTextureMode
      BeginDrawing
         BLACK ClearBackground
         shd BeginShaderMode
            0e 0e target rtex.w s>f target rtex.h s>f fnegate reca Rectangle!
            0e 0e v2a Vector2!
            target rtex reca v2a WHITE DrawTextureRec
         EndShaderMode
         z" LEFT/RIGHT to zoom" 10 10 10 RAYWHITE DrawText
      EndDrawing
   WindowShouldClose until
   shd UnloadShader
   target UnloadRenderTexture
   CloseWindow ;

example-end
