\ Port of raylib examples/shaders/shaders_texture_tiling.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

Camera: camera
   4e 4e 4e :Camera.position
   0e 0.5e 0e :Camera.target
   0e 1e 0e :Camera.up
   45e      :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

CREATE mesh 128 ALLOT
CREATE mdl 128 ALLOT
CREATE tex 32 ALLOT
CREATE shd 32 ALLOT
CREATE tiling 8 ALLOT
0e 0e 0e Vector3: position

: example
   screenWidth screenHeight z" raylib [shaders] example - texture tiling" InitWindow
   mesh 1e 1e 1e GenMeshCube drop
   mdl mesh LoadModelFromMesh drop
   tex z" /home/dave/Code/raylib/examples/shaders/resources/cubicmap_atlas.png" LoadTexture drop
   mdl tex set-diffuse
   3e 3e tiling Vector2!
   shd 0 z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/tiling.fs" LoadShader drop
   shd dup z" tiling" GetShaderLocation tiling SHADER_UNIFORM_VEC2 SetShaderValue
   mdl shd set-mat-shader
   DisableCursor
   60 SetTargetFPS
   begin
      camera CAMERA_FREE UpdateCamera
      KEY_Z IsKeyPressed if 0e 0.5e 0e camera Camera.target Vector3! then
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D
            mdl position 1e WHITE DrawModel
            10 1e DrawGrid
         EndMode3D
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   shd UnloadShader
   tex UnloadTexture
   mdl UnloadModel
   CloseWindow ;

example-end
