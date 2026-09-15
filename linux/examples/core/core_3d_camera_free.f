\ Port of raylib examples/core/core_3d_camera_free.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

Camera: camera
   10.0e 10.0e 10.0e :Camera.position
    0.0e  0.0e  0.0e :Camera.target
    0.0e  1.0e  0.0e :Camera.up
   45.0e             :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

0.0e 0.0e 0.0e Vector3: cubePosition

: example
   screenWidth screenHeight z" raylib [core] example - 3d camera free" InitWindow
   DisableCursor
   60 SetTargetFPS
   begin
      camera CAMERA_FREE UpdateCamera
      KEY_Z IsKeyPressed 1 and if
         0e 0e 0e camera Camera.target Vector3!
      then
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D
            cubePosition 2e 2e 2e RED DrawCube
            cubePosition 2e 2e 2e MAROON DrawCubeWires
            10 1e DrawGrid
         EndMode3D
         10 10 320 93 SKYBLUE 0.5e Fade DrawRectangle
         10 10 320 93 BLUE DrawRectangleLines
         z" Free camera default controls:" 20 20 10 BLACK DrawText
         z" - Mouse Wheel to Zoom in-out" 40 40 10 DARKGRAY DrawText
         z" - Mouse Wheel Pressed to Pan" 40 60 10 DARKGRAY DrawText
         z" - Z to zoom to (0, 0, 0)" 40 80 10 DARKGRAY DrawText
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
