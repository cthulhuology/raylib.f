\ Port of raylib examples/models/models_skybox_rendering.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

Camera: camera
   1e 1e 1e :Camera.position
   4e 1e 4e :Camera.target
   0e 1e 0e :Camera.up
   45e      :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

CREATE mesh 128 ALLOT
CREATE skybox 128 ALLOT
CREATE img 32 ALLOT
CREATE tex 32 ALLOT
CREATE shd 32 ALLOT
0e 0e 0e Vector3: origin3

: example
   screenWidth screenHeight z" raylib [models] example - skybox rendering" InitWindow
   mesh 1e 1e 1e GenMeshCube drop
   skybox mesh LoadModelFromMesh drop
   shd z" /home/dave/Code/raylib/examples/models/resources/shaders/glsl330/skybox.vs"
       z" /home/dave/Code/raylib/examples/models/resources/shaders/glsl330/skybox.fs" LoadShader drop
   skybox shd set-mat-shader
   7 set-ival
   shd dup z" environmentMap" GetShaderLocation ival SHADER_UNIFORM_INT SetShaderValue
   0 set-ival
   shd dup z" doGamma" GetShaderLocation ival SHADER_UNIFORM_INT SetShaderValue
   shd dup z" vflipped" GetShaderLocation ival SHADER_UNIFORM_INT SetShaderValue
   img z" /home/dave/Code/raylib/examples/models/resources/skybox.png" LoadImage drop
   tex img CUBEMAP_LAYOUT_AUTO_DETECT LoadTextureCubemap drop
   img UnloadImage
   skybox mdl.materials MATERIAL_MAP_CUBEMAP tex SetMaterialTexture
   DisableCursor
   60 SetTargetFPS
   begin
      camera CAMERA_FIRST_PERSON UpdateCamera
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D
            rlDisableBackfaceCulling
            rlDisableDepthMask
               skybox origin3 16e WHITE DrawModel
            rlEnableBackfaceCulling
            rlEnableDepthMask
            10 1e DrawGrid
         EndMode3D
         z" Skybox simplified (no HDR cubemap blit)" 10 10 20 DARKGRAY DrawText
         10 40 DrawFPS
      EndDrawing
   WindowShouldClose until
   tex UnloadTexture
   shd UnloadShader
   skybox UnloadModel
   CloseWindow ;

example-end
