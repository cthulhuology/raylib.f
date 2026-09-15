\ Port of raylib examples/shaders/shaders_model_shader.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

Camera: camera
   4e 4e 4e :Camera.position
   0e 1e -1e :Camera.target
   0e 1e 0e :Camera.up
   45e      :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

CREATE mdl 128 ALLOT
CREATE tex 32 ALLOT
CREATE shd 32 ALLOT
0e 0e 0e Vector3: position

: example
   FLAG_MSAA_4X_HINT SetConfigFlags
   screenWidth screenHeight z" raylib [shaders] example - model shader" InitWindow
   mdl z" /home/dave/Code/raylib/examples/shaders/resources/models/watermill.obj" LoadModel drop
   tex z" /home/dave/Code/raylib/examples/shaders/resources/models/watermill_diffuse.png" LoadTexture drop
   shd 0 z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/grayscale.fs" LoadShader drop
   mdl shd set-mat-shader
   mdl tex set-diffuse
   DisableCursor
   60 SetTargetFPS
   begin
      camera CAMERA_FREE UpdateCamera
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D
            mdl position 0.2e WHITE DrawModel
            10 1e DrawGrid
         EndMode3D
         z" (c) Watermill 3D model by Alberto Cano" screenWidth 210 - screenHeight 20 - 10 GRAY DrawText
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   shd UnloadShader
   tex UnloadTexture
   mdl UnloadModel
   CloseWindow ;

example-end
