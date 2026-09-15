\ Port of raylib examples/shaders/shaders_ascii_rendering.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE fudesumi 32 ALLOT
CREATE raysan 32 ALLOT
CREATE shd 32 ALLOT
CREATE target 64 ALLOT
CREATE fontSize 4 ALLOT
CREATE resolution 8 ALLOT
CREATE circlePos 8 ALLOT
CREATE circleSpeed 4 ALLOT
VARIABLE fontSizeLoc

: example
   screenWidth screenHeight z" raylib [shaders] example - ascii rendering" InitWindow
   fudesumi z" /home/dave/Code/raylib/examples/shaders/resources/fudesumi.png" LoadTexture drop
   raysan z" /home/dave/Code/raylib/examples/shaders/resources/raysan.png" LoadTexture drop
   shd 0 z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/ascii.fs" LoadShader drop
   9e fontSize sf!
   screenWidth s>f screenHeight s>f resolution Vector2!
   shd dup z" resolution" GetShaderLocation resolution SHADER_UNIFORM_VEC2 SetShaderValue
   shd z" fontSize" GetShaderLocation fontSizeLoc !
   40e screenHeight s>f 0.5e f* circlePos Vector2!
   1e circleSpeed sf!
   target screenWidth screenHeight LoadRenderTexture drop
   60 SetTargetFPS
   begin
      circlePos v2x circleSpeed sf@ f+ circlePos v2y circlePos Vector2!
      circlePos v2x 200e f> circlePos v2x 40e f< or if circleSpeed sf@ fnegate circleSpeed sf! then
      KEY_LEFT IsKeyPressed fontSize sf@ 9e f> and if fontSize sf@ 1e f- fontSize sf! then
      KEY_RIGHT IsKeyPressed fontSize sf@ 15e f< and if fontSize sf@ 1e f+ fontSize sf! then
      shd fontSizeLoc @ fontSize SHADER_UNIFORM_FLOAT SetShaderValue
      target BeginTextureMode
         BLACK ClearBackground
         fudesumi 0 0 WHITE DrawTexture
         raysan circlePos WHITE DrawTextureV
      EndTextureMode
      BeginDrawing
         BLACK ClearBackground
         shd BeginShaderMode
            0e 0e target rtex.w s>f target rtex.h s>f fnegate reca Rectangle!
            0e 0e v2a Vector2!
            target rtex reca v2a WHITE DrawTextureRec
         EndShaderMode
         z" LEFT/RIGHT change font size" 10 10 10 RAYWHITE DrawText
      EndDrawing
   WindowShouldClose until
   shd UnloadShader
   fudesumi UnloadTexture
   raysan UnloadTexture
   target UnloadRenderTexture
   CloseWindow ;

example-end
