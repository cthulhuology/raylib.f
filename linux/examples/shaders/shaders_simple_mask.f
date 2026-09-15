\ Port of raylib examples/shaders/shaders_simple_mask.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

Camera: camera
   0e 1e 2e :Camera.position
   0e 0e 0e :Camera.target
   0e 1e 0e :Camera.up
   45e      :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

CREATE mesh1 128 ALLOT
CREATE mesh2 128 ALLOT
CREATE mesh3 128 ALLOT
CREATE mdl1 128 ALLOT
CREATE mdl2 128 ALLOT
CREATE mdl3 128 ALLOT
CREATE shd 32 ALLOT
CREATE texDiffuse 32 ALLOT
CREATE texMask 32 ALLOT
CREATE frames 4 ALLOT
0e 0e 0e Vector3: origin3
VARIABLE shaderFrame

: example
   0 frames !
   screenWidth screenHeight z" raylib [shaders] example - simple mask" InitWindow
   mesh1 0.3e 1e 16 32 GenMeshTorus drop
   mdl1 mesh1 LoadModelFromMesh drop
   mesh2 0.8e 0.8e 0.8e GenMeshCube drop
   mdl2 mesh2 LoadModelFromMesh drop
   mesh3 1e 16 16 GenMeshSphere drop
   mdl3 mesh3 LoadModelFromMesh drop
   shd 0 z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/mask.fs" LoadShader drop
   texDiffuse z" /home/dave/Code/raylib/examples/shaders/resources/plasma.png" LoadTexture drop
   texMask z" /home/dave/Code/raylib/examples/shaders/resources/mask.png" LoadTexture drop
   mdl1 texDiffuse set-diffuse
   mdl2 texDiffuse set-diffuse
   mdl1 mdl.materials MATERIAL_MAP_EMISSION texMask SetMaterialTexture
   mdl2 mdl.materials MATERIAL_MAP_EMISSION texMask SetMaterialTexture
   shd z" mask" GetShaderLocation shd SHADER_LOC_MAP_EMISSION shd-loc!
   shd z" frame" GetShaderLocation shaderFrame !
   mdl1 shd set-mat-shader
   mdl2 shd set-mat-shader
   DisableCursor
   60 SetTargetFPS
   begin
      camera CAMERA_FREE UpdateCamera
      1 frames +!
      frames @ set-ival drop
      shd shaderFrame @ ival SHADER_UNIFORM_INT SetShaderValue
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D
            mdl1 origin3 1e WHITE DrawModel
            mdl2 origin3 1e WHITE DrawModel
            mdl3 origin3 0.5e DARKBLUE DrawModel
            10 1e DrawGrid
         EndMode3D
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   shd UnloadShader
   texDiffuse UnloadTexture
   texMask UnloadTexture
   mdl1 UnloadModel
   mdl2 UnloadModel
   mdl3 UnloadModel
   CloseWindow ;

example-end
