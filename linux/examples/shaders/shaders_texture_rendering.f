\ Port of raylib examples/shaders/shaders_texture_rendering.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE shd 32 ALLOT
CREATE target 64 ALLOT
CREATE seconds 4 ALLOT
VARIABLE timeLoc

: example
   screenWidth screenHeight z" raylib [shaders] example - texture rendering" InitWindow
   shd 0 z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/cubes_panning.fs" LoadShader drop
   target screenWidth screenHeight LoadRenderTexture drop
   shd z" time" GetShaderLocation timeLoc !
   0e seconds sf!
   60 SetTargetFPS
   begin
      GetFrameTime seconds sf@ f+ seconds sf!
      shd timeLoc @ seconds SHADER_UNIFORM_FLOAT SetShaderValue
      target BeginTextureMode
         BLACK ClearBackground
         shd BeginShaderMode
            0 0 screenWidth screenHeight WHITE DrawRectangle
         EndShaderMode
      EndTextureMode
      BeginDrawing
         RAYWHITE ClearBackground
         0e 0e target rtex.w s>f target rtex.h s>f reca Rectangle!
         0e 0e v2a Vector2!
         target rtex reca v2a WHITE DrawTextureRec
         z" cubes panning shader" 10 10 20 DARKGRAY DrawText
      EndDrawing
   WindowShouldClose until
   shd UnloadShader
   target UnloadRenderTexture
   CloseWindow ;

example-end
