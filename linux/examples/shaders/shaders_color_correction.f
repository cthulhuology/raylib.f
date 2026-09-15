\ Port of raylib examples/shaders/shaders_color_correction.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE tex 32 ALLOT
CREATE shd 32 ALLOT

: example
   screenWidth screenHeight z" raylib [shaders] example - color correction" InitWindow
   tex z" /home/dave/Code/raylib/examples/shaders/resources/parrots.png" LoadTexture drop
   shd 0 z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/color_correction.fs" LoadShader drop
   60 SetTargetFPS
   begin
      BeginDrawing
         RAYWHITE ClearBackground
         shd BeginShaderMode
            tex 0 0 WHITE DrawTexture
         EndShaderMode
         z" Color correction shader" 10 10 20 DARKGRAY DrawText
      EndDrawing
   WindowShouldClose until
   shd UnloadShader
   tex UnloadTexture
   CloseWindow ;

example-end
