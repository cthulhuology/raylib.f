\ Port of raylib examples/shaders/shaders_spotlight_rendering.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE tex 32 ALLOT
CREATE shd 32 ALLOT
CREATE mousePos 8 ALLOT
VARIABLE posLoc

: example
   screenWidth screenHeight z" raylib [shaders] example - spotlight rendering" InitWindow
   tex z" /home/dave/Code/raylib/examples/shaders/resources/raysan.png" LoadTexture drop
   shd 0 z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/spotlight.fs" LoadShader drop
   shd z" spotlightPos" GetShaderLocation posLoc !
   60 SetTargetFPS
   begin
      mouse@ mousePos 8 move
      shd posLoc @ mousePos SHADER_UNIFORM_VEC2 SetShaderValue
      BeginDrawing
         DARKGRAY ClearBackground
         shd BeginShaderMode
            tex 300 100 WHITE DrawTexture
         EndShaderMode
         z" Move mouse - spotlight follows" 10 10 20 RAYWHITE DrawText
      EndDrawing
   WindowShouldClose until
   shd UnloadShader
   tex UnloadTexture
   CloseWindow ;

example-end
