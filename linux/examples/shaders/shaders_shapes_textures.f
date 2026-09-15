\ Port of raylib examples/shaders/shaders_shapes_textures.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE fudesumi 32 ALLOT
CREATE shd 32 ALLOT
430e 80e Vector2: t1
370e 150e Vector2: t2
490e 150e Vector2: t3
430e 160e Vector2: u1
410e 230e Vector2: u2
450e 230e Vector2: u3
430e 320e Vector2: poly

: example
   screenWidth screenHeight z" raylib [shaders] example - shapes textures" InitWindow
   fudesumi z" /home/dave/Code/raylib/examples/shaders/resources/fudesumi.png" LoadTexture drop
   shd 0 z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/grayscale.fs" LoadShader drop
   60 SetTargetFPS
   begin
      BeginDrawing
         RAYWHITE ClearBackground
         z" USING DEFAULT SHADER" 20 40 10 RED DrawText
         80 120 35e DARKBLUE DrawCircle
         80 220 60e GREEN SKYBLUE DrawCircleGradient
         80 340 80e DARKBLUE DrawCircleLines
         shd BeginShaderMode
            z" USING CUSTOM SHADER" 190 40 10 RED DrawText
            190 90 120 60 RED DrawRectangle
            160 170 180 130 MAROON GOLD DrawRectangleGradientH
            210 320 80 60 ORANGE DrawRectangleLines
         EndShaderMode
         z" USING DEFAULT SHADER" 370 40 10 RED DrawText
         t1 t2 t3 VIOLET DrawTriangle
         u1 u2 u3 DARKBLUE DrawTriangleLines
         poly 6 80e 0e BROWN DrawPoly
         shd BeginShaderMode
            fudesumi 500 -30 WHITE DrawTexture
         EndShaderMode
         z" (c) Fudesumi sprite by Eiden Marsal" 380 screenHeight 20 - 10 GRAY DrawText
      EndDrawing
   WindowShouldClose until
   shd UnloadShader
   fudesumi UnloadTexture
   CloseWindow ;

example-end
