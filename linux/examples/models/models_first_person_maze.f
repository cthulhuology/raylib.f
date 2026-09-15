\ Port of raylib examples/models/models_first_person_maze.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

Camera: camera
   0.2e 0.4e 0.2e :Camera.position
   0.185e 0.4e 0e :Camera.target
   0e 1e 0e       :Camera.up
   45e            :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

CREATE imMap 32 ALLOT
CREATE cubicmap 32 ALLOT
CREATE mesh 128 ALLOT
CREATE mdl 128 ALLOT
CREATE tex 32 ALLOT
VARIABLE pixels
1e 1e 1e Vector3: cubeSize
-16e 0e -8e Vector3: mapPosition
CREATE oldPos 16 ALLOT
CREATE playerPos 8 ALLOT
CREATE cellrec 16 ALLOT
CREATE pos2 8 ALLOT
VARIABLE cellX
VARIABLE cellY
0.1e fconstant playerRadius

: example
   screenWidth screenHeight z" raylib [models] example - first person maze" InitWindow
   imMap z" /home/dave/Code/raylib/examples/models/resources/cubicmap.png" LoadImage drop
   cubicmap imMap LoadTextureFromImage drop
   mesh imMap cubeSize GenMeshCubicmap drop
   mdl mesh LoadModelFromMesh drop
   tex z" /home/dave/Code/raylib/examples/models/resources/cubicmap_atlas.png" LoadTexture drop
   mdl tex set-diffuse
   imMap LoadImageColors pixels !
   imMap UnloadImage
   DisableCursor
   60 SetTargetFPS
   begin
      camera oldPos 12 move
      camera CAMERA_FIRST_PERSON UpdateCamera
      camera .x camera 8 + sf@ playerPos Vector2!
      playerPos v2x mapPosition .x f- 0.5e f+ f>s cellX !
      playerPos v2y mapPosition .z f- 0.5e f+ f>s cellY !
      cellX @ 0 max cubicmap tex.w 1- min cellX !
      cellY @ 0 max cubicmap tex.h 1- min cellY !
      cubicmap tex.h 0 do
         cubicmap tex.w 0 do
            pixels @ j cubicmap tex.w * i + 4 * + c@ 255 = if
               mapPosition .x 0.5e f- i s>f f+
               mapPosition .z 0.5e f- j s>f f+
               1e 1e cellrec Rectangle!
               playerPos playerRadius cellrec CheckCollisionCircleRec if
                  oldPos camera 12 move
               then
            then
         loop
      loop
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D
            mdl mapPosition 1e WHITE DrawModel
         EndMode3D
         GetScreenWidth s>f cubicmap tex.w s>f 4e f* f- 20e f- 20e pos2 Vector2!
         cubicmap pos2 0e 4e WHITE DrawTextureEx
         GetScreenWidth cubicmap tex.w 4 * - 20 -  20
            cubicmap tex.w 4 * cubicmap tex.h 4 * GREEN DrawRectangleLines
         GetScreenWidth cubicmap tex.w 4 * - 20 - cellX @ 4 * +
            20 cellY @ 4 * +  4 4 RED DrawRectangle
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   pixels @ UnloadImageColors
   cubicmap UnloadTexture
   tex UnloadTexture
   mdl UnloadModel
   CloseWindow ;

example-end
