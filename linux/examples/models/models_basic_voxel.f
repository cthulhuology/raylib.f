\ Port of raylib examples/models/models_basic_voxel.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
8 CONSTANT WORLD_SIZE

Camera: camera
   -2e 0e -2e :Camera.position
   0e  0e  0e :Camera.target
   0e  1e  0e :Camera.up
   45e        :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

CREATE mesh 128 ALLOT
CREATE cube 128 ALLOT
CREATE voxels WORLD_SIZE WORLD_SIZE * WORLD_SIZE * ALLOT
CREATE ray 32 ALLOT
CREATE box 32 ALLOT
CREATE hit 32 ALLOT
CREATE center 8 ALLOT
CREATE pos 16 ALLOT
0e 0e 0e Vector3: origin3

: voxel ( x y z -- addr )
   WORLD_SIZE * + WORLD_SIZE * + voxels + ;

: example
   screenWidth screenHeight z" raylib [models] example - basic voxel" InitWindow
   DisableCursor
   mesh 1e 1e 1e GenMeshCube drop
   cube mesh LoadModelFromMesh drop
   voxels WORLD_SIZE WORLD_SIZE * WORLD_SIZE * 1 fill
   60 SetTargetFPS
   begin
      camera CAMERA_FIRST_PERSON UpdateCamera
      MOUSE_BUTTON_LEFT IsMouseButtonPressed if
         screenWidth 2/ s>f screenHeight 2/ s>f center Vector2!
         ray center camera GetScreenToWorldRay drop
         WORLD_SIZE 0 do
            WORLD_SIZE 0 do
               WORLD_SIZE 0 do
                  i j k voxel c@ if
                     i s>f 0.5e f-  j s>f 0.5e f-  k s>f 0.5e f-
                     i s>f 0.5e f+  j s>f 0.5e f+  k s>f 0.5e f+
                     box BoundingBox!
                     hit ray box GetRayCollisionBox drop
                     hit @ if 0 i j k voxel c! then
                  then
               loop
            loop
         loop
      then
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D
            WORLD_SIZE 0 do
               WORLD_SIZE 0 do
                  WORLD_SIZE 0 do
                     i j k voxel c@ if
                        i s>f j s>f k s>f pos Vector3!
                        cube pos 1e BEIGE DrawModel
                     then
                  loop
               loop
            loop
            10 1e DrawGrid
         EndMode3D
         screenWidth 2/ 10 - screenHeight 2/ 10 - 20 20 DARKGRAY DrawRectangleLines
         z" Left click to remove a voxel" 10 10 20 DARKGRAY DrawText
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   cube UnloadModel
   CloseWindow ;

example-end
