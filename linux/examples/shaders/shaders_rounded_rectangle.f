\ Port of raylib examples/shaders/shaders_rounded_rectangle.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE shd 32 ALLOT
CREATE recSize 8 ALLOT
CREATE recScale 4 ALLOT
CREATE recRadius 4 ALLOT
CREATE recColor 16 ALLOT
CREATE recShadow 16 ALLOT
CREATE shadowOff 8 ALLOT
CREATE shadowRadius 4 ALLOT

: example
   screenWidth screenHeight z" raylib [shaders] example - rounded rectangle" InitWindow
   shd 0 z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/rounded_rectangle.fs" LoadShader drop
   256e 64e recSize Vector2!
   1e recScale sf!
   0.2e recRadius sf!
   1e 0e 0e 1e recColor Vector4!
   0e 0e 0e 0.5e recShadow Vector4!
   0e 8e shadowOff Vector2!
   0.1e shadowRadius sf!
   shd dup z" rectangleSize" GetShaderLocation recSize SHADER_UNIFORM_VEC2 SetShaderValue
   shd dup z" rectangleRadius" GetShaderLocation recRadius SHADER_UNIFORM_FLOAT SetShaderValue
   60 SetTargetFPS
   begin
      BeginDrawing
         RAYWHITE ClearBackground
         shd BeginShaderMode
            200 180 400 80 RED DrawRectangle
         EndShaderMode
         z" Rounded rectangle shader" 10 10 20 DARKGRAY DrawText
      EndDrawing
   WindowShouldClose until
   shd UnloadShader
   CloseWindow ;

example-end
