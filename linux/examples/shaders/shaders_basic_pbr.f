\ Port of raylib examples/shaders/shaders_basic_pbr.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

Camera: camera
   2e 2e 2e :Camera.position
   0e 0e 0e :Camera.target
   0e 1e 0e :Camera.up
   45e      :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

CREATE shd 32 ALLOT
CREATE mdl 128 ALLOT
CREATE tex 32 ALLOT
0e 0e 0e Vector3: position

: example
   screenWidth screenHeight z" raylib [shaders] example - basic pbr" InitWindow
   shd z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/pbr.vs" z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/pbr.fs" LoadShader drop

   mdl z" /home/dave/Code/raylib/examples/shaders/resources/models/old_car_new.glb" LoadModel drop
   tex z" /home/dave/Code/raylib/examples/shaders/resources/old_car_d.png" LoadTexture drop
   mdl tex set-diffuse
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
         z" PBR simplified (default maps)" 10 10 20 DARKGRAY DrawText
         10 40 DrawFPS
      EndDrawing
   WindowShouldClose until
   shd UnloadShader
   tex UnloadTexture
   mdl UnloadModel
   CloseWindow ;

example-end
