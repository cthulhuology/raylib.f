\ Port of raylib examples/core/core_3d_camera_mode.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

Camera: camera
   0.0e 10.0e 10.0e :Camera.position
   0.0e  0.0e  0.0e :Camera.target
   0.0e  1.0e  0.0e :Camera.up
   45.0e            :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

0.0e 0.0e 0.0e Vector3: cubePosition

: example
   screenWidth screenHeight z" raylib [core] example - 3d camera mode" InitWindow
   60 SetTargetFPS
   begin
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D
            cubePosition 2e 2e 2e RED DrawCube
            cubePosition 2e 2e 2e MAROON DrawCubeWires
            10 1e DrawGrid
         EndMode3D
         z" Welcome to the third dimension!" 10 40 20 DARKGRAY DrawText
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
