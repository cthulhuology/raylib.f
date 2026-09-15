\ Port of raylib examples/shaders/shaders_texture_outline.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE tex 32 ALLOT
CREATE shd 32 ALLOT
CREATE outlineSize 4 ALLOT
CREATE outlineColor 16 ALLOT
CREATE textureSize 8 ALLOT
VARIABLE sizeLoc

: example
   screenWidth screenHeight z" raylib [shaders] example - texture outline" InitWindow
   tex z" /home/dave/Code/raylib/examples/shaders/resources/fudesumi.png" LoadTexture drop
   shd 0 z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/outline.fs" LoadShader drop
   2e outlineSize sf!
   1e 0e 0e 1e outlineColor Vector4!
   tex tex.w s>f tex tex.h s>f textureSize Vector2!
   shd z" outlineSize" GetShaderLocation sizeLoc !
   shd sizeLoc @ outlineSize SHADER_UNIFORM_FLOAT SetShaderValue
   shd dup z" outlineColor" GetShaderLocation outlineColor SHADER_UNIFORM_VEC4 SetShaderValue
   shd dup z" textureSize" GetShaderLocation textureSize SHADER_UNIFORM_VEC2 SetShaderValue
   60 SetTargetFPS
   begin
      GetMouseWheelMove outlineSize sf@ f+ 1e fmax outlineSize sf!
      shd sizeLoc @ outlineSize SHADER_UNIFORM_FLOAT SetShaderValue
      BeginDrawing
         RAYWHITE ClearBackground
         shd BeginShaderMode
            tex GetScreenWidth 2/ tex tex.w 2/ -  -30 WHITE DrawTexture
         EndShaderMode
         z" Shader-based texture outline" 10 10 20 GRAY DrawText
         z" Scroll mouse wheel to change outline size" 10 72 20 GRAY DrawText
         710 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   shd UnloadShader
   tex UnloadTexture
   CloseWindow ;

example-end
