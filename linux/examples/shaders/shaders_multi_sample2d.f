\ Port of raylib examples/shaders/shaders_multi_sample2d.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE tex1 32 ALLOT
CREATE tex2 32 ALLOT
CREATE shd 32 ALLOT
CREATE divider 4 ALLOT
VARIABLE divLoc

: example
   screenWidth screenHeight z" raylib [shaders] example - multi sample2d" InitWindow
   tex1 z" /home/dave/Code/raylib/examples/shaders/resources/parrots.png" LoadTexture drop
   tex2 z" /home/dave/Code/raylib/examples/shaders/resources/cat.png" LoadTexture drop
   shd 0 z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/color_mix.fs" LoadShader drop
   0.5e divider sf!
   shd z" divider" GetShaderLocation divLoc !
   60 SetTargetFPS
   begin
      GetMouseX s>f screenWidth s>f f/ 0e fmax 1e fmin divider sf!
      shd divLoc @ divider SHADER_UNIFORM_FLOAT SetShaderValue
      BeginDrawing
         RAYWHITE ClearBackground
         shd BeginShaderMode
            tex1 0 0 WHITE DrawTexture
         EndShaderMode
         z" Move mouse to mix two textures (second sampler simplified)" 10 10 10 DARKGRAY DrawText
      EndDrawing
   WindowShouldClose until
   shd UnloadShader
   tex1 UnloadTexture
   tex2 UnloadTexture
   CloseWindow ;

example-end
