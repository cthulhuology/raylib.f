\ Port of raylib examples/models/models_textured_cube.c
\ rlgl immediate mode replaced with textured GenMeshCube models.

800 CONSTANT screenWidth
450 CONSTANT screenHeight

Camera: camera
   0e 10e 10e :Camera.position
   0e  0e  0e :Camera.target
   0e  1e  0e :Camera.up
   45e        :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

CREATE tex 32 ALLOT
CREATE mesh1 128 ALLOT
CREATE mesh2 128 ALLOT
CREATE mdl1 128 ALLOT
CREATE mdl2 128 ALLOT
-2e 2e 0e Vector3: pos1
 2e 1e 0e Vector3: pos2
2e 4e 2e Vector3: scl1
2e 2e 2e Vector3: scl2

: example
   screenWidth screenHeight z" raylib [models] example - textured cube" InitWindow
   tex z" /home/dave/Code/raylib/examples/models/resources/cubicmap_atlas.png" LoadTexture drop
   mesh1 1e 1e 1e GenMeshCube drop
   mdl1 mesh1 LoadModelFromMesh drop
   mdl1 tex set-diffuse
   mesh2 1e 1e 1e GenMeshCube drop
   mdl2 mesh2 LoadModelFromMesh drop
   mdl2 tex set-diffuse
   60 SetTargetFPS
   begin
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D
            mdl1 pos1 0e 0e 1e v3a Vector3! v3a 0e scl1 WHITE DrawModelEx
            mdl2 pos2 0e 0e 1e v3a Vector3! v3a 0e scl2 WHITE DrawModelEx
            10 1e DrawGrid
         EndMode3D
         z" textured cubes (rlgl DrawCubeTexture approximated)" 10 10 10 DARKGRAY DrawText
         10 30 DrawFPS
      EndDrawing
   WindowShouldClose until
   tex UnloadTexture
   mdl1 UnloadModel
   mdl2 UnloadModel
   CloseWindow ;

example-end
