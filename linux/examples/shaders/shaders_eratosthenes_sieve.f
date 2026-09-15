\ Port of raylib examples/shaders/shaders_eratosthenes_sieve.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE shd 32 ALLOT
CREATE target 64 ALLOT

: example
   screenWidth screenHeight z" raylib [shaders] example - eratosthenes sieve" InitWindow
   target screenWidth screenHeight LoadRenderTexture drop
   shd 0 z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/eratosthenes.fs" LoadShader drop
   60 SetTargetFPS
   begin
      target BeginTextureMode
         BLACK ClearBackground
         0 0 screenWidth screenHeight BLACK DrawRectangle
      EndTextureMode
      BeginDrawing
         BLACK ClearBackground
         shd BeginShaderMode
            0e 0e target rtex.w s>f target rtex.h s>f fnegate reca Rectangle!
            0e 0e v2a Vector2!
            target rtex reca v2a WHITE DrawTextureRec
         EndShaderMode
      EndDrawing
   WindowShouldClose until
   shd UnloadShader
   target UnloadRenderTexture
   CloseWindow ;

example-end
