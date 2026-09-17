\ Port of raylib examples/shaders/shaders_vertex_displacement.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

Camera: camera
   0e 10e 10e :Camera.position
   0e  0e  0e :Camera.target
   0e  1e  0e :Camera.up
   45e         :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

CREATE shd      32 ALLOT
CREATE img      32 ALLOT
CREATE noiseTex 20 ALLOT
CREATE planeMesh 128 ALLOT
CREATE planeMdl  128 ALLOT

VARIABLE perlinLoc
VARIABLE timeLoc
FVARIABLE elapsed
CREATE timeval 4 ALLOT
0e 0e 0e Vector3: planePos

: example
   FLAG_MSAA_4X_HINT SetConfigFlags
   screenWidth screenHeight z" raylib [shaders] example - vertex displacement" InitWindow

   shd z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/vertex_displacement.vs"
       z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/vertex_displacement.fs"
       LoadShader drop

   \ generate perlin noise texture and bind permanently to sampler slot 1
   img 512 512 0 0 1e GenImagePerlinNoise drop
   noiseTex img LoadTextureFromImage drop
   img UnloadImage

   shd z" perlinNoiseMap" GetShaderLocation perlinLoc !

   shd l@ rlEnableShader
      1 rlActiveTextureSlot
      noiseTex l@ rlEnableTexture
      perlinLoc @ 1 rlSetUniformSampler
   rlDisableShader

   planeMesh 50e 50e 50 50 GenMeshPlane drop
   planeMdl planeMesh LoadModelFromMesh drop
   planeMdl shd set-mat-shader

   shd z" time" GetShaderLocation timeLoc !
   0e elapsed f!

   DisableCursor
   60 SetTargetFPS
   begin
      camera CAMERA_FREE UpdateCamera
      GetFrameTime elapsed f@ f+ elapsed f!
      elapsed f@ timeval sf!
      shd timeLoc @ timeval SHADER_UNIFORM_FLOAT SetShaderValue
      BeginDrawing
         BLACK ClearBackground
         camera BeginMode3D
            planeMdl planePos 1e WHITE DrawModel
         EndMode3D
         z" vertex displacement shader (perlin noise)" 10 10 20 RAYWHITE DrawText
         10 40 DrawFPS
      EndDrawing
   WindowShouldClose until

   planeMdl UnloadModel
   noiseTex UnloadTexture
   shd UnloadShader
   CloseWindow ;

example-end
