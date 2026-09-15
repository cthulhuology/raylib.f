\ Port of raylib examples/shaders/shaders_texture_waves.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE tex 32 ALLOT
CREATE shd 32 ALLOT
VARIABLE secondsLoc
CREATE seconds 4 ALLOT
CREATE freqX 4 ALLOT
CREATE freqY 4 ALLOT
CREATE ampX 4 ALLOT
CREATE ampY 4 ALLOT
CREATE speedX 4 ALLOT
CREATE speedY 4 ALLOT

: example
   screenWidth screenHeight z" raylib [shaders] example - texture waves" InitWindow
   tex z" /home/dave/Code/raylib/examples/shaders/resources/space.png" LoadTexture drop
   shd 0 z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/wave.fs" LoadShader drop
   shd z" seconds" GetShaderLocation secondsLoc !
   25e freqX sf! 25e freqY sf! 5e ampX sf! 5e ampY sf! 8e speedX sf! 8e speedY sf!
   GetScreenWidth s>f GetScreenHeight s>f fvec2 Vector2!
   shd dup z" size" GetShaderLocation fvec2 SHADER_UNIFORM_VEC2 SetShaderValue
   shd dup z" freqX" GetShaderLocation freqX SHADER_UNIFORM_FLOAT SetShaderValue
   shd dup z" freqY" GetShaderLocation freqY SHADER_UNIFORM_FLOAT SetShaderValue
   shd dup z" ampX" GetShaderLocation ampX SHADER_UNIFORM_FLOAT SetShaderValue
   shd dup z" ampY" GetShaderLocation ampY SHADER_UNIFORM_FLOAT SetShaderValue
   shd dup z" speedX" GetShaderLocation speedX SHADER_UNIFORM_FLOAT SetShaderValue
   shd dup z" speedY" GetShaderLocation speedY SHADER_UNIFORM_FLOAT SetShaderValue
   0e seconds sf!
   60 SetTargetFPS
   begin
      GetFrameTime seconds sf@ f+ seconds sf!
      shd secondsLoc @ seconds SHADER_UNIFORM_FLOAT SetShaderValue
      BeginDrawing
         RAYWHITE ClearBackground
         shd BeginShaderMode
            tex 0 0 WHITE DrawTexture
            tex tex tex.w 0 WHITE DrawTexture
         EndShaderMode
      EndDrawing
   WindowShouldClose until
   shd UnloadShader
   tex UnloadTexture
   CloseWindow ;

example-end
