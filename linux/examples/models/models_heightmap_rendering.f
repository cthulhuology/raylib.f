\ Port of raylib examples/models/models_heightmap_rendering.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

Camera: camera
   18e 21e 18e :Camera.position
   0e  0e  0e  :Camera.target
   0e  1e  0e  :Camera.up
   45e         :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

CREATE img  32 ALLOT
CREATE tex  32 ALLOT
CREATE mesh 128 ALLOT
CREATE mdl  128 ALLOT
16e 8e 16e Vector3: mapSize
-8e 0e -8e Vector3: mapPosition

: example
   screenWidth screenHeight z" raylib [models] example - heightmap rendering" InitWindow
   img z" /home/dave/Code/raylib/examples/models/resources/heightmap.png" LoadImage drop
   tex img LoadTextureFromImage drop
   mesh img mapSize GenMeshHeightmap drop
   mdl mesh LoadModelFromMesh drop
   mdl tex set-diffuse
   img UnloadImage
   60 SetTargetFPS
   begin
      camera CAMERA_ORBITAL UpdateCamera
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D
            mdl mapPosition 1e RED DrawModel
            20 1e DrawGrid
         EndMode3D
         tex screenWidth tex tex.w - 20 - 20 WHITE DrawTexture
         screenWidth tex tex.w - 20 -  20  tex tex.w  tex tex.h  GREEN DrawRectangleLines
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   tex UnloadTexture
   mdl UnloadModel
   CloseWindow ;

example-end
