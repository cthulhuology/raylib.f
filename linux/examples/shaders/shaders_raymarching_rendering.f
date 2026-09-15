\ Port of raylib examples/shaders/shaders_raymarching_rendering.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE shd 32 ALLOT
CREATE target 64 ALLOT
CREATE viewEye 16 ALLOT
CREATE viewCenter 16 ALLOT
CREATE runTime 4 ALLOT
CREATE resolution 8 ALLOT
VARIABLE eyeLoc
VARIABLE centerLoc
VARIABLE timeLoc

: example
   screenWidth screenHeight z" raylib [shaders] example - raymarching rendering" InitWindow
   shd 0 z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/raymarching.fs" LoadShader drop
   target screenWidth screenHeight LoadRenderTexture drop
   2.5e 2.5e 3e viewEye Vector3!
   0e 0e 0.5e viewCenter Vector3!
   0e runTime sf!
   screenWidth s>f screenHeight s>f resolution Vector2!
   shd z" viewEye" GetShaderLocation eyeLoc !
   shd z" viewCenter" GetShaderLocation centerLoc !
   shd z" runTime" GetShaderLocation timeLoc !
   shd dup z" resolution" GetShaderLocation resolution SHADER_UNIFORM_VEC2 SetShaderValue
   60 SetTargetFPS
   begin
      GetFrameTime runTime sf@ f+ runTime sf!
      shd eyeLoc @ viewEye SHADER_UNIFORM_VEC3 SetShaderValue
      shd centerLoc @ viewCenter SHADER_UNIFORM_VEC3 SetShaderValue
      shd timeLoc @ runTime SHADER_UNIFORM_FLOAT SetShaderValue
      target BeginTextureMode BLACK ClearBackground EndTextureMode
      BeginDrawing
         BLACK ClearBackground
         shd BeginShaderMode
            0e 0e target rtex.w s>f target rtex.h s>f fnegate reca Rectangle!
            0e 0e v2a Vector2!
            target rtex reca v2a WHITE DrawTextureRec
         EndShaderMode
         z" raymarching (camera uniforms static)" 10 10 10 RAYWHITE DrawText
         10 40 DrawFPS
      EndDrawing
   WindowShouldClose until
   shd UnloadShader
   target UnloadRenderTexture
   CloseWindow ;

example-end
