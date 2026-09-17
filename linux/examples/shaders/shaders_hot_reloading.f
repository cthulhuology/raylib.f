\ Port of raylib examples/shaders/shaders_hot_reloading.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE shd 32 ALLOT
CREATE target 64 ALLOT
CREATE mousePos 8 ALLOT
CREATE seconds 4 ALLOT
VARIABLE timeLoc
VARIABLE mouseLoc
VARIABLE auto
VARIABLE lastMod

z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/reload.fs" CONSTANT fs-path

: reload
   shd UnloadShader
   shd 0 fs-path LoadShader drop
   \ If load failed raylib returns the default shader; skip updating locs in that case
   shd l@ rlGetShaderIdDefault = if exit then
   shd z" time" GetShaderLocation timeLoc !
   shd z" mouse" GetShaderLocation mouseLoc ! ;

: example
   true auto !
   screenWidth screenHeight z" raylib [shaders] example - hot reloading" InitWindow
   shd 0 fs-path LoadShader drop
   target screenWidth screenHeight LoadRenderTexture drop
   shd z" time" GetShaderLocation timeLoc !
   shd z" mouse" GetShaderLocation mouseLoc !
   fs-path GetFileModTime lastMod !
   0e seconds sf!
   60 SetTargetFPS
   begin
      GetFrameTime seconds sf@ f+ seconds sf!
      mouse@ mousePos 8 move
      KEY_A IsKeyPressed if auto @ 0= auto ! then
      auto @ if
         fs-path GetFileModTime lastMod @ <> if reload fs-path GetFileModTime lastMod ! then
      else
         KEY_R IsKeyPressed if reload then
      then
      shd timeLoc @ seconds SHADER_UNIFORM_FLOAT SetShaderValue
      shd mouseLoc @ mousePos SHADER_UNIFORM_VEC2 SetShaderValue
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
         z" PRESS [R] to reload shader  [A] auto" 10 10 20 DARKGRAY DrawText
      EndDrawing
   WindowShouldClose until
   shd UnloadShader
   target UnloadRenderTexture
   CloseWindow ;

example-end
