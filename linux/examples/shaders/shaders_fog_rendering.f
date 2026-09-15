\ Port of raylib examples/shaders/shaders_fog_rendering.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

Camera: camera
   2e 2e 6e :Camera.position
   0e 0.5e 0e :Camera.target
   0e 1e 0e :Camera.up
   45e      :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

CREATE shd 32 ALLOT
CREATE meshP 128 ALLOT
CREATE meshT 128 ALLOT
CREATE mdlP 128 ALLOT
CREATE mdlT 128 ALLOT
CREATE tex 32 ALLOT
CREATE fogD 4 ALLOT
0e 0e 0e Vector3: origin3
VARIABLE fogLoc

: example
   lights-reset
   FLAG_MSAA_4X_HINT SetConfigFlags
   screenWidth screenHeight z" raylib [shaders] example - fog rendering" InitWindow
   shd z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/lighting.vs" z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/fog.fs" LoadShader drop
   shd z" viewPos" GetShaderLocation shd SHADER_LOC_VECTOR_VIEW shd-loc!
   0.2e 0.2e 0.2e 1e fvec4 Vector4!
   shd dup z" ambient" GetShaderLocation fvec4 SHADER_UNIFORM_VEC4 SetShaderValue
   0.125e fogD sf!
   shd z" fogDensity" GetShaderLocation fogLoc !
   shd fogLoc @ fogD SHADER_UNIFORM_FLOAT SetShaderValue
   meshP 10e 10e 3 3 GenMeshPlane drop
   mdlP meshP LoadModelFromMesh drop
   meshT 0.4e 1e 16 32 GenMeshTorus drop
   mdlT meshT LoadModelFromMesh drop
   tex z" /home/dave/Code/raylib/examples/shaders/resources/texel_checker.png" LoadTexture drop
   mdlP tex set-diffuse
   mdlT tex set-diffuse
   mdlP shd set-mat-shader
   mdlT shd set-mat-shader
   LIGHT_POINT 0e 2e 6e v3a Vector3! v3a v3b Vector3Zero WHITE shd CreateLight drop
   60 SetTargetFPS
   begin
      camera CAMERA_ORBITAL UpdateCamera
      KEY_UP down if fogD sf@ 0.001e f+ 1e fmin fogD sf! then
      KEY_DOWN down if fogD sf@ 0.001e f- 0e fmax fogD sf! then
      shd fogLoc @ fogD SHADER_UNIFORM_FLOAT SetShaderValue
      camera fvec3 12 move
      shd shd SHADER_LOC_VECTOR_VIEW shd-loc@ fvec3 SHADER_UNIFORM_VEC3 SetShaderValue
      shd 0 light[] UpdateLightValues
      BeginDrawing
         GRAY ClearBackground
         camera BeginMode3D
            mdlP origin3 1e WHITE DrawModel
            mdlT origin3 1e WHITE DrawModel
            10 1e DrawGrid
         EndMode3D
         z" UP/DOWN to change fog density" 10 40 20 RAYWHITE DrawText
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   shd UnloadShader
   tex UnloadTexture
   mdlP UnloadModel
   mdlT UnloadModel
   CloseWindow ;

example-end
