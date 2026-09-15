\ Port of raylib examples/core/core_3d_picking.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

Camera: camera
   10.0e 10.0e 10.0e :Camera.position
    0.0e  0.0e  0.0e :Camera.target
    0.0e  1.0e  0.0e :Camera.up
   45.0e             :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

0.0e 1.0e 0.0e Vector3: cubePosition
2.0e 2.0e 2.0e Vector3: cubeSize

CREATE ray 24 ALLOT
CREATE collision 32 ALLOT
CREATE bbox 24 ALLOT

: example
   ray 24 erase
   collision 32 erase
   screenWidth screenHeight z" raylib [core] example - 3d picking" InitWindow
   60 SetTargetFPS
   begin
      IsCursorHidden 1 and if camera CAMERA_FIRST_PERSON UpdateCamera then
      MOUSE_BUTTON_RIGHT IsMouseButtonPressed 1 and if
         IsCursorHidden 1 and if EnableCursor else DisableCursor then
      then
      MOUSE_BUTTON_LEFT IsMouseButtonPressed 1 and if
         collision ray_hit l@ 0= if
            ray mouse@ camera GetScreenToWorldRay drop
            cubePosition .x cubeSize .x f2/ f-
            cubePosition .y cubeSize .y f2/ f-
            cubePosition .z cubeSize .z f2/ f-
            cubePosition .x cubeSize .x f2/ f+
            cubePosition .y cubeSize .y f2/ f+
            cubePosition .z cubeSize .z f2/ f+
            bbox BoundingBox!
            collision ray bbox GetRayCollisionBox drop
         else
            0 collision ray_hit l!
         then
      then
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D
            collision ray_hit l@ if
               cubePosition cubeSize .x cubeSize .y cubeSize .z RED DrawCube
               cubePosition cubeSize .x cubeSize .y cubeSize .z MAROON DrawCubeWires
               cubePosition cubeSize .x 0.2e f+ cubeSize .y 0.2e f+ cubeSize .z 0.2e f+ GREEN DrawCubeWires
            else
               cubePosition cubeSize .x cubeSize .y cubeSize .z GRAY DrawCube
               cubePosition cubeSize .x cubeSize .y cubeSize .z DARKGRAY DrawCubeWires
            then
            ray MAROON DrawRay
            10 1e DrawGrid
         EndMode3D
         z" Try clicking on the box with your mouse!" 240 10 20 DARKGRAY DrawText
         collision ray_hit l@ if
            z" BOX SELECTED" dup 30 MeasureText screenWidth swap - 2/
            screenHeight s>f 0.1e f* f>s  30 GREEN DrawText
         then
         z" Right click mouse to toggle camera controls" 10 430 10 GRAY DrawText
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
