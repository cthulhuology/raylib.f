\ Port of raylib examples/shaders/shaders_basic_lighting.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

Camera: camera
   2e 4e 6e :Camera.position
   0e 0.5e 0e :Camera.target
   0e 1e 0e :Camera.up
   45e      :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

CREATE shd 32 ALLOT
CREATE meshP 128 ALLOT
CREATE meshC 128 ALLOT
CREATE mdlP 128 ALLOT
CREATE mdlC 128 ALLOT
0e 0e 0e Vector3: origin3

: example
   lights-reset
   FLAG_MSAA_4X_HINT SetConfigFlags
   screenWidth screenHeight z" raylib [shaders] example - basic lighting" InitWindow
   shd z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/lighting.vs" z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/lighting.fs" LoadShader drop
   shd z" viewPos" GetShaderLocation shd SHADER_LOC_VECTOR_VIEW shd-loc!
   0.1e 0.1e 0.1e 1e fvec4 Vector4!
   shd dup z" ambient" GetShaderLocation fvec4 SHADER_UNIFORM_VEC4 SetShaderValue
   meshP 10e 10e 3 3 GenMeshPlane drop
   mdlP meshP LoadModelFromMesh drop
   meshC 2e 4e 2e GenMeshCube drop
   mdlC meshC LoadModelFromMesh drop
   mdlP shd set-mat-shader
   mdlC shd set-mat-shader
   LIGHT_POINT -2e 1e -2e v3a Vector3! v3a  v3b Vector3Zero YELLOW shd CreateLight drop
   LIGHT_POINT  2e 1e  2e v3a Vector3! v3a  v3b Vector3Zero RED shd CreateLight drop
   LIGHT_POINT -2e 1e  2e v3a Vector3! v3a  v3b Vector3Zero GREEN shd CreateLight drop
   LIGHT_POINT  2e 1e -2e v3a Vector3! v3a  v3b Vector3Zero BLUE shd CreateLight drop
   60 SetTargetFPS
   begin
      camera CAMERA_ORBITAL UpdateCamera
      camera fvec3 12 move
      shd  shd SHADER_LOC_VECTOR_VIEW shd-loc@  fvec3 SHADER_UNIFORM_VEC3 SetShaderValue
      KEY_Y IsKeyPressed if 0 light[] L.enabled @ 0= 0 light[] L.enabled ! then
      KEY_R IsKeyPressed if 1 light[] L.enabled @ 0= 1 light[] L.enabled ! then
      KEY_G IsKeyPressed if 2 light[] L.enabled @ 0= 2 light[] L.enabled ! then
      KEY_B IsKeyPressed if 3 light[] L.enabled @ 0= 3 light[] L.enabled ! then
      4 0 do shd i light[] UpdateLightValues loop
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D
            mdlP origin3 1e WHITE DrawModel
            mdlC origin3 1e WHITE DrawModel
            4 0 do
               i light[] L.enabled @ if
                  i light[] L.pos 0.2e 8 8 i light[] L.color @ DrawSphereEx
               else
                  i light[] L.pos 0.2e 8 8 i light[] L.color @ 0.3e ColorAlpha DrawSphereWires
               then
            loop
            10 1e DrawGrid
         EndMode3D
         z" Use keys [Y][R][G][B] to toggle lights" 10 40 20 DARKGRAY DrawText
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   shd UnloadShader
   mdlP UnloadModel
   mdlC UnloadModel
   CloseWindow ;

example-end
