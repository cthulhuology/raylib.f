\ Port of raylib examples/shaders/shaders_julia_set.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE shd 32 ALLOT
CREATE target 64 ALLOT
CREATE cval 8 ALLOT
CREATE offset 8 ALLOT
CREATE zoom 4 ALLOT
VARIABLE cLoc
VARIABLE zoomLoc
VARIABLE offsetLoc
VARIABLE points
0e fconstant startingZoom

: example
   screenWidth screenHeight z" raylib [shaders] example - julia set" InitWindow
   shd 0 z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/julia_set.fs" LoadShader drop
   target GetScreenWidth GetScreenHeight LoadRenderTexture drop
   -0.348827e 0.607167e cval Vector2!
   0e 0e offset Vector2!
   0.75e zoom sf!
   shd z" c" GetShaderLocation cLoc !
   shd z" zoom" GetShaderLocation zoomLoc !
   shd z" offset" GetShaderLocation offsetLoc !
   shd cLoc @ cval SHADER_UNIFORM_VEC2 SetShaderValue
   shd zoomLoc @ zoom SHADER_UNIFORM_FLOAT SetShaderValue
   shd offsetLoc @ offset SHADER_UNIFORM_VEC2 SetShaderValue
   60 SetTargetFPS
   begin
      KEY_RIGHT IsKeyPressed if zoom sf@ 1.01e f* zoom sf! then
      KEY_LEFT IsKeyPressed if zoom sf@ 1.01e f/ zoom sf! then
      KEY_ONE IsKeyPressed if -0.348827e 0.607167e cval Vector2! then
      KEY_TWO IsKeyPressed if -0.786268e 0.169728e cval Vector2! then
      KEY_THREE IsKeyPressed if -0.8e 0.156e cval Vector2! then
      shd cLoc @ cval SHADER_UNIFORM_VEC2 SetShaderValue
      shd zoomLoc @ zoom SHADER_UNIFORM_FLOAT SetShaderValue
      shd offsetLoc @ offset SHADER_UNIFORM_VEC2 SetShaderValue
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
         z" LEFT/RIGHT zoom  1-3 points of interest" 10 10 10 RAYWHITE DrawText
      EndDrawing
   WindowShouldClose until
   shd UnloadShader
   target UnloadRenderTexture
   CloseWindow ;

example-end
