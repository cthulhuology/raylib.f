\ Port of raylib examples/models/models_rotating_cube.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

Camera: camera
   0e 3e 3e :Camera.position
   0e 0e 0e :Camera.target
   0e 1e 0e :Camera.up
   45e      :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

CREATE mesh 128 ALLOT
CREATE mdl  128 ALLOT
CREATE img  32 ALLOT
CREATE crop 32 ALLOT
CREATE tex  32 ALLOT
CREATE rec  16 ALLOT
0e 0e 0e Vector3: pos
0.5e 1e 0e Vector3: axis
1e 1e 1e Vector3: scl
CREATE rotation 4 ALLOT

: example
   screenWidth screenHeight z" raylib [models] example - rotating cube" InitWindow
   mesh 1e 1e 1e GenMeshCube drop
   mdl mesh LoadModelFromMesh drop
   img z" /home/dave/Code/raylib/examples/models/resources/cubicmap_atlas.png" LoadImage drop
   0e  img img.h s>f 2e f/  img img.w s>f 2e f/  img img.h s>f 2e f/  rec Rectangle!
   crop img rec ImageFromImage drop
   tex crop LoadTextureFromImage drop
   img UnloadImage  crop UnloadImage
   mdl tex set-diffuse
   0e rotation sf!
   60 SetTargetFPS
   begin
      rotation sf@ 1e f+ rotation sf!
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D
            mdl pos axis rotation sf@ scl WHITE DrawModelEx
            10 1e DrawGrid
         EndMode3D
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   tex UnloadTexture
   mdl UnloadModel
   CloseWindow ;

example-end
