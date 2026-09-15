\ Port of raylib examples/shaders/shaders_normalmap_rendering.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

Camera: camera
   4e 4e 4e :Camera.position
   0e 1e 0e :Camera.target
   0e 1e 0e :Camera.up
   45e      :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

CREATE shd 32 ALLOT
CREATE mesh 128 ALLOT
CREATE mdl 128 ALLOT
0e 0e 0e Vector3: position

: example
   screenWidth screenHeight z" raylib [shaders] example - normalmap rendering" InitWindow
   shd z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/normalmap.vs" z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/normalmap.fs" LoadShader drop

   mesh 2e 2e 2e GenMeshCube drop
   mdl mesh LoadModelFromMesh drop
   mdl shd set-mat-shader
   60 SetTargetFPS
   begin
      camera CAMERA_ORBITAL UpdateCamera
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D
            mdl position 1e WHITE DrawModel
            10 1e DrawGrid
         EndMode3D
         z" Normal map shader on cube" 10 10 20 DARKGRAY DrawText
         10 40 DrawFPS
      EndDrawing
   WindowShouldClose until
   shd UnloadShader
   mdl UnloadModel
   CloseWindow ;

example-end
