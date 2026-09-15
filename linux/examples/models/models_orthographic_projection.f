\ Port of raylib examples/models/models_orthographic_projection.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
45e fconstant FOVY_PERSPECTIVE
10e fconstant WIDTH_ORTHOGRAPHIC

Camera: camera
   0e 10e 10e :Camera.position
   0e  0e  0e :Camera.target
   0e  1e  0e :Camera.up
   FOVY_PERSPECTIVE :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

-4e 0e  2e Vector3: p1
-4e 0e -2e Vector3: p2
-1e 0e -2e Vector3: p3
 1e 0e  2e Vector3: p4
 4e 0e -2e Vector3: p5
4.5e -1e 2e Vector3: p6
 1e 0e -4e Vector3: p7

: example
   screenWidth screenHeight z" raylib [models] example - orthographic projection" InitWindow
   60 SetTargetFPS
   begin
      KEY_SPACE IsKeyPressed if
         camera Camera.proj @ CAMERA_PERSPECTIVE = if
            WIDTH_ORTHOGRAPHIC camera Camera.fovy sf!
            CAMERA_ORTHOGRAPHIC camera Camera.proj !
         else
            FOVY_PERSPECTIVE camera Camera.fovy sf!
            CAMERA_PERSPECTIVE camera Camera.proj !
         then
      then
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D
            p1 2e 5e 2e RED DrawCube
            p1 2e 5e 2e GOLD DrawCubeWires
            p2 3e 6e 2e MAROON DrawCubeWires
            p3 1e GREEN DrawSphere
            p4 2e 16 16 LIME DrawSphereWires
            p5 1e 2e 3e 4 SKYBLUE DrawCylinder
            p5 1e 2e 3e 4 DARKBLUE DrawCylinderWires
            p6 1e 1e 2e 6 BROWN DrawCylinderWires
            p7 0e 1.5e 3e 8 GOLD DrawCylinder
            p7 0e 1.5e 3e 8 PINK DrawCylinderWires
            10 1e DrawGrid
         EndMode3D
         z" Press Spacebar to switch camera type" 10 GetScreenHeight 30 - 20 DARKGRAY DrawText
         camera Camera.proj @ CAMERA_ORTHOGRAPHIC = if
            z" ORTHOGRAPHIC" 10 40 20 BLACK DrawText
         else
            z" PERSPECTIVE" 10 40 20 BLACK DrawText
         then
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
