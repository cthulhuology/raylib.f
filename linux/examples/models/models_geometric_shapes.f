\ Port of raylib examples/models/models_geometric_shapes.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

Camera: camera
   0e 10e 10e :Camera.position
   0e  0e  0e :Camera.target
   0e  1e  0e :Camera.up
   45e        :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

-4e 0e  2e Vector3: p1
-4e 0e -2e Vector3: p2
-1e 0e -2e Vector3: p3
 1e 0e  2e Vector3: p4
 4e 0e -2e Vector3: p5
4.5e -1e 2e Vector3: p6
 1e 0e -4e Vector3: p7
-3e 1.5e -4e Vector3: capA
-4e -1e -4e Vector3: capB

: example
   screenWidth screenHeight z" raylib [models] example - geometric shapes" InitWindow
   60 SetTargetFPS
   begin
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
            capA capB 1.2e 8 8 VIOLET DrawCapsule
            capA capB 1.2e 8 8 PURPLE DrawCapsuleWires
            10 1e DrawGrid
         EndMode3D
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
