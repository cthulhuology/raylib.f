\ Port of raylib examples/models/models_point_rendering.c
\ Custom point-cloud mesh simplified to GenMeshSphere + DrawModelPoints.

800 CONSTANT screenWidth
450 CONSTANT screenHeight

Camera: camera
   3e 3e 3e :Camera.position
   0e 0e 0e :Camera.target
   0e 1e 0e :Camera.up
   45e      :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

CREATE mesh 128 ALLOT
CREATE mdl 128 ALLOT
0e 0e 0e Vector3: position
VARIABLE useDrawModelPoints

: example
   true useDrawModelPoints !
   screenWidth screenHeight z" raylib [models] example - point rendering" InitWindow
   mesh 1e 16 16 GenMeshSphere drop
   mdl mesh LoadModelFromMesh drop
   begin
      camera CAMERA_ORBITAL UpdateCamera
      KEY_SPACE IsKeyPressed if useDrawModelPoints @ 0= useDrawModelPoints ! then
      BeginDrawing
         BLACK ClearBackground
         camera BeginMode3D
            useDrawModelPoints @ if
               mdl position 1e WHITE DrawModelPoints
            else
               mdl position 1e WHITE DrawModelWires
            then
            position 1e 10 10 YELLOW DrawSphereWires
         EndMode3D
         z" Point cloud simplified to sphere mesh" 20 70 20 WHITE DrawText
         z" Space - drawing function" 20 100 20 WHITE DrawText
         useDrawModelPoints @ if
            z" Using: DrawModelPoints()" 20 160 20 GREEN DrawText
         else
            z" Using: DrawModelWires()" 20 160 20 RED DrawText
         then
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   mdl UnloadModel
   CloseWindow ;

example-end
